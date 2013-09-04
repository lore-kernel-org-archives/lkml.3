Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762631Ab3IDNzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 09:55:48 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:34543 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab3IDNzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 09:55:46 -0400
Date: Wed, 4 Sep 2013 14:55:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, mark.rutland@arm.com
Subject: [PATCH v2 02/11] ARM: ux500: Enable the LPS001WP Pressure &
 Temperature sensor from DT
Message-ID: <20130904135540.GK20150@lee--X1>
References: <1378287103-21765-1-git-send-email-lee.jones@linaro.org>
 <1378287103-21765-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378287103-21765-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After applying this node the LPS001WP sensor chip should probe
successfully once the driver support has also been applied.
    
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/arch/arm/boot/dts/ste-snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
index cf9b16e..dc556d1 100644
--- a/arch/arm/boot/dts/ste-snowball.dts
+++ b/arch/arm/boot/dts/ste-snowball.dts
@@ -153,6 +153,16 @@
                        status = "okay";
                };
 
+               i2c@80128000 {
+                       lps001wp@5c {
+                               compatible = "st,lps001wp";
+                               reg = <0x5c>;
+
+                               vdd-supply = <&ab8500_ldo_aux1_reg>;
+                               vms-supply = <&db8500_vsmps2_reg>;
+                       };
+               };
+
                uart@80120000 {
                        status = "okay";
                };
