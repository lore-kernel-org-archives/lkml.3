Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaGMSoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 14:44:21 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:60661 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaGMSn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 14:43:28 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 5/6] samples: fix warnings in uhid-example
Date: Sun, 13 Jul 2014 20:42:53 +0200
Message-Id: <1405276974-17323-5-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405276974-17323-1-git-send-email-sam@ravnborg.org>
References: <20140713183636.GA17241@ravnborg.org>
 <1405276974-17323-1-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings seen when building using i686:
uhid-example.c: In function ‘uhid_write’:
uhid-example.c:168:4: warning: format ‘%ld’ expects argument of type ‘long int’, but argument 3 has type ‘ssize_t’ [-Wformat=]
uhid-example.c:168:4: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘unsigned int’ [-Wformat=]
uhid-example.c: In function ‘event’:
uhid-example.c:239:4: warning: format ‘%ld’ expects argument of type ‘long int’, but argument 3 has type ‘ssize_t’ [-Wformat=]
uhid-example.c:239:4: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘unsigned int’ [-Wformat=]

Use "%xd" for arguments of type size_t to fix the warnings.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Herrmann <dh.herrmann@googlemail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
---
 samples/uhid/uhid-example.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/uhid/uhid-example.c b/samples/uhid/uhid-example.c
index 7d58a4b..f25a5ef 100644
--- a/samples/uhid/uhid-example.c
+++ b/samples/uhid/uhid-example.c
@@ -164,7 +164,7 @@ static int uhid_write(int fd, const struct uhid_event *ev)
 		fprintf(stderr, "Cannot write to uhid: %m\n");
 		return -errno;
 	} else if (ret != sizeof(*ev)) {
-		fprintf(stderr, "Wrong size written to uhid: %ld != %lu\n",
+		fprintf(stderr, "Wrong size written to uhid: %zd != %zd\n",
 			ret, sizeof(ev));
 		return -EFAULT;
 	} else {
@@ -235,7 +235,7 @@ static int event(int fd)
 		fprintf(stderr, "Cannot read uhid-cdev: %m\n");
 		return -errno;
 	} else if (ret != sizeof(ev)) {
-		fprintf(stderr, "Invalid size read from uhid-dev: %ld != %lu\n",
+		fprintf(stderr, "Invalid size read from uhid-dev: %zd != %zd\n",
 			ret, sizeof(ev));
 		return -EFAULT;
 	}
-- 
1.9.3

