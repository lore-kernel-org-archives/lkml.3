Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab3IYA3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:29:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755Ab3IYAUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [ 087/117] media: cx88: Fix regression: CX88_AUDIO_WM8775 cant be 0
Date: Tue, 24 Sep 2013 17:19:13 -0700
Message-Id: <20130925001750.454537747@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit f66b2a1c7f2ae3fb0d5b67d07ab4f5055fd3cf16 upstream.

Cards using the wm8775 specify that in their card struct. Those that do not
use it leave the audio_chip field to 0. Unfortunately, the CX88_AUDIO_WM8775
enum is 0 as well, so boards that do not have the wm8775 still try to load
and use that driver. Change it to 1 to fix this.
This regression was introduced in commit facd23664f1d63c33fbc6da52261c8548ed3fbd4.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
Tested-by: Knut Petersen <Knut_Petersen@t-online.de>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/cx88/cx88.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -259,7 +259,7 @@ struct cx88_input {
 };
 
 enum cx88_audio_chip {
-	CX88_AUDIO_WM8775,
+	CX88_AUDIO_WM8775 = 1,
 	CX88_AUDIO_TVAUDIO,
 };
 


