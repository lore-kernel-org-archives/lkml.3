Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab3I3L3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:29:15 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:57106 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab3I3L2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:28:10 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the sh tree
Date: Mon, 30 Sep 2013 13:26:10 +0200
Message-Id: <1380540373-25352-8-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380540373-25352-1-git-send-email-treding@nvidia.com>
References: <1380540373-25352-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the sh tree got conflicts in

	arch/sh/kernel/cpu/sh2a/Makefile
	drivers/tty/serial/sh-sci.c
	include/linux/serial_sci.h

I fixed them up (see below). Please check if the resolution looks correct.

Thanks,
Thierry
---
diff --cc arch/sh/kernel/cpu/sh2a/Makefile
index 990195d,130984c..92f0da4
--- a/arch/sh/kernel/cpu/sh2a/Makefile
+++ b/arch/sh/kernel/cpu/sh2a/Makefile
@@@ -21,4 -21,5 +21,5 @@@ pinmux-$(CONFIG_CPU_SUBTYPE_SH7203)	:= 
  pinmux-$(CONFIG_CPU_SUBTYPE_SH7264)	:= pinmux-sh7264.o
  pinmux-$(CONFIG_CPU_SUBTYPE_SH7269)	:= pinmux-sh7269.o
  
 -obj-$(CONFIG_GENERIC_GPIO)		+= $(pinmux-y)
 +obj-$(CONFIG_GPIOLIB)			+= $(pinmux-y)
+ obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= ubc.o
diff --cc drivers/tty/serial/sh-sci.c
index 5377502,e3847cc..d262c1f
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@@ -2481,9 -2502,20 +2588,20 @@@ static int sci_probe(struct platform_de
  	if (is_early_platform_device(dev))
  		return sci_probe_earlyprintk(dev);
  
+ 	if (dev->dev.of_node)
+ 		p = sci_parse_dt(dev, &dev_id);
+ 	else
 -		p = dev->dev.platform_data;
++		p = dev_get_platdata(&dev->dev);
+ 
+ 	if (!p) {
+ 		dev_err(&dev->dev, "no setup data supplied\n");
+ 		return -EINVAL;
+ 	}
+ 
+ 	sp = &sci_ports[dev_id];
  	platform_set_drvdata(dev, sp);
  
- 	ret = sci_probe_single(dev, dev->id, p, sp);
+ 	ret = sci_probe_single(dev, dev_id, p, sp);
  	if (ret)
  		return ret;
  
diff --cc include/linux/serial_sci.h
index 50fe651,857eec4..3dbdf7e
--- a/include/linux/serial_sci.h
+++ b/include/linux/serial_sci.h
@@@ -16,7 -18,8 +18,9 @@@ enum 
  	SCBRR_ALGO_3,		/* (((clk * 2) + 16 * bps) / (16 * bps) - 1) */
  	SCBRR_ALGO_4,		/* (((clk * 2) + 16 * bps) / (32 * bps) - 1) */
  	SCBRR_ALGO_5,		/* (((clk * 1000 / 32) / bps) - 1) */
 +	SCBRR_ALGO_6,		/* HSCIF variable sample rate algorithm */
+ 
+ 	SCBRR_NR_ALGOS,
  };
  
  #define SCSCR_TIE	(1 << 7)
