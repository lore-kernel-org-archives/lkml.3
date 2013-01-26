Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3AZCPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 21:15:54 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52392 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab3AZCPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 21:15:52 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
Date: Fri, 25 Jan 2013 18:15:43 -0800
Message-ID: <87ehh8it9s.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+b9489uNwvPg5KeMF/wvnx54p3oJy03bc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1595]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 0/6] miscelaneous user namespace patches
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that I have done my worst to infect user space with some
basic tools for using user namespaces, this is my first round of patches
aimed at the 3.9 merge window.

This documents that if you care about limit resources you want
to configure the memory control group when user namespaces are
enabled.

This enables the user namespace root to mount devpts, ramfs and tmpfs.
Functionality that is needed for practical uses of the user namespace.

This includes my patch to enable more flexibility into the input
allowed in uid_map and gid_map.

 Documentation/namespaces/resource-control.txt |   10 ++++
 fs/devpts/inode.c                             |   18 +++++++
 fs/ramfs/inode.c                              |    1 +
 include/linux/user_namespace.h                |   10 ++--
 init/Kconfig                                  |    7 +++
 kernel/user.c                                 |    4 +-
 kernel/user_namespace.c                       |   62 +++++++++++++++++++------
 mm/shmem.c                                    |    2 +
 8 files changed, 92 insertions(+), 22 deletions(-)

Eric W. Biederman (6):
      userns: Avoid recursion in put_user_ns
      userns: Allow any uid or gid mappings that don't overlap.
      userns: Recommend use of memory control groups.
      userns: Allow the userns root to mount of devpts
      userns: Allow the userns root to mount ramfs.
      userns: Allow the userns root to mount tmpfs.
