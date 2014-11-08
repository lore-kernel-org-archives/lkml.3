Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaKHR0j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 12:26:39 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:34482 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaKHR0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 12:26:37 -0500
X-ME-Helo: beldin
X-ME-Date: Sat, 08 Nov 2014 18:26:33 +0100
X-ME-IP: 109.222.82.103
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Daniel Mack <zonque@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 0/3] Transition pxa25x clock to common clocks
References: <1414941415-13146-1-git-send-email-robert.jarzmik@free.fr>
	<CALT56yOCBN1NAfNw=vThVZ_o=ONGOTvzKHBH5tCTQShJY0wkrQ@mail.gmail.com>
X-URL: http://belgarath.falguerolles.org/
Date: Sat, 08 Nov 2014 18:26:27 +0100
In-Reply-To: <CALT56yOCBN1NAfNw=vThVZ_o=ONGOTvzKHBH5tCTQShJY0wkrQ@mail.gmail.com>
	(Dmitry Eremin-Solenikov's message of "Thu, 6 Nov 2014 12:45:02
	+0400")
Message-ID: <87lhnlwqm4.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> writes:

> Hello,
> Tested in qemu (pxa25x target).
>
> 2) sa1100-rtc could not find a clock and thus failed to be probed.
> 4) Got an issue with IrDA driver - it gets -ENODEV for UARTCLK clock

Hi Dmitry,

Would you mind retesting with the patch in [1] applied to see if points 2 and 4
are fixed ? Alternatively you can refetch from the github tree, I included that
incremental patch there too.

If it works correctly for you, could I have your Tested-by ? If not, tell me and
I'll try to figure out what's wrong.

Cheers.

-- 
Robert

[1]

--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-fixup-clk-add-pxa25x-clock-drivers.patch

>From 7f43d2f9c9d415b8bc1ed7e2f3e422de349d6957 Mon Sep 17 00:00:00 2001
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 8 Nov 2014 18:20:18 +0100
Subject: [PATCH] fixup! clk: add pxa25x clock drivers

---
 drivers/clk/pxa/clk-pxa25x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/pxa/clk-pxa25x.c b/drivers/clk/pxa/clk-pxa25x.c
index db07d4b..fb73e58 100644
--- a/drivers/clk/pxa/clk-pxa25x.c
+++ b/drivers/clk/pxa/clk-pxa25x.c
@@ -127,7 +127,6 @@ static struct desc_clk_cken pxa25x_clocks[] __initdata = {
 	PXA25X_PBUS147_CKEN("pxa2xx-uart.1", NULL, BTUART, 1, 10, 1),
 	PXA25X_PBUS147_CKEN("pxa2xx-uart.2", NULL, STUART, 1, 10, 1),
 	PXA25X_PBUS147_CKEN("pxa2xx-uart.3", NULL, HWUART, 1, 10, 1),
-	PXA25X_PBUS147_CKEN("pxa2xx-ir", "UARTCLK", STUART, 1, 10, 1),
 	PXA25X_PBUS147_CKEN("pxa2xx-i2s", NULL, I2S, 1, 1, 0),
 	PXA25X_PBUS147_CKEN(NULL, "AC97CLK", AC97, 1, 12, 0),
 	PXA25X_OSC3_CKEN("pxa25x-ssp.0", NULL, SSP, 1, 1, 0),
@@ -233,8 +232,9 @@ static struct dummy_clk dummy_clks[] __initdata = {
 	DUMMY_CLK(NULL, "pxa26x-gpio", "osc_32_768khz"),
 	DUMMY_CLK("GPIO11_CLK", NULL, "osc_3_6864mhz"),
 	DUMMY_CLK("GPIO12_CLK", NULL, "osc_32_768khz"),
-	DUMMY_CLK("sa1100-rtc", NULL, "osc_32_768khz"),
+	DUMMY_CLK(NULL, "sa1100-rtc", "osc_32_768khz"),
 	DUMMY_CLK("OSTIMER0", NULL, "osc_32_768khz"),
+	DUMMY_CLK("UARTCLK", "pxa2xx-ir", "STUART"),
 };
 
 static void __init pxa25x_dummy_clocks_init(void)
-- 
2.1.0


--=-=-=--
