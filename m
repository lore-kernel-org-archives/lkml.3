Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934816Ab3FSQfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:35:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57677 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027Ab3FSQe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:34:57 -0400
Date: Wed, 19 Jun 2013 09:34:56 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH/RESEND 11/12] ARM: msm: Make proc_comm clock control
 into a platform driver
Message-ID: <20130619163456.GB6300@codeaurora.org>
References: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
 <1371490999-15501-12-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371490999-15501-12-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Stephen Boyd wrote:
> diff --git a/arch/arm/mach-msm/devices.h b/arch/arm/mach-msm/devices.h
> index da902cf..dccefad 100644
> --- a/arch/arm/mach-msm/devices.h
> +++ b/arch/arm/mach-msm/devices.h
> @@ -16,10 +16,6 @@
>  #ifndef __ARCH_ARM_MACH_MSM_DEVICES_H
>  #define __ARCH_ARM_MACH_MSM_DEVICES_H
>  
> -#include <linux/clkdev.h>
> -
> -#include "clock.h"
> -

This removal causes a build failure on 7x30/8x50. Please squash in
this small fixup when applying.

---8<-----
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index be45136..d4db75a 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -28,6 +28,7 @@
 
 #include <asm/mach/flash.h>
 
+#include "clock.h"
 #include "clock-pcom.h"
 
 #include <linux/platform_data/mmc-msm_sdcc.h>
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index 3fd8f88..f551811 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -28,6 +28,7 @@
 #include <asm/mach/flash.h>
 
 #include <linux/platform_data/mmc-msm_sdcc.h>
+#include "clock.h"
 #include "clock-pcom.h"
 
 static struct resource msm_gpio_resources[] = {

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
