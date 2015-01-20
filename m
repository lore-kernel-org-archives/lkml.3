Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbbATTNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:13:48 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41763 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbbATTNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:13:17 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: initramfs <initramfs@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 09/11] gen_initramfs_list.sh: include xattrs
Date: Tue, 20 Jan 2015 14:12:58 -0500
Message-Id: <1421781180-24425-10-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1421781180-24425-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012019-0033-0000-0000-0000019BE031
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support the new gen_init_cpio option to include extended attributes.
This patch adds support for the "-x" option and passes it to
gen_init_cpio.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 scripts/gen_initramfs_list.sh | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 17fa901..8d10b9d 100755
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -24,6 +24,7 @@ $0 [-o <file>] [-u <uid>] [-g <gid>] {-d | <cpio_source>} ...
 	-g <gid>       Group ID to map to group ID 0 (root).
 		       <gid> is only meaningful if <cpio_source> is a
 		       directory.  "squash" forces all files to gid 0.
+	-x             include file extended attributes in cpio archive.
 	<cpio_source>  File list or directory for cpio archive.
 		       If <cpio_source> is a .cpio file it will be used
 		       as direct input to initramfs.
@@ -223,6 +224,7 @@ root_gid=0
 dep_list=
 cpio_file=
 cpio_list=
+cpio_opts=
 output="/dev/stdout"
 output_file=""
 is_cpio_compressed=
@@ -278,6 +280,9 @@ while [ $# -gt 0 ]; do
 			default_list="$arg"
 			${dep_list}default_initramfs
 			;;
+		"-x")	# include extended attributers
+			cpio_opts="-x"
+			;;
 		"-h")
 			usage
 			exit 0
@@ -307,7 +312,8 @@ if [ ! -z ${output_file} ]; then
 			fi
 		fi
 		cpio_tfile="$(mktemp ${TMPDIR:-/tmp}/cpiofile.XXXXXX)"
-		usr/gen_init_cpio $timestamp ${cpio_list} > ${cpio_tfile}
+		usr/gen_init_cpio $timestamp ${cpio_opts} ${cpio_list} \
+			> ${cpio_tfile}
 	else
 		cpio_tfile=${cpio_file}
 	fi
-- 
1.8.1.4

