Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3IFU4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 16:56:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47076 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3IFU4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:56:07 -0400
Date: Fri, 6 Sep 2013 15:55:38 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: msm: Remove irqs-*.h files for DT based targets
Message-ID: <20130906205538.GK808@joshc.qualcomm.com>
References: <20130906195300.GJ808@joshc.qualcomm.com>
 <1378499517-24014-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378499517-24014-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 01:31:57PM -0700, Stephen Boyd wrote:
> We don't want or need the irqs.h files from the DT based MSM
> targets. Remove these header files and select sparse irq so that
> we don't try to include the mach/irqs.h file.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> On 09/06, Josh Cartwright wrote:
> > 
> > Selecting _only_ ARCH_MSM8974 with these changes breaks the build with:
> 
> I've been meaning to fix this. Perhaps you can use this patch as a base
> and then push the SPARSE_IRQ selection into the DT config?

Sounds sane to me.  AFAICT, we didn't yet have any users of these
defines upstream.  Using SPARSE_IRQ puts on the path of multiplatform
support anyway.

FWIW, I tested this by applying this change under Rohit's and squashing
the following with patch 1/2:

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index fe35acf..f4a0aaa 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -50,7 +50,6 @@ config ARCH_MSM8X60
 	select HAVE_SMP
 	select MSM_SCM if SMP
 	select USE_OF
-	select SPARSE_IRQ
 
 config ARCH_MSM8960
 	bool "MSM8960"
@@ -60,7 +59,6 @@ config ARCH_MSM8960
 	select GPIO_MSM_V2
 	select MSM_SCM if SMP
 	select USE_OF
-	select SPARSE_IRQ
 
 config ARCH_MSM8974
 	bool "MSM8974"
@@ -74,6 +72,7 @@ config ARCH_MSM8974
 config ARCH_MSM_DT
 	def_bool y
 	depends on (ARCH_MSM8X60 || ARCH_MSM8960 || ARCH_MSM8974)
+	select SPARSE_IRQ
 
 config MSM_HAS_DEBUG_UART_HS
 	bool
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
