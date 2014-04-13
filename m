Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaDMRpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 13:45:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbaDMRpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 13:45:21 -0400
Date: Sun, 13 Apr 2014 19:45:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/15] uprobes/x86: fix the handling of relative
	jmp's/call's
Message-ID: <20140413174508.GA11811@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

OK, let me resend everything. This is what I am going to add to my tree
and ask Ingo to pull. I am still testing this all, seems to work so far.

Changes:

	01-09: No changes, added the acks from Masami.

	09-15: Updated the changelogs, the comments in 13/15, plus the
	       following renames:

	       - s/ttt/branch/

	       - s/disp/offs/

	       - s/_clear_displacement/_clear_offset/

	       No changes in compiled code, I preserved the acks from Jim.

>From 13/15:

	Note: as Denys Vlasenko pointed out, amd and intel treat "callw" (0x66 0xe8)
	differently. This patch relies on lib/insn.c and thus implements the intel's
	behaviour: 0x66 is simply ignored. Fortunately nothing sane should ever use
	this insn, so we postpone the fix until we decide what should we do; emulate
	or not, support or not, etc.

Yes. Lets discuss (and fix?) this separately, I'll write another email.

Any objections?

Oleg.

 arch/x86/include/asm/uprobes.h |   16 +-
 arch/x86/kernel/uprobes.c      |  551 +++++++++++++++++++++++++---------------
 kernel/events/uprobes.c        |   31 +--
 3 files changed, 372 insertions(+), 226 deletions(-)

