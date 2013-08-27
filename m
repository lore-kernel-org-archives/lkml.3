Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3H0BEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:04:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab3H0BCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:02:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 6/9] Hostap: copying wrong data prism2_ioctl_giwaplist()
Date: Mon, 26 Aug 2013 18:04:57 -0700
Message-Id: <20130827010252.117404140@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010251.636183797@linuxfoundation.org>
References: <20130827010251.636183797@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 909bd5926d474e275599094acad986af79671ac9 upstream.

We want the data stored in "addr" and "qual", but the extra ampersands
mean we are copying stack data instead.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/hostap/hostap_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -521,9 +521,9 @@ static int prism2_ioctl_giwaplist(struct
 
 	data->length = prism2_ap_get_sta_qual(local, addr, qual, IW_MAX_AP, 1);
 
-	memcpy(extra, &addr, sizeof(struct sockaddr) * data->length);
+	memcpy(extra, addr, sizeof(struct sockaddr) * data->length);
 	data->flags = 1; /* has quality information */
-	memcpy(extra + sizeof(struct sockaddr) * data->length, &qual,
+	memcpy(extra + sizeof(struct sockaddr) * data->length, qual,
 	       sizeof(struct iw_quality) * data->length);
 
 	kfree(addr);


