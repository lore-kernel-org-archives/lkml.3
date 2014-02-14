Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaBNQYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:24:33 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53041 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751105AbaBNQYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:24:31 -0500
Date: Fri, 14 Feb 2014 16:22:57 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Larry Bassel <lbassel@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Jiang Liu <liuj97@gmail.com>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Laura Abbott <lauraa@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Vitaly Andrianov <vitalya@ti.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Simon Baatz <gmbnomis@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ARM: mm: keep rodata non-executable
Message-ID: <20140214162257.GB2331@e103592.cambridge.arm.com>
References: <1392339850-18686-1-git-send-email-keescook@chromium.org>
 <1392339850-18686-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392339850-18686-3-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 05:04:10PM -0800, Kees Cook wrote:
> Introduce "CONFIG_DEBUG_RODATA" to mostly match the x86 config, though
> the behavior is different: it depends on STRICT_KERNMEM_PERMS, which
> sets rodata read-only (but executable), where as this option additionally
> splits rodata from the kernel text (resulting in potentially more memory
> lost to padding) and sets it non-executable as well. The end result is
> that on builds with CONFIG_DEBUG_RODATA=y (like x86) the rodata with be
> marked purely read-only.

This triggers an Oops in kexec, because we have a block of code in .text
which is a template for generating baremetal code to relocate the new
kernel, and some literal words are written into it before copying.

Possibly this should be in .rodata, not .text.

There may be a few other instances of this kind of thing.

Are you aware of similar situations on other arches?

Cheers
---Dave
