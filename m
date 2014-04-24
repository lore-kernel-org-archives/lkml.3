Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaDXVqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:46:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaDXVpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:45:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.14 10/33] kernfs: fix off by one error.
Date: Thu, 24 Apr 2014 14:48:23 -0700
Message-Id: <20140424214450.962461525@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140424214449.423169713@linuxfoundation.org>
References: <20140424214449.423169713@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Cochran <richardcochran@gmail.com>

commit 88391d49abb7d8dee91d405f96bd9e003cb6798d upstream.

The hash values 0 and 1 are reserved for magic directory entries, but
the code only prevents names hashing to 0. This patch fixes the test
to also prevent hash value 1.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/kernfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -37,7 +37,7 @@ static unsigned int kernfs_name_hash(con
 	hash = (end_name_hash(hash) ^ hash_ptr((void *)ns, 31));
 	hash &= 0x7fffffffU;
 	/* Reserve hash numbers 0, 1 and INT_MAX for magic directory entries */
-	if (hash < 1)
+	if (hash < 2)
 		hash += 2;
 	if (hash >= INT_MAX)
 		hash = INT_MAX - 1;


