Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaCHBG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:06:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbaCHBGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:06:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [PATCH 3.4 03/99] ext4: dont leave i_crtime.tv_sec uninitialized
Date: Fri,  7 Mar 2014 17:06:59 -0800
Message-Id: <20140308010611.725604599@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 19ea80603715d473600cd993b9987bc97d042e02 upstream.

If the i_crtime field is not present in the inode, don't leave the
field uninitialized.

Fixes: ef7f38359 ("ext4: Add nanosecond timestamps")
Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Tested-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -751,6 +751,8 @@ do {									       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
 		(einode)->xtime.tv_sec = 				       \
 			(signed)le32_to_cpu((raw_inode)->xtime);	       \
+	else								       \
+		(einode)->xtime.tv_sec = 0;				       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
 		ext4_decode_extra_time(&(einode)->xtime,		       \
 				       raw_inode->xtime ## _extra);	       \


