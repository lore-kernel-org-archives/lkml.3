Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3LDJAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:00:00 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:43837 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab3LDI75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:59:57 -0500
Date: Wed, 4 Dec 2013 09:59:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Regression due to 0c44c2d0f459 x86: Use asm goto to implement
 better modify_and_test() functions
Message-ID: <20131204085953.GC31778@gmail.com>
References: <529E8719.4070202@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529E8719.4070202@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Hi guys,
> 
> 0c44c2d0f459 x86: Use asm goto to implement better modify_and_test()
> functions
> 
> causes a regression, because it incorrectly changed the constraints of
> bitops.
> 
> Specifically, the GEN_BINARY_RMWcc() hardcodes a constraint as "er", but
> it needs to be "Ir" for the bitops themselves.  "I" is correct (as
> opposed to "J" even on 64 bits, because we only generate the 64-bit
> version when we have a register operand.
> 
> Unfortunately there isn't a way we can get gcc+gas to generate a version
> with an offset pointer.

Does the regression manifest itself in any actual breakage - if yes, 
how does it look like? (People experiencing similar symptoms will be 
helped by seeing a fix matching their problems.)

Thanks,

	ngo
