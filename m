Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab3APARh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:17:37 -0500
Received: from mail.kernel.org ([198.145.19.201]:42461 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758355Ab3AOWb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:31:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Guo Chao <yan@linux.vnet.ibm.com>, "Theodore Tso" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ 115/221] ext4: release buffer in failed path in dx_probe()
Date: Tue, 15 Jan 2013 10:50:42 -0800
Message-Id: <20130115185006.340332175@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo Chao <yan@linux.vnet.ibm.com>

commit 0ecaef0644973e9006fdbc6974301047aaff9bc6 upstream.

If checksum fails, we should also release the buffer
read from previous iteration.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -725,7 +725,7 @@ dx_probe(const struct qstr *d_name, stru
 			ext4_warning(dir->i_sb, "Node failed checksum");
 			brelse(bh);
 			*err = ERR_BAD_DX_DIR;
-			goto fail;
+			goto fail2;
 		}
 		set_buffer_verified(bh);
 


