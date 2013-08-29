Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3H2Xw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:52:28 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52567 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3H2Xw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:52:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, <linux-kernel@vger.kernel.org>
Date: Thu, 29 Aug 2013 16:52:18 -0700
Message-ID: <87ob8gys0d.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18L0jJTENz98B34NdouclUPOFvGbuVaAWw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  3.0 XMDrug1234561 Drug references
	*  1.5 TR_Symld_Words too many words that have symbols inside
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0013]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 0/5] A couple of lingering namespace patches 
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are a couple of long overdue namespace patches, simple cleanups
and permision grants that have been sitting in my development tree
for far too long.  If anyone objects to these please let me know.

Eric W. Biederman (4):
      namespaces: Simplify copy_namespaces so it is clear what is going on.
      userns: Allow PR_CAPBSET_DROP in a user namespace.
      pidns: Don't have unshare(CLONE_NEWPID) imply CLONE_THREAD
      userns:  Kill nsown_capable it makes the wrong thing easy

Serge Hallyn (1):
      capabilities: allow nice if we are privileged

 fs/namespace.c             |    4 ++--
 fs/open.c                  |    2 +-
 include/linux/capability.h |    1 -
 ipc/namespace.c            |    2 +-
 kernel/capability.c        |   12 ------------
 kernel/fork.c              |    5 -----
 kernel/groups.c            |    2 +-
 kernel/nsproxy.c           |   35 +++++++++++------------------------
 kernel/pid_namespace.c     |    2 +-
 kernel/sys.c               |   20 ++++++++++----------
 kernel/uid16.c             |    2 +-
 kernel/utsname.c           |    2 +-
 net/core/net_namespace.c   |    2 +-
 net/core/scm.c             |    4 ++--
 security/commoncap.c       |   10 +++++-----
 15 files changed, 37 insertions(+), 68 deletions(-)

Eric
