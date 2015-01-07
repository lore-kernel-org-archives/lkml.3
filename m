Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbbAGDEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:04:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859AbbAGBv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:51:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Milan Broz <gmazyland@gmail.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.18 23/84] dm crypt: use memzero_explicit for on-stack buffer
Date: Tue,  6 Jan 2015 17:49:26 -0800
Message-Id: <20150107014029.761795721@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milan Broz <gmazyland@gmail.com>

commit 1a71d6ffe18c0d0f03fc8531949cc8ed41d702ee upstream.

Use memzero_explicit to cleanup sensitive data allocated on stack
to prevent the compiler from optimizing and removing memset() calls.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-crypt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -705,7 +705,7 @@ static int crypt_iv_tcw_whitening(struct
 	for (i = 0; i < ((1 << SECTOR_SHIFT) / 8); i++)
 		crypto_xor(data + i * 8, buf, 8);
 out:
-	memset(buf, 0, sizeof(buf));
+	memzero_explicit(buf, sizeof(buf));
 	return r;
 }
 


