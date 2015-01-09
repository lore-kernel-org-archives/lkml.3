Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049AbbAIKrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:47:35 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44565 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757465AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>,
        Tyler Hicks <tyhicks@canonical.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 73/78] eCryptfs: Remove buggy and unnecessary write in file name decode routine
Date: Fri,  9 Jan 2015 11:32:22 +0100
Message-Id: <8ffea99d6f2be99790611282f326da95a84a8cab.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Halcrow <mhalcrow@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 942080643bce061c3dd9d5718d3b745dcb39a8bc upstream.

Dmitry Chernenkov used KASAN to discover that eCryptfs writes past the
end of the allocated buffer during encrypted filename decoding. This
fix corrects the issue by getting rid of the unnecessary 0 write when
the current bit offset is 2.

Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Reported-by: Dmitry Chernenkov <dmitryc@google.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ecryptfs/crypto.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 000eae2782b6..bf926f7a5f0c 100644
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
2.2.1

