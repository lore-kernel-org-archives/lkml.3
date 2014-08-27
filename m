Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965093AbaH0UaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:30:17 -0400
Received: from gloria.sntech.de ([95.129.55.99]:59994 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964975AbaH0UaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:30:15 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Chris Zhong <zyw@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, olof@lixom.net,
        sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Subject: Re: [PATCH v6 2/5] MFD: RK808: Add new mfd driver for RK808
Date: Wed, 27 Aug 2014 21:53:55 +0200
Message-ID: <3801360.yPqDYLVpxz@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1409062444-12019-1-git-send-email-zyw@rock-chips.com>
References: <1409062444-12019-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Am Dienstag, 26. August 2014, 22:14:04 schrieb Chris Zhong:
> The RK808 chip is a power management IC for multimedia and handheld
> devices. It contains the following components:
> 
> - Regulators
> - RTC
> - Clkout
> 
> The RK808 core driver is registered as a platform driver and provides
> communication through I2C with the host device for the different
> components.
> 
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> Signed-off-by: Zhang Qing <zhangqing@rock-chips.com>
> 
> ---

when testing this with Dougs dts integration I got irq errors like the
following:

INT_STS_REG1: 0x0
INT_STS_MSK_REG1: 0x0
INT_STS_REG2: 0x1
INT_STS_MSK_REG2: 0x0
random: nonblocking pool is initialized
irq 192: nobody cared (try booting with the "irqpoll" option)
CPU: 0 PID: 40 Comm: irq/192-rk808 Not tainted 3.17.0-rc1+ #1015
[<c001461c>] (unwind_backtrace) from [<c0011190>] (show_stack+0x10/0x14)
[<c0011190>] (show_stack) from [<c03e3e04>] (dump_stack+0x6c/0x84)
[<c03e3e04>] (dump_stack) from [<c00508e4>] (__report_bad_irq+0x28/0xb8)
[<c00508e4>] (__report_bad_irq) from [<c0050de4>] (note_interrupt+0x1e8/0x28c)
[<c0050de4>] (note_interrupt) from [<c004ebdc>] (handle_irq_event_percpu+0x104/0x120)
[<c004ebdc>] (handle_irq_event_percpu) from [<c004ec3c>] (handle_irq_event+0x44/0x64)
[<c004ec3c>] (handle_irq_event) from [<c0051910>] (handle_level_irq+0xd4/0x11c)
[<c0051910>] (handle_level_irq) from [<c004e5a8>] (generic_handle_irq+0x20/0x30)
[<c004e5a8>] (generic_handle_irq) from [<c01ba490>] (rockchip_irq_demux+0x190/0x228)
[<c01ba490>] (rockchip_irq_demux) from [<c004e5a8>] (generic_handle_irq+0x20/0x30)
[<c004e5a8>] (generic_handle_irq) from [<c000f060>] (handle_IRQ+0x68/0x90)
[<c000f060>] (handle_IRQ) from [<c000858c>] (gic_handle_irq+0x3c/0x60)
[<c000858c>] (gic_handle_irq) from [<c0011bc0>] (__irq_svc+0x40/0x50)
Exception stack(0xee31bed8 to 0xee31bf20)
bec0:                                                       ee093518 f005e000
bee0: 00000010 000093e9 ee1fe880 ee2f98c0 ee1fe880 ee2f98e0 c004f6f0 00000000
bf00: 00000000 00000000 c03eb6d0 ee31bf20 c00522dc c004f628 60000113 ffffffff
[<c0011bc0>] (__irq_svc) from [<c004f628>] (irq_finalize_oneshot+0xd4/0xf0)
[<c004f628>] (irq_finalize_oneshot) from [<c004f71c>] (irq_thread_fn+0x2c/0x34)
[<c004f71c>] (irq_thread_fn) from [<c004f844>] (irq_thread+0xc4/0x148)
[<c004f844>] (irq_thread) from [<c0035524>] (kthread+0xdc/0xf0)
[<c0035524>] (kthread) from [<c000e7f8>] (ret_from_fork+0x14/0x3c)
handlers:
[<c004ec5c>] irq_default_primary_handler threaded [<c021cc7c>] regmap_irq_thread
Disabling IRQ #192


As you can see there was already a PLUG_IN_INT pending, which stalled the
system till the irq got deactivated after 100000 iterations:

           CPU0       
[...]
 92:     600231       GIC  92  ff650000.i2c
192:     100001  rockchip_gpio_irq   4  rk808


I fixed it up with the following:

------------ 8< ---------------
diff --git a/drivers/mfd/rk808.c b/drivers/mfd/rk808.c
index f0d6518..1c25be7 100644
--- a/drivers/mfd/rk808.c
+++ b/drivers/mfd/rk808.c
@@ -61,8 +61,14 @@ static const struct rk808_reg_data pre_init_reg[] = {
 	{ RK808_BUCK2_CONFIG_REG, BUCK2_RATE_MASK,  BUCK_ILMIN_200MA },
 	{ RK808_VB_MON_REG,       MASK_ALL,         VB_LO_ACT |
 						    VB_LO_SEL_3500MV },
-	{ RK808_INT_STS_REG1,     MASK_NONE,        0 },
-	{ RK808_INT_STS_REG2,     MASK_NONE,        0 },
+
+	/* ack any pending interrupts */
+	{ RK808_INT_STS_REG1,     INT_STS_REG1_MASK, INT_STS_REG1_MASK },
+	{ RK808_INT_STS_REG2,     INT_STS_REG2_MASK, INT_STS_REG2_MASK },
+
+	/* mask all interrupts */
+	{ RK808_INT_STS_MSK_REG1, INT_STS_REG1_MASK, INT_STS_REG1_MASK },
+	{ RK808_INT_STS_MSK_REG2, INT_STS_REG2_MASK, INT_STS_REG2_MASK },
 };
 
 static const struct regmap_irq rk808_irqs[] = {
diff --git a/include/linux/mfd/rk808.h b/include/linux/mfd/rk808.h
index 7af1952..8f8e48c 100644
--- a/include/linux/mfd/rk808.h
+++ b/include/linux/mfd/rk808.h
@@ -156,6 +156,8 @@ enum rk808_reg {
 #define BUCK2_RATE_MASK		(3 << 3)
 #define MASK_ALL	0xff
 #define MASK_NONE	0
+#define INT_STS_REG1_MASK	0x7f
+#define INT_STS_REG2_MASK	0x3
 
 #define SWITCH2_EN	BIT(6)
 #define SWITCH1_EN	BIT(5)
------------ 8< ---------------

On startup I guess all pending irqs should be acked and also masked, as we normally
don't want to handle interrupts that happened way in the past and they
will get unmasked on their own, when one of them gets requested by the rtc
for example.


Heiko

