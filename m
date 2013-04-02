Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab3DBXBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:01:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3DBWuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Kot <pawlkt@gmail.com>, Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <lindner_marek@yahoo.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [ 21/56] batman-adv: bat_socket_read missing checks
Date: Tue,  2 Apr 2013 15:49:48 -0700
Message-Id: <20130402224714.344393922@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Paul Kot <pawlkt@gmail.com>

commit c00b6856fc642b234895cfabd15b289e76726430 upstream.

Writing a icmp_packet_rr and then reading icmp_packet can lead to kernel
memory corruption, if __user *buf is just below TASK_SIZE.

Signed-off-by: Paul Kot <pawlkt@gmail.com>
[sven@narfation.org: made it checkpatch clean]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/icmp_socket.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/batman-adv/icmp_socket.c
+++ b/net/batman-adv/icmp_socket.c
@@ -136,8 +136,8 @@ static ssize_t bat_socket_read(struct fi
 
 	spin_unlock_bh(&socket_client->lock);
 
-	error = __copy_to_user(buf, &socket_packet->icmp_packet,
-			       socket_packet->icmp_len);
+	error = copy_to_user(buf, &socket_packet->icmp_packet,
+			     socket_packet->icmp_len);
 
 	packet_len = socket_packet->icmp_len;
 	kfree(socket_packet);


