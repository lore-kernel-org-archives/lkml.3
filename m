Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab3BFOsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:48:21 -0500
Received: from ozlabs.org ([203.10.76.45]:49306 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757148Ab3BFOsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:48:17 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2/3 v3] selftests/efivarfs: Add empty file creation test
Message-Id: <1360162088.143301.227254679723.2.gpush@pecola>
In-Reply-To: <1360162088.142733.191120808822.0.gpush@pecola>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Lingzhu Xiang <lxiang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
From: Jeremy Kerr <jk@ozlabs.org>
Date: Wed, 06 Feb 2013 22:48:08 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

---
 tools/testing/selftests/efivarfs/efivarfs.sh |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/efivarfs/efivarfs.sh b/tools/testing/selftests/efivarfs/efivarfs.sh
index e8c0d27..3af4b37 100755
--- a/tools/testing/selftests/efivarfs/efivarfs.sh
+++ b/tools/testing/selftests/efivarfs/efivarfs.sh
@@ -58,6 +58,18 @@ test_create()
 	fi
 }
 
+test_create_empty()
+{
+	local file=$efivarfs_mount/$FUNCNAME-$test_guid
+
+	: > $file
+
+	if [ ! -e $file ]; then
+		echo "$file can not be created without writing" >&2
+		exit 1
+	fi
+}
+
 test_delete()
 {
 	local attrs='\x07\x00\x00\x00'
@@ -112,6 +124,7 @@ check_prereqs
 rc=0
 
 run_test test_create
+run_test test_create_empty
 run_test test_delete
 run_test test_zero_size_delete
 run_test test_open_unlink
