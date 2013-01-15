Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab3AOWou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:44:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:44801 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758048Ab3AOWop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:44:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 001/171] regulator: wm831x: Set the new rather than old value for DVS VSEL
Date: Tue, 15 Jan 2013 14:42:46 -0800
Message-Id: <20130115224313.513986733@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -330,7 +330,7 @@ static int wm831x_buckv_set_voltage(stru
 	if (vsel > dcdc->dvs_vsel) {
 		ret = wm831x_set_bits(wm831x, dvs_reg,
 				      WM831X_DC1_DVS_VSEL_MASK,
-				      dcdc->dvs_vsel);
+				      vsel);
 		if (ret == 0)
 			dcdc->dvs_vsel = vsel;
 		else


