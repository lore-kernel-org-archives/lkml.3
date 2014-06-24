Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaFXHcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:32:04 -0400
Received: from mail-pa0-f66.google.com ([209.85.220.66]:43772 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaFXHcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:32:02 -0400
MIME-Version: 1.0
From: Osmond Sun <osmond.sun@gmail.com>
Date: Tue, 24 Jun 2014 15:31:41 +0800
Message-ID: <CABJ8ys8VxRwgges=bfFCXN51rQQQM3kgdfRP-TtZuOrP+UrcgQ@mail.gmail.com>
Subject: [PATCH] cifs: set null to username and iocharset after being freed
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function 'expand_dfs_referral' the volume_info->iocharset and
volume_info->username was used after being freed by calling
cleanup_volume_info_contents. Set null to username and iocharset
after being freed.

Signed-off-by: Osmond Sun <osmond.sun@gmail.com>
---
 fs/cifs/connect.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 20d75b8..2586a34 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3251,10 +3251,12 @@ static void
 cleanup_volume_info_contents(struct smb_vol *volume_info)
 {
  kfree(volume_info->username);
+ volume_info->username = NULL;
  kzfree(volume_info->password);
  kfree(volume_info->UNC);
  kfree(volume_info->domainname);
  kfree(volume_info->iocharset);
+ volume_info->iocharset = NULL;
  kfree(volume_info->prepath);
 }

-- 
1.9.0
