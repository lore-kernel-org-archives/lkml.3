Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaICHNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:13:18 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.25]:60339 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaICHNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:13:17 -0400
Message-ID: <5406BF88.8040102@ladisch.de>
Date: Wed, 03 Sep 2014 09:13:12 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Scotty Bauer <sbauer@eng.utah.edu>, linux-kernel@vger.kernel.org
Subject: Re: Compat sysinfo syscall (kernel/sys.c) relying on undefined behavior?
References: <54062A22.6090804@eng.utah.edu>
In-Reply-To: <54062A22.6090804@eng.utah.edu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scotty Bauer wrote:
> In the compat version of sysinfo, kernel/sys.c we see the following:
>
>     /* Check to see if any memory value is too large for 32-bit and scale
>      *  down if needed
>      */
>     if ((s.totalram >> 32) || (s.totalswap >> 32)) {

This code is supposed to check if any of the bits in the upper half of
these 64-bit values are set.

> s.totalram is a u32

Oops.

> the behavior is undefined.

For a constant shift amount, gcc happens to generate correct code, i.e.,
the result is zero.  (If the shift amount were not a constant, x86
processors would use only its lowest five bits, and the result would be
wrong.)

Anyway, it's not a good idea to rely on gcc's implementation of this
undefined behaviour; the code should have used upper_32_bits() instead.
Please write a patch.


Regards,
Clemens
