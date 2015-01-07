Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbbAGCSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:18:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675AbbAGCSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:18:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Halcrow <mhalcrow@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Kees Cook <keescook@chromium.org>, Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH 3.17 67/73] eCryptfs: Remove buggy and unnecessary write in file name decode routine
Date: Tue,  6 Jan 2015 18:16:28 -0800
Message-Id: <20150107021559.565466154@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/crypto.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1917,7 +1917,6 @@ ecryptfs_decode_from_filename(unsigned c
 			break;
 		case 2:
 			dst[dst_byte_offset++] |= (src_byte);
-			dst[dst_byte_offset] = 0;
 			current_bit_offset = 0;
 			break;
 		}


