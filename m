Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3HPJE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 05:04:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:38288 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3HPJEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 05:04:53 -0400
Date: Fri, 16 Aug 2013 11:04:50 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, dmitry.torokhov@gmail.com, sameo@linux.intel.com,
        lee.jones@linaro.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 2/4] input: ti_am335x_tsc: Increase sequencer delay time
Message-ID: <20130816090450.GB26895@linutronix.de>
References: <1376412499-21007-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376412499-21007-3-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1376412499-21007-3-git-send-email-zubair.lutfullah@gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zubair Lutfullah | 2013-08-13 17:48:17 [+0100]:

>diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
>index e165fcb..766bc7e 100644
>--- a/drivers/input/touchscreen/ti_am335x_tsc.c
>+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
>@@ -31,7 +31,7 @@
> #include <linux/mfd/ti_am335x_tscadc.h>
> 
> #define ADCFSM_STEPID		0x10
>-#define SEQ_SETTLE		275
>+#define SEQ_SETTLE		350
> #define MAX_12BIT		((1 << 12) - 1)

Okay, if this is required then it is. But in the long turn we should
make this interrupt threaded since this delay in interrupt context is
way too long.

Sebastian
