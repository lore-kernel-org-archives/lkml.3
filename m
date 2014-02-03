Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaBCKfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:35:04 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50197 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391AbaBCKfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:35:00 -0500
Date: Mon, 3 Feb 2014 10:34:15 +0000
From: Will Deacon <will.deacon@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "msalter@redhat.com" <msalter@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 2/5] arm: add new asm macro update_sctlr
Message-ID: <20140203103415.GA12187@mudshark.cambridge.arm.com>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-3-git-send-email-leif.lindholm@linaro.org>
 <20140122112055.GF1621@mudshark.cambridge.arm.com>
 <20140129182805.GF11329@bivouac.eciton.net>
 <1391029124.2488.50.camel@deneb.redhat.com>
 <20140130131247.GG11329@bivouac.eciton.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130131247.GG11329@bivouac.eciton.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 01:12:47PM +0000, Leif Lindholm wrote:
> Oh, that's neat - thanks!
> 
> Well, given that, I can think of two less horrible options:
> 1)
> 	.macro  update_sctlr, tmp:req, set=, clear=
>         mrc	p15, 0, \tmp, c1, c0, 0
> 	.ifnc	\set,
>         orr	\tmp, \set
> 	.endif
> 	.ifnc	\clear,
> 	mvn	\clear, \clear
> 	and	\tmp, \tmp, \clear

Can't you use bic here?

> 	.endif
>         mcr	p15, 0, \tmp, c1, c0, 0
> 	.endm
> 
> With the two call sites in uefi_phys.S as:
> 
> 	ldr	r5, =(CR_M)
> 	update_sctlr	r12, , r5
> and
> 	ldr	r4, =(CR_I | CR_C | CR_M)
> 	update_sctlr	r12, r4

These ldr= could be movs, right?

If so, I definitely prefer this to putting an ldr = into the macro itself
(option 2).

Cheers,

Will
