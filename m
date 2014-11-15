Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaKOXu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 18:50:28 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35317 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbaKOXu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 18:50:26 -0500
X-Originating-IP: 50.43.41.112
Date: Sat, 15 Nov 2014 15:50:17 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, mtk.manpages@gmail.com,
        linux-api@vger.kernel.org, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] getgroups.2: Document unprivileged setgroups calls
Message-ID: <20141115235017.GA31536@thin>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416095211.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416095211.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
v3: Document use of gid/egid/sgid.
v2: Document requirement for no_new_privs.

(If this doesn't end up going into 3.18, the version number in the patch will
need updating.)

 man2/getgroups.2 | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/man2/getgroups.2 b/man2/getgroups.2
index 373c204..e2b834e 100644
--- a/man2/getgroups.2
+++ b/man2/getgroups.2
@@ -81,9 +81,16 @@ to be used in a further call to
 .PP
 .BR setgroups ()
 sets the supplementary group IDs for the calling process.
-Appropriate privileges (Linux: the
+A process with the
 .B CAP_SETGID
-capability) are required.
+capability may change its supplementary group IDs arbitrarily.
+As of Linux 3.18, any process that has enabled PR_SET_NO_NEW_PRIVS (see
+.BR prctl (2))
+may drop supplementary groups, or add any of the current real UID, the current
+effective UID, or the current saved set-user-ID; adding any other group ID
+requires the
+.B CAP_SETGID
+capability.
 The
 .I size
 argument specifies the number of supplementary group IDs
-- 
2.1.3

