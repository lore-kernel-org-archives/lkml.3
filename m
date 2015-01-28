Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125AbbA2Cf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:35:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46927 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762103AbbA2CfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:23 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Halcrow <mhalcrow@google.com>, Tyler Hicks <tyhicks@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 057/139] eCryptfs: Remove buggy and unnecessary write in file name decode routine
Date: Wed, 28 Jan 2015 14:20:00 -0800
Message-Id: <1422483682-15393-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Halcrow <mhalcrow@google.com>

commit 942080643bce061c3dd9d5718d3b745dcb39a8bc upstream.

Dmitry Chernenkov used KASAN to discover that eCryptfs writes past the
end of the allocated buffer during encrypted filename decoding. This
fix corrects the issue by getting rid of the unnecessary 0 write when
the current bit offset is 2.

Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Reported-by: Dmitry Chernenkov <dmitryc@google.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ecryptfs/crypto.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 2f6735d..31b148f 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1917,7 +1917,6 @@ ecryptfs_decode_from_filename(unsigned char *dst, size_t *dst_size,
 			break;
 		case 2:
 			dst[dst_byte_offset++] |= (src_byte);
-			dst[dst_byte_offset] = 0;
 			current_bit_offset = 0;
 			break;
 		}
-- 
1.9.1

