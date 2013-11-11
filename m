Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3KKLcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:32:06 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:47376 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab3KKLb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:31:56 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2] staging: comedi: fix potentially uninitialised variable
In-Reply-To: <20131110212835.GB5302@mwanda>
Organization: http://mina86.com/
References: <1384108669-23392-1-git-send-email-mpn@google.com> <20131110212835.GB5302@mwanda>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131111:gregkh@linuxfoundation.org::hgL6fuW+kiIQENg8:000000000000000000000000000000000000X08
X-Hashcash: 1:20:131111:dan.carpenter@oracle.com::vqiRcmNlunES6a4a:00000000000000000000000000000000000000Gd7
X-Hashcash: 1:20:131111:abbotti@mev.co.uk::sZWuXdfKgOVGac4t:000000000000000000000000000000000000000000002bZz
X-Hashcash: 1:20:131111:linux-kernel@vger.kernel.org::t0aMUWsSqGyu5BQY:0000000000000000000000000000000003w4A
X-Hashcash: 1:20:131111:hsweeten@visionengravers.com::9MLjG1VfDkxJQOGx:000000000000000000000000000000000DUsO
X-Hashcash: 1:20:131111:devel@driverdev.osuosl.org::T/L7iKiXhR3YB/SQ:00000000000000000000000000000000000Cyb0
Date: Mon, 11 Nov 2013 12:31:51 +0100
Message-ID: <xa1t38n3yy1k.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If none of the if conditions take a true path, the ret variable will
never be assigned a value.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/staging/comedi/drivers/vmk80xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

On Sun, Nov 10 2013, Dan Carpenter wrote:
> Don't use a From: unless you are sending it on behalf of another sender.
>
> You need a Signed-off-by line and it has to match your email address
> which you used to send the email.

Sorry about that, forgot about “-s”.

> Otherwise, the patch is good an fixes an important bug.

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 933b01a..0adf3cf 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -465,7 +465,7 @@ static int vmk80xx_do_insn_bits(struct comedi_device *dev,
 	unsigned char *rx_buf = devpriv->usb_rx_buf;
 	unsigned char *tx_buf = devpriv->usb_tx_buf;
 	int reg, cmd;
-	int ret;
+	int ret = 0;
 
 	if (devpriv->model == VMK8061_MODEL) {
 		reg = VMK8061_DO_REG;
-- 
1.8.3.2
