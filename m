Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3AZC07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 21:26:59 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:50467 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab3AZC04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 21:26:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
References: <87ehh8it9s.fsf@xmission.com>
Date: Fri, 25 Jan 2013 18:26:48 -0800
In-Reply-To: <87ehh8it9s.fsf@xmission.com> (Eric W. Biederman's message of
	"Fri, 25 Jan 2013 18:15:43 -0800")
Message-ID: <87d2wshe6v.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+JpiFpBL8A4+OTPyUqWo8fpfGfiFneYuc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 6/6] userns: Allow the userns root to mount tmpfs.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is no backing store to tmpfs and file creation rules are the
same as for any other filesystem so it is semantically safe to allow
unprivileged users to mount it.  ramfs is safe for the same reasons so
allow either flavor of tmpfs to be mounted by a user namespace root
user.

The memory control group successfully limits how much memory tmpfs can
consume on any system that cares about a user namespace root using
tmpfs to exhaust memory the memory control group can be deployed.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 mm/shmem.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 5c90d84..197ca5e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2766,6 +2766,7 @@ static struct file_system_type shmem_fs_type = {
 	.name		= "tmpfs",
 	.mount		= shmem_mount,
 	.kill_sb	= kill_litter_super,
+	.fs_flags	= FS_USERNS_MOUNT,
 };
 
 int __init shmem_init(void)
@@ -2823,6 +2824,7 @@ static struct file_system_type shmem_fs_type = {
 	.name		= "tmpfs",
 	.mount		= ramfs_mount,
 	.kill_sb	= kill_litter_super,
+	.fs_flags	= FS_USERNS_MOUNT,
 };
 
 int __init shmem_init(void)
-- 
1.7.5.4

