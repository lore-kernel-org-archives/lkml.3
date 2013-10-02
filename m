Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3JBXJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 19:09:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:29197 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab3JBXJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 19:09:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1022,1371106800"; 
   d="scan'208";a="413224850"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Nikhil Rao <nikhil.rao@intel.com>, Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next] misc: mic: Fix build issues in sample daemon.
Date: Wed,  2 Oct 2013 16:09:00 -0700
Message-Id: <03258a55f3cfae828b0f0c96b010c8ab6aa2065d.1380735129.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specifying gcc format function attribute for mpsslog(..) and
building on 32 bit systems exposed a few build issues in the
sample MIC daemon which are fixed by this patch. Some of these
changes were authored by Joe Perches @
https://lkml.org/lkml/2013/9/27/419

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Caz Yokoyama <Caz.Yokoyama@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 Documentation/mic/mpssd/mpssd.c | 22 +++++++++++-----------
 Documentation/mic/mpssd/mpssd.h |  1 +
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/Documentation/mic/mpssd/mpssd.c b/Documentation/mic/mpssd/mpssd.c
index f9327a2..82c6bc2 100644
--- a/Documentation/mic/mpssd/mpssd.c
+++ b/Documentation/mic/mpssd/mpssd.c
@@ -362,9 +362,9 @@ static inline void verify_out_len(struct mic_info *mic,
 	struct mic_copy_desc *copy)
 {
 	if (copy->out_len != sum_iovec_len(copy)) {
-		mpsslog("%s %s %d BUG copy->out_len 0x%x len 0x%x\n",
+		mpsslog("%s %s %d BUG copy->out_len 0x%x len 0x%zx\n",
 			mic->name, __func__, __LINE__,
-				copy->out_len, sum_iovec_len(copy));
+			copy->out_len, sum_iovec_len(copy));
 		assert(copy->out_len == sum_iovec_len(copy));
 	}
 }
@@ -377,7 +377,7 @@ disp_iovec(struct mic_info *mic, struct mic_copy_desc *copy,
 	int i;
 
 	for (i = 0; i < copy->iovcnt; i++)
-		mpsslog("%s %s %d copy->iov[%d] addr %p len 0x%lx\n",
+		mpsslog("%s %s %d copy->iov[%d] addr %p len 0x%zx\n",
 			mic->name, s, line, i,
 			copy->iov[i].iov_base, copy->iov[i].iov_len);
 }
@@ -630,7 +630,7 @@ virtio_net(void *arg)
 				disp_iovec(mic, &copy, __func__, __LINE__);
 				mpsslog("%s %s %d read failed %s ", mic->name,
 					__func__, __LINE__, strerror(errno));
-				mpsslog("cnt %d sum %d\n",
+				mpsslog("cnt %d sum %zd\n",
 					copy.iovcnt, sum_iovec_len(&copy));
 			}
 		}
@@ -680,8 +680,8 @@ virtio_net(void *arg)
 					if (len != sum_iovec_len(&copy)) {
 						mpsslog("Tun write failed %s ",
 							strerror(errno));
-						mpsslog("len 0x%x ", len);
-						mpsslog("read_len 0x%x\n",
+						mpsslog("len 0x%zx ", len);
+						mpsslog("read_len 0x%zx\n",
 							sum_iovec_len(&copy));
 					} else {
 #ifdef DEBUG
@@ -827,7 +827,7 @@ virtio_console(void *arg)
 				mpsslog("%s %s %d read failed %s ",
 					mic->name, __func__, __LINE__,
 					strerror(errno));
-				mpsslog("cnt %d sum %d\n",
+				mpsslog("cnt %d sum %zd\n",
 					copy.iovcnt, sum_iovec_len(&copy));
 			}
 		}
@@ -859,8 +859,8 @@ virtio_console(void *arg)
 					if (len != sum_iovec_len(&copy)) {
 						mpsslog("Tun write failed %s ",
 							strerror(errno));
-						mpsslog("len 0x%x ", len);
-						mpsslog("read_len 0x%x\n",
+						mpsslog("len 0x%zx ", len);
+						mpsslog("read_len 0x%zx\n",
 							sum_iovec_len(&copy));
 					} else {
 #ifdef DEBUG
@@ -953,7 +953,7 @@ set_backend_file(struct mic_info *mic)
 		return false;
 	mic->mic_virtblk.backend_file = malloc(strlen(evv) + 1);
 	if (mic->mic_virtblk.backend_file == NULL) {
-		mpsslog("can't allocate memory\n", mic->name, mic->id);
+		mpsslog("%s %d can't allocate memory\n", mic->name, mic->id);
 		return false;
 	}
 	strcpy(mic->mic_virtblk.backend_file, evv + 1);
@@ -1026,7 +1026,7 @@ close_backend(struct mic_info *mic)
 static bool
 start_virtblk(struct mic_info *mic, struct mic_vring *vring)
 {
-	if (((__u64)&virtblk_dev_page.blk_config % 8) != 0) {
+	if (((unsigned long)&virtblk_dev_page.blk_config % 8) != 0) {
 		mpsslog("%s: blk_config is not 8 byte aligned.\n",
 			mic->name);
 		return false;
diff --git a/Documentation/mic/mpssd/mpssd.h b/Documentation/mic/mpssd/mpssd.h
index b6dee38..ccd589f 100644
--- a/Documentation/mic/mpssd/mpssd.h
+++ b/Documentation/mic/mpssd/mpssd.h
@@ -94,6 +94,7 @@ struct mic_info {
 	struct mic_info *next;
 };
 
+__attribute__((format(printf, 1, 2)))
 void mpsslog(char *format, ...);
 char *readsysfs(char *dir, char *entry);
 int setsysfs(char *dir, char *entry, char *value);
-- 
1.8.2.1

