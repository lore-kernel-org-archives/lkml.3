Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaBOXPM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 18:15:12 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:40460 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaBOXPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 18:15:09 -0500
X-Authority-Analysis: v=2.0 cv=H69ZMpki c=1 sm=0 a=2fUkqGT2UzHXw691IaMUVw==:17 a=wom5GMh1gUkA:10 a=JU4hbWwUC5wA:10 a=zz6odIEfzeQA:10 a=hvm3MZhftXEA:10 a=kj9zAlcOel0A:10 a=7kYe3NcsAAAA:8 a=KGjhK52YXX0A:10 a=Sd6W3NyGy_IA:10 a=Z-SZ1Z_njRioQy8wcT0A:9 a=CjuIK1q_8ugA:10 a=-XA83Ip703gA:10 a=2fUkqGT2UzHXw691IaMUVw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.246.46.80
Date: Sat, 15 Feb 2014 18:14:57 -0500
From: "Daniel M. Weeks" <dan@danweeks.net>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix flags for initramfs LZ4 compression
Message-ID: <20140215231447.GA30803@dev.danweeks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LZ4 as implemented in the kernel differs from the default method now
used by the reference implementation of LZ4. Until the in-kernel method
is updated to support the new default, passing the legacy flag (-l) to
the compressor is necessary. Without this flag the kernel-generated,
LZ4-compressed initramfs is junk.

Signed-off-by: Daniel M. Weeks <dan@danweeks.net>
---
 scripts/gen_initramfs_list.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index ef47409..17fa901 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -257,7 +257,7 @@ case "$arg" in
                 && compr="lzop -9 -f"
 		echo "$output_file" | grep -q "\.lz4$" \
                 && [ -x "`which lz4 2> /dev/null`" ] \
-                && compr="lz4 -9 -f"
+                && compr="lz4 -l -9 -f"
 		echo "$output_file" | grep -q "\.cpio$" && compr="cat"
 		shift
 		;;
-- 
Daniel M. Weeks
