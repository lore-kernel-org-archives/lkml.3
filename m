Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbbAYSnH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:43:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbbAYSKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kyle McMartin <kyle@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.18 066/183] uapi/linux/target_core_user.h: fix headers_install.sh badness
Date: Sun, 25 Jan 2015 10:06:28 -0800
Message-Id: <20150125180813.045302803@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle McMartin <kyle@redhat.com>

commit 3875f15207f9ecb3f24a8e91e7ad196899139595 upstream.

scripts/headers_install.sh will transform __packed to
__attribute__((packed)), so the #ifndef is not necessary.
(and, in fact, it's problematic, because we'll end up with the header
 containing:
#ifndef __attribute__((packed))
#define __attribu...
and so forth.)

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/target_core_user.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/uapi/linux/target_core_user.h
+++ b/include/uapi/linux/target_core_user.h
@@ -6,10 +6,6 @@
 #include <linux/types.h>
 #include <linux/uio.h>
 
-#ifndef __packed
-#define __packed                        __attribute__((packed))
-#endif
-
 #define TCMU_VERSION "1.0"
 
 /*


