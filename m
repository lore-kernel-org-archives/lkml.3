Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab3GWAdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:33:05 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34920 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab3GWAcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:32:53 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1374529321-12955-1-git-send-email-julien.grall@linaro.org>
References: <1374529321-12955-1-git-send-email-julien.grall@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v4] xen/arm: enable PV control for ARM
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 22 Jul 2013 20:32:06 -0400
To: Julien Grall <julien.grall@linaro.org>, stefano.stabellini@eu.citrix.com
CC: ian.campbell@citrix.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org
Message-ID: <5228e08a-1cdb-4240-b10f-9ad690c94ac4@email.android.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julien Grall <julien.grall@linaro.org> wrote:
>Enable power management from the toolstack for ARM guest.
>
>Signed-off-by: Julien Grall <julien.grall@linaro.org>
>
>---
>    Changes in v4:
>        - Divide the patch in 2 distinct parts
>    Changes in v3:
>        - Fix condition to compile cpu_hotplug.o
>    Changes in v2:
>        - Don't compile xen/cpu_hotplug.o with ARM64
>---
> drivers/xen/Makefile |    3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
>diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
>index a609353..f185e8d 100644
>--- a/drivers/xen/Makefile
>+++ b/drivers/xen/Makefile
>@@ -1,9 +1,8 @@
> ifeq ($(filter y, $(CONFIG_ARM) $(CONFIG_ARM64)),)
>-obj-y	+= manage.o
> obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
> endif
> obj-$(CONFIG_X86)			+= fallback.o
>-obj-y	+= grant-table.o features.o events.o balloon.o time.o
>+obj-y	+= grant-table.o features.o events.o balloon.o time.o manage.o
> obj-y	+= xenbus/
> 
> nostackp := $(call cc-option, -fno-stack-protector)

The patch looks Ok but the description is off.  Power management is the term used for cpu freq,  C states and P states. While this patch touches none of that. 
