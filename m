Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaCJDGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 23:06:53 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38873 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbaCJDGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 23:06:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, rgb@redhat.com, eparis@redhat.com,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <874n3ir0uw.fsf_-_@xmission.com> <87mwhaplo4.fsf_-_@xmission.com>
	<20140304133004.b565820f60f595a48e621e58@linux-foundation.org>
	<20140304.165122.445822929490466603.davem@davemloft.net>
	<87mwh5d1tf.fsf@xmission.com>
	<20140304145037.d46ee775d293dd1ad60aa8e3@linux-foundation.org>
Date: Sun, 09 Mar 2014 20:06:43 -0700
In-Reply-To: <20140304145037.d46ee775d293dd1ad60aa8e3@linux-foundation.org>
	(Andrew Morton's message of "Tue, 4 Mar 2014 14:50:37 -0800")
Message-ID: <87bnxesqf0.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19UZ6gwCUjMyBvSk+v0Cl6wC6jNQG3HRMc=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3275]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [GIT PULL] namespaces fixes for 3.14-rcX
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the for-linus branch from the git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

   HEAD: d211f177b28ec070c25b3d0b960aa55f352f731f audit: Update kdoc for audit_send_reply and audit_list_rules_send

Starting with 3.14-rc1 the audit code is faulty (think oopses and races)
with respect to how it computes the network namespace of which socket to
reply to, and I happened to notice by chance when reading through the
code.

My efforts to get these fixes noticed by people who care about audit
seem to have landed on deaf ears, so since these are namespace related I
have put them in my tree.

My testing and the automated build bots don't find any problems with
these fixes.

Eric W. Biederman (3):
      audit: Use struct net not pid_t to remember the network namespce to reply in
      audit: Send replies in the proper network namespace.
      audit: Update kdoc for audit_send_reply and audit_list_rules_send

 include/linux/audit.h |    3 ++-
 kernel/audit.c        |   31 ++++++++++++++++---------------
 kernel/audit.h        |    2 +-
 kernel/auditfilter.c  |   10 +++++++---
 4 files changed, 26 insertions(+), 20 deletions(-)

Eric
