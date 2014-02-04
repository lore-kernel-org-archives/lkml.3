Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934884AbaBDVNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:13:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934666AbaBDVM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.13 072/140] s390/uapi: fix struct statfs64 definition
Date: Tue,  4 Feb 2014 13:10:59 -0800
Message-Id: <20140204211039.017992895@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 4e078146dff728f4865270a47710d57797e81eb6 upstream.

With b8668fd0a7e1b59f "s390/uapi: change struct statfs[64] member types
to unsigned values" the size of a couple of struct statfs64 member got
incorrectly changed from 64 to 32 bit for 32 bit builds.

Fix this by changing the type of couple of struct statfs64 members from
unsigned long to unsigned long long.
The definition of struct compat_statfs64 was correct however.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/uapi/asm/statfs.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/s390/include/uapi/asm/statfs.h
+++ b/arch/s390/include/uapi/asm/statfs.h
@@ -35,11 +35,11 @@ struct statfs {
 struct statfs64 {
 	unsigned int	f_type;
 	unsigned int	f_bsize;
-	unsigned long	f_blocks;
-	unsigned long	f_bfree;
-	unsigned long	f_bavail;
-	unsigned long	f_files;
-	unsigned long	f_ffree;
+	unsigned long long f_blocks;
+	unsigned long long f_bfree;
+	unsigned long long f_bavail;
+	unsigned long long f_files;
+	unsigned long long f_ffree;
 	__kernel_fsid_t f_fsid;
 	unsigned int	f_namelen;
 	unsigned int	f_frsize;


