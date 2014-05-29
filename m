Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860AbaE2FF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:05:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761AbaE2Ef5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <antonio@meshcoding.com>
Subject: [PATCH 3.14 132/140] batman-adv: fix indirect hard_iface NULL dereference
Date: Wed, 28 May 2014 21:34:31 -0700
Message-Id: <20140529043106.320390607@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Lindner <mareklindner@neomailbox.ch>

[ Upstream commit 16a4142363b11952d3aa76ac78004502c0c2fe6e ]

If hard_iface is NULL and goto out is made batadv_hardif_free_ref()
doesn't check for NULL before dereferencing it to get to refcount.

Introduced in cb1c92ec37fb70543d133a1fa7d9b54d6f8a1ecd
("batman-adv: add debugfs support to view multiif tables").

Reported-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Acked-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/originator.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -1074,7 +1074,8 @@ int batadv_orig_hardif_seq_print_text(st
 	bat_priv->bat_algo_ops->bat_orig_print(bat_priv, seq, hard_iface);
 
 out:
-	batadv_hardif_free_ref(hard_iface);
+	if (hard_iface)
+		batadv_hardif_free_ref(hard_iface);
 	return 0;
 }
 


