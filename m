Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbaBEUib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:38:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:55178 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbaBEUGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:47 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jun Nie <njun@marvell.com>, "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 134/213] Bluetooth: add NULL pointer check in HCI
Date: Wed, 5 Feb 2014 15:01:29 -0500
Message-ID: <1391630568-49251-135-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jun Nie <njun@marvell.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d9319560b86839506c2011346b1f2e61438a3c73 upstream.

If we fail to find a hci device pointer in hci_uart, don't try
to deref the NULL one we do have.

Signed-off-by: Jun Nie <njun@marvell.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/bluetooth/hci_ldisc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 283b127cea74..91be8d53d819 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -313,8 +313,10 @@ static void hci_uart_tty_close(struct tty_struct *tty)
 
 		if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
 			hu->proto->close(hu);
-			hci_unregister_dev(hdev);
-			hci_free_dev(hdev);
+			if (hdev) {
+				hci_unregister_dev(hdev);
+				hci_free_dev(hdev);
+			}
 		}
 	}
 }
-- 
1.8.5.2

