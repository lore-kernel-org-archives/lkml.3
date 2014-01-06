Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbaAGAPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:15:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479AbaAFWiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Wang <liwang@ubuntukylin.com>, Milosz Tanski <milosz@adfin.com>,
        Sage Weil <sage@inktank.com>
Subject: [PATCH 3.12 005/144] ceph: allocate non-zero page to fscache in readpage()
Date: Mon,  6 Jan 2014 14:36:06 -0800
Message-Id: <20140106223745.483924938@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Wang <liwang@ubuntukylin.com>

commit ff638b7df5a9264024a6448bdfde2b2bf5d1994a upstream.

ceph_osdc_readpages() returns number of bytes read, currently,
the code only allocate full-zero page into fscache, this patch
fixes this.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Reviewed-by: Milosz Tanski <milosz@adfin.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/addr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -216,7 +216,7 @@ static int readpage_nounlock(struct file
 	}
 	SetPageUptodate(page);
 
-	if (err == 0)
+	if (err >= 0)
 		ceph_readpage_to_fscache(inode, page);
 
 out:


