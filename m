Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3LBT6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:58:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab3LBTSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Mathias Krause <minipli@googlemail.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 3.12 107/212] audit: fix info leak in AUDIT_GET requests
Date: Mon,  2 Dec 2013 11:14:58 -0800
Message-Id: <20131202191259.220751374@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/audit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -659,6 +659,7 @@ static int audit_receive_msg(struct sk_b
 
 	switch (msg_type) {
 	case AUDIT_GET:
+		status_set.mask		 = 0;
 		status_set.enabled	 = audit_enabled;
 		status_set.failure	 = audit_failure;
 		status_set.pid		 = audit_pid;


