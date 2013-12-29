Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab3L2CSB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:18:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55710 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916Ab3L2CLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:19 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Paris" <eparis@redhat.com>,
        "Mathias Krause" <minipli@googlemail.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        "Richard Guy Briggs" <rgb@redhat.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.902653976@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 028/185] audit: fix info leak in AUDIT_GET requests
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 64fbff9ae0a0a843365d922e0057fc785f23f0e3 upstream.

We leak 4 bytes of kernel stack in response to an AUDIT_GET request as
we miss to initialize the mask member of status_set. Fix that.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/audit.c | 1 +
 1 file changed, 1 insertion(+)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -684,6 +684,7 @@ static int audit_receive_msg(struct sk_b
 
 	switch (msg_type) {
 	case AUDIT_GET:
+		status_set.mask		 = 0;
 		status_set.enabled	 = audit_enabled;
 		status_set.failure	 = audit_failure;
 		status_set.pid		 = audit_pid;

