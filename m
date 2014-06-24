Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965226AbaFXP45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:56:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965210AbaFXP4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:56:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Lukas Czerner <lczerner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.15 60/61] tmpfs: ZERO_RANGE and COLLAPSE_RANGE not currently supported
Date: Tue, 24 Jun 2014 11:51:43 -0400
Message-Id: <20140624154955.524094918@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 13ace4d0d9db40e10ecd66dfda14e297571be813 upstream.

I was well aware of FALLOC_FL_ZERO_RANGE and FALLOC_FL_COLLAPSE_RANGE
support being added to fallocate(); but didn't realize until now that I
had been too stupid to future-proof shmem_fallocate() against new
additions.  -EOPNOTSUPP instead of going on to ordinary fallocation.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/shmem.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1728,6 +1728,9 @@ static long shmem_fallocate(struct file
 	pgoff_t start, index, end;
 	int error;
 
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+		return -EOPNOTSUPP;
+
 	mutex_lock(&inode->i_mutex);
 
 	if (mode & FALLOC_FL_PUNCH_HOLE) {


