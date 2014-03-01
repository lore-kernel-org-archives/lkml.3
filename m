Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaCAK2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 05:28:33 -0500
Received: from nm21-vm10.bullet.mail.gq1.yahoo.com ([98.136.217.57]:42785 "EHLO
	nm21-vm10.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbaCAK2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 05:28:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=ELCESucnxpzAepmRmKqYox8/acfNJs4fbjFxd22ySYnk0YQMjuxCXCumZu+lCFjD68NopDD3FKnAamBImXCCFjZSG3JqaNiX2KilPdbYUr0iO4bgejAhzuk0i5WUD3yClEiOQC0aRUziQWQ/KBs+IKvbWDSRo3GjU6udjCnhAL0=;
X-Yahoo-Newman-Id: 372804.2776.bm@smtp239.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: lEBgck4VM1nbDvTAzJyYavzxvEP2fGX_Pb.c5V_hgX63iVC
 CivedK9jjzzRubwIbEmSVBHREkc8qWQxqCZri4LGpbgzgehf99_YbtMvNj7l
 neZ_.mP8xYhdWHgpPuExyUi0IUmAGEhPjNSAX_q0G0H538TnZXYQMGXTLG.n
 4v24z46dPGZxvJNwrZ9v.BdfW6hVOIOknZhMu4qK.LD0kLFfZYJIFlUEXG.A
 HtkLfuswqsiLx5SQt4QvuxPJgBrRKmKvs1B2_OEWnyk5lsWik3yjSrLkkIMs
 l8DFPUe1rxYM7tK7n_N9JESe8doEQ7jMAKlEn3DXmor6Yz77koHpjpK4yq03
 wrV82ITaLQsfCNZhbtyjQrqAgq6RYMBh1Cf0leMK3N1rFYys9BTRxrSvwEX5
 PT8oHC_duk183UhPKlSql_hSjouPZ9gcpQvE31bjRB2T_6Zq791CGYhxTKME
 cSlBpnVKE09JxOUzdAeRZ5xmAY26iT.6_xdkZ6ufwkEqoZ4WBrrMOHsZdX5V
 OH_Q4dTheHtu38g9ALX6h.LOMMbpb0UU-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [63.250.193.228])
        by smtp239.mail.gq1.yahoo.com with SMTP; 01 Mar 2014 10:28:31 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 1/2] Staging: comedi: introduce outl_1564_* and inl_1564_* helper functions in hwdrv_apci1564.c
Date: Sat,  1 Mar 2014 04:28:27 -0600
Message-Id: <1393669707-20107-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com>
References: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a handful of outl and inl helper functions with the
ultimate goal of improving code readability and allowing several lines
which violate the character limit to be shortened in a sane way.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
This patchset serves as a replacement to my previous cleanup patchset for
hwdrv_apci1564.c

Dan,
After spending a little bit more time with this and trying out different
ways of cleaning this up, I decided that making helper functions for all
of the most common register sets would look the best, but I haven't made
a helper for a few of the least common inl/outl calls because if I did,
the sheer number of helper functions would get quite ridiculous.
Let me know if you think my selections of what to make into helper
functions seems appropriate.

Thanks,
Chase

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 48 ++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 2b47fa1..282a744 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -99,6 +99,54 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 #define APCI1564_TCW_WARN_TIMEVAL			24
 #define APCI1564_TCW_WARN_TIMEBASE			28
 
+static void outl_1564_digital_ip(struct addi_private *devpriv, unsigned int cmd,
+						unsigned int reg)
+{
+	outl(cmd, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP + reg);
+}
+
+static unsigned int inl_1564_digital_ip(struct addi_private *devpriv,
+						unsigned int reg)
+{
+	return inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP + reg);
+}
+
+static void outl_1564_digital_op(struct addi_private *devpriv, unsigned int cmd,
+						unsigned int reg)
+{
+	outl(cmd, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP + reg);
+}
+
+static unsigned int inl_1564_digital_op(struct addi_private *devpriv,
+						unsigned int reg)
+{
+	return inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP + reg);
+}
+
+static void outl_1564_digital_op_watchdog(struct addi_private *devpriv,
+						unsigned int cmd, unsigned int reg)
+{
+	outl(cmd, devpriv->IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG + reg);
+}
+
+static unsigned int inl_1564_digital_op_watchdog(struct addi_private *devpriv,
+						unsigned int reg)
+{
+	return inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG + reg);
+}
+
+static void outl_1564_timer(struct addi_private *devpriv, unsigned int cmd,
+						unsigned int reg)
+{
+	outl(cmd, devpriv->i_IobaseAmcc + APCI1564_TIMER + reg);
+}
+
+static unsigned int inl_1564_timer(struct addi_private *devpriv,
+						unsigned int reg)
+{
+	return inl(devpriv->i_IobaseAmcc + APCI1564_TIMER + reg);
+}
+
 /* Global variables */
 static unsigned int ui_InterruptStatus_1564;
 static unsigned int ui_InterruptData, ui_Type;
-- 
1.8.5.3

