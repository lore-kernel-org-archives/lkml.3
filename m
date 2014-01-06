Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbaAFXqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:46:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471AbaAFWjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.12 124/144] Input: allocate absinfo data when setting ABS capability
Date: Mon,  6 Jan 2014 14:38:05 -0800
Message-Id: <20140106223748.899148221@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 28a2a2e1aedbe2d8b2301e6e0e4e63f6e4177aca upstream.

We need to make sure we allocate absinfo data when we are setting one of
EV_ABS/ABS_XXX capabilities, otherwise we may bomb when we try to emit this
event.

Rested-by: Paul Cercueil <pcercuei@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/input.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1871,6 +1871,10 @@ void input_set_capability(struct input_d
 		break;
 
 	case EV_ABS:
+		input_alloc_absinfo(dev);
+		if (!dev->absinfo)
+			return;
+
 		__set_bit(code, dev->absbit);
 		break;
 


