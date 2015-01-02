Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750763AbbABG31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 01:29:27 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:58272 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbbABG30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 01:29:26 -0500
Date: Fri, 2 Jan 2015 07:29:20 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Jeff Epler <jepler@unpythonic.net>
Cc: linux-man <linux-man@vger.kernel.org>,
        Laurent Georget <laurent.georget@supelec.fr>,
        linux-kernel@vger.kernel.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] adjtimex: PPM scaling is by 2^-16
Message-ID: <20150102062920.GB4221@localhost.localdomain>
References: <54A2DEAD.2050708@supelec.fr>
 <20150102024118.GA8293@unpythonic.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150102024118.GA8293@unpythonic.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2015 at 08:41:20PM -0600, Jeff Epler wrote:
> Like Laurent Georget, I found by reading ntpd source
> the scale is 2^16 (i.e., 1 ~= 1.5e-5 ppm, 65536 = 1ppm)

Yep, you wont find this documented in prose anywhere, not even at
ntp.org.

> -    long freq;        /* Frequency offset, as scaled PPM
> +    long freq;        /* Frequency offset, in units of 2^-16 PPM
>                           (parts per million) */

This wording is correct.

IMHO, it is more understandable when you explain that this field is a
fixed point number, with a 16 bit binary fraction. For example, see
the comment in the function, ppb_to_scaled_ppm(), in
Documentation/ptp/testptp.c.


Thanks,
Richard
