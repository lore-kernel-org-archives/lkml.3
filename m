Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab3AOWao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:30:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:42082 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758304Ab3AOWaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:30:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [ 095/221] staging: vt6656: [BUG] out of bound array reference in RFbSetPower.
Date: Tue, 15 Jan 2013 10:50:22 -0800
Message-Id: <20130115185004.886027245@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit ab1dd9963137a1e122004d5378a581bf16ae9bc8 upstream.

Calling RFbSetPower with uCH zero value will cause out of bound array reference.

This causes 64 bit kernels to oops on boot.

Note: Driver does not function on 64 bit kernels and should be
blacklisted on them.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/rf.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -769,6 +769,9 @@ BYTE    byPwr = pDevice->byCCKPwr;
         return TRUE;
     }
 
+	if (uCH == 0)
+		return -EINVAL;
+
     switch (uRATE) {
     case RATE_1M:
     case RATE_2M:


