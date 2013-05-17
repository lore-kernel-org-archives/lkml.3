Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3EQHH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 03:07:56 -0400
Received: from fornax3.0.iobloggo.com ([188.40.97.208]:36995 "EHLO
	mail.1.iobloggo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab3EQHHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 03:07:54 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 May 2013 03:07:54 EDT
Message-ID: <5195D615.70608@cateee.net>
Date: Fri, 17 May 2013 09:02:45 +0200
From: Giacomo Catenazzi <cate@cateee.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/clk/sunxi/clk-sunxi.c: small improvement of code
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Emilio,

please apply the following patch: "cpu_data" is defined in a header files of architectures.
In some architecture, the #define cpu_data is not a "macro-function", so the compiler will substitute the identifier with probably something wrong.


--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -239,7 +239,7 @@ struct mux_data {
        u8 shift;
 };

-static const __initconst struct mux_data cpu_data = {
+static const __initconst struct mux_data this_cpu_data = {
        .shift = 16,
 };

@@ -421,7 +421,7 @@ static const __initconst struct of_device_id clk_div_match[] = {

 /* Matches for mux clocks */
 static const __initconst struct of_device_id clk_mux_match[] = {
-       {.compatible = "allwinner,sun4i-cpu-clk", .data = &cpu_data,},
+       {.compatible = "allwinner,sun4i-cpu-clk", .data = &this_cpu_data,},
        {.compatible = "allwinner,sun4i-apb1-mux-clk", .data = &apb1_mux_data,},
        {}
 };



Signed-off-by: Giacomo A. Catenazzi <cate@cateee.net>

ciao
	cate
