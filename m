Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbaJ1DlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:41:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbaJ1DlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:41:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.17 103/146] Bluetooth: 6lowpan: Increase the connection timeout value
Date: Tue, 28 Oct 2014 11:34:05 +0800
Message-Id: <20141028033347.926186656@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jukka Rissanen <jukka.rissanen@linux.intel.com>

commit 2ae50d8d3aaf7154f72b44331b71f15799cdc1bb upstream.

Use the default connection timeout value defined in l2cap.h because
the current timeout was too short and most of the time the connection
attempts timed out.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/6lowpan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -890,7 +890,7 @@ static void chan_resume_cb(struct l2cap_
 
 static long chan_get_sndtimeo_cb(struct l2cap_chan *chan)
 {
-	return msecs_to_jiffies(1000);
+	return L2CAP_CONN_TIMEOUT;
 }
 
 static const struct l2cap_ops bt_6lowpan_chan_ops = {


