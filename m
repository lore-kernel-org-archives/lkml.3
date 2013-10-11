Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab3JKUYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:24:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab3JKTkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 091/110] net: Update the sysctl permissions handler to test effective uid/gid
Date: Fri, 11 Oct 2013 12:39:11 -0700
Message-Id: <20131011193817.717163088@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 2433c8f094a008895e66f25bd1773cdb01c91d01 upstream.

Modify the code to use current_euid(), and in_egroup_p, as in done
in fs/proc/proc_sysctl.c:test_perm()

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sysctl_net.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -47,12 +47,12 @@ static int net_ctl_permissions(struct ct
 
 	/* Allow network administrator to have same access as root. */
 	if (ns_capable(net->user_ns, CAP_NET_ADMIN) ||
-	    uid_eq(root_uid, current_uid())) {
+	    uid_eq(root_uid, current_euid())) {
 		int mode = (table->mode >> 6) & 7;
 		return (mode << 6) | (mode << 3) | mode;
 	}
 	/* Allow netns root group to have the same access as the root group */
-	if (gid_eq(root_gid, current_gid())) {
+	if (in_egroup_p(root_gid)) {
 		int mode = (table->mode >> 3) & 7;
 		return (mode << 3) | mode;
 	}


