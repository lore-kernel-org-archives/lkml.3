Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab3AOWaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:30:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:42027 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758273Ab3AOWaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:30:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 091/221] dm: disable WRITE SAME
Date: Tue, 15 Jan 2013 10:50:18 -0800
Message-Id: <20130115185004.601432927@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit c1a94672a830e01d58c7c7e8de530c3f136d6ff2 upstream.

WRITE SAME bios are not yet handled correctly by device-mapper so
disable their use on device-mapper devices by setting
max_write_same_sectors to zero.

As an example, a ciphertext device is incompatible because the data
gets changed according to the location at which it written and so the
dm crypt target cannot support it.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-table.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1445,6 +1445,8 @@ void dm_table_set_restrictions(struct dm
 	else
 		queue_flag_clear_unlocked(QUEUE_FLAG_NONROT, q);
 
+	q->limits.max_write_same_sectors = 0;
+
 	dm_table_set_integrity(t);
 
 	/*


