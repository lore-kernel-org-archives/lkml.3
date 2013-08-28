Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab3H1PoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:44:05 -0400
Received: from dupo.coraid.com ([208.71.232.133]:62864 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752989Ab3H1PoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:44:04 -0400
Message-Id: <bbbe236408eea89dbc966805e23eb26a3ca9467a.1377185392.git.ecashin@coraid.com>
In-Reply-To: <cover.1377185392.git.ecashin@coraid.com>
References: <cover.1377185392.git.ecashin@coraid.com>
Subject: [PATCH 2/2] aoe: remove do-nothing NAME="%k" term from example udev rules
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 28 Aug 2013 11:43:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the example udev rules in the documentation are used without
modification, warnings like the one shown below appear in the system
logs:

  /var/log/messages:Aug 22 11:09:11 kung udevd[445]: NAME="%k" \
    is superfluous and breaks kernel supplied names, please remove \
    it from /etc/udev/rules.d/60-aoe.rules:26

Removing the term does not cause any problems with the creation
of the special character and block device nodes.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 Documentation/aoe/udev.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/aoe/udev.txt b/Documentation/aoe/udev.txt
index 8686e78..1f06daf 100644
--- a/Documentation/aoe/udev.txt
+++ b/Documentation/aoe/udev.txt
@@ -23,4 +23,4 @@ SUBSYSTEM=="aoe", KERNEL=="revalidate",	NAME="etherd/%k", GROUP="disk", MODE="02
 SUBSYSTEM=="aoe", KERNEL=="flush",	NAME="etherd/%k", GROUP="disk", MODE="0220"
 
 # aoe block devices     
-KERNEL=="etherd*",       NAME="%k", GROUP="disk"
+KERNEL=="etherd*",       GROUP="disk"
-- 
1.7.1

