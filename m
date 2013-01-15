Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab3AOSvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:51:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:33937 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757581Ab3AOSvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:51:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 001/221] regulator: wm831x: Set the new rather than old value for DVS VSEL
Date: Tue, 15 Jan 2013 10:48:48 -0800
Message-Id: <20130115184958.143715636@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 13ae633cf729b0ecb677b75b04886ff8fada8fad upstream.

Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/wm831x-dcdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -290,7 +290,7 @@ static int wm831x_buckv_set_voltage_sel(
 	if (vsel > dcdc->dvs_vsel) {
 		ret = wm831x_set_bits(wm831x, dvs_reg,
 				      WM831X_DC1_DVS_VSEL_MASK,
-				      dcdc->dvs_vsel);
+				      vsel);
 		if (ret == 0)
 			dcdc->dvs_vsel = vsel;
 		else


