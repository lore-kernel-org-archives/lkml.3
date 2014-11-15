Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbaKOJCC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 04:02:02 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:52402 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbaKOJB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 04:01:59 -0500
X-Originating-IP: 50.43.41.112
Date: Sat, 15 Nov 2014 01:01:52 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, mtk.manpages@gmail.com,
        linux-api@vger.kernel.org, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH manpages] getgroups.2: Document unprivileged setgroups calls
Message-ID: <20141115090151.GA15470@thin>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
This should probably also include appropriate documentation for what
kernel introduces this behavior.

 man2/getgroups.2 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/man2/getgroups.2 b/man2/getgroups.2
index 373c204..edca37c 100644
--- a/man2/getgroups.2
+++ b/man2/getgroups.2
@@ -81,9 +81,10 @@ to be used in a further call to
 .PP
 .BR setgroups ()
 sets the supplementary group IDs for the calling process.
-Appropriate privileges (Linux: the
+Any process may drop groups from its list, but adding groups requires
+appropriate privileges (Linux: the
 .B CAP_SETGID
-capability) are required.
+capability).
 The
 .I size
 argument specifies the number of supplementary group IDs
-- 
2.1.3

