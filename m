Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbbA2Pqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:46:52 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:46045 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbbA2Pqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:46:50 -0500
Date: Thu, 29 Jan 2015 15:46:25 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 0/2] Fix secondary CPU boot for thumb2 kernels
Message-ID: <20150129154624.GH8951@e104818-lin.cambridge.arm.com>
References: <1421869698-27341-1-git-send-email-sboyd@codeaurora.org>
 <54C94511.30508@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C94511.30508@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 08:22:41PM +0000, Stephen Boyd wrote:
> On 01/21/15 11:48, Stephen Boyd wrote:
> > Currently I can't boot up secondary CPUs on qcom platforms when I
> > compile the kernel for THUMB2 mode. This is because we always enter
> > the kernel in ARM mode regardless of what mode the kernel is compiled
> > for. This patchset adds a small wrapper to secondary_startup() called
> > secondary_startup_arm() that allows us to switch into THUMB2 mode if
> > we need to. If the kernel is compiled for ARM mode it shouldn't have
> > any effect.
> >
> > Stephen Boyd (2):
> >   ARM: Add a secondary_startup that assumes ARM mode
> >   ARM: qcom: Use secondary_startup_arm()
> >
> >  arch/arm/kernel/head.S       | 7 +++++++
> >  arch/arm/mach-qcom/platsmp.c | 4 ++--
> >  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> Any comments here? Perhaps I can send this through the patch tracker?

FWIW, they look fine to me.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

I guess the reason it works fine on other platforms is because the
secondary start address we pass to firmware has bit 0 set and this
causes the jump to the kernel in Thumb-2 mode.

Catalin
