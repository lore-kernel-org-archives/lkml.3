Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaAQGgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 01:36:33 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:48147 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaAQGga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 01:36:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Gao feng <gaofeng@cn.fujitsu.com>, Al Viro <viro@ZenIV.linux.org.uk>
Date: Thu, 16 Jan 2014 22:36:21 -0800
Message-ID: <877g9zcdy2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1877PF5e4U+4aZDBJqi6mONfjONiS4x5ns=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3177]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [GIT PULL] namespace fixes
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the for-linus branch from the git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

   HEAD: 41301ae78a99ead04ea42672a1ab72c6f44cc81d vfs: Fix a regression in mounting proc

This is a set of 3 regression fixes. 

This fixes /proc/mounts when using "ip netns add <netns>" to display the
actual mount point.

This fixes a regression in clone that broke lxc-attach.

This fixes a regression in the permission checks for mounting /proc that
made proc unmountable if binfmt_misc was in use. Oops.

My apologies for sending this pull request so late.  Al Viro gave
interesting review comments about the d_path fix that I wanted to
address in detail before I sent this pull request.  Unfortunately a
bad round of colds kept from addressing that in detail until today.
The executive summary of the review was:

Al: Is patching d_path really sufficient?
    The prepend_path, d_path, d_absolute_path, and __d_path family of
    functions is a really mess.

Me: Yes, patching d_path is really sufficient.  Yes, the code is mess.
    No it is not appropriate to rewrite all of d_path for a regression
    that has existed for entirely too long already, when a two line
    change will do.

Eric W. Biederman (3):
      vfs: In d_path don't call d_dname on a mount point
      fork:  Allow CLONE_PARENT after setns(CLONE_NEWPID)
      vfs: Fix a regression in mounting proc

 fs/dcache.c    |    7 ++++++-
 fs/namespace.c |    2 +-
 kernel/fork.c  |    2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)


