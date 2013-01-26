Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab3AZC0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 21:26:22 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:37274 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab3AZC0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 21:26:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
References: <87ehh8it9s.fsf@xmission.com>
Date: Fri, 25 Jan 2013 18:26:11 -0800
In-Reply-To: <87ehh8it9s.fsf@xmission.com> (Eric W. Biederman's message of
	"Fri, 25 Jan 2013 18:15:43 -0800")
Message-ID: <87ip6khe7w.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1930E914BqoSonnSKzlaXepsLvl85T0go8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 5/6] userns: Allow the userns root to mount ramfs.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is no backing store to ramfs and file creation
rules are the same as for any other filesystem so
it is semantically safe to allow unprivileged users
to mount it.

The memory control group successfully limits how much
memory ramfs can consume on any system that cares about
a user namespace root using ramfs to exhaust memory
the memory control group can be deployed.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/ramfs/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index eab8c09..c24f1e1 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -260,6 +260,7 @@ static struct file_system_type ramfs_fs_type = {
 	.name		= "ramfs",
 	.mount		= ramfs_mount,
 	.kill_sb	= ramfs_kill_sb,
+	.fs_flags	= FS_USERNS_MOUNT,
 };
 static struct file_system_type rootfs_fs_type = {
 	.name		= "rootfs",
-- 
1.7.5.4

