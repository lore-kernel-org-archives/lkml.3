Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab3JCESo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:18:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab3JCESl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:18:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [ 25/57] staging: vt6656: [BUG] iwctl_siwencodeext return if device not open
Date: Wed,  2 Oct 2013 21:08:51 -0700
Message-Id: <20131003040638.329362115@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 5e8c3d3e41b0bf241e830a1ee0752405adecc050 upstream.

Don't allow entry to iwctl_siwencodeext if device not open.

This fixes a race condition where wpa supplicant/network manager
enters the function when the device is already closed.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/iwctl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1634,6 +1634,9 @@ int iwctl_siwencodeext(struct net_device
 	if (pMgmt == NULL)
 		return -EFAULT;
 
+	if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
+		return -ENODEV;
+
 	buf = kzalloc(sizeof(struct viawget_wpa_param), GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;


