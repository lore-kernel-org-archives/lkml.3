Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbaDDSu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:50:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155AbaDDSux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:50:53 -0400
Date: Fri, 4 Apr 2014 20:50:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/9] uprobes/x86: preparations to fix the reprel
	jmp/call handling.
Message-ID: <20140404185038.GA14679@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Changes:

	- "Conditionalize the usage of handle_riprel_insn()" is moved after
	  "Introduce uprobe_xol_ops and arch_uprobe->ops" to make the reason
	  more clear, update the changelog.

	  Masami, I hope this addresses your comments? I would be happy to
	  add your ack into 6/9 and 7/9 ;)

	- update the comment in 4/9, pointed out by Jim.

	- fix some typos in the changelogs/naming

	- 8-9 are new (the same I sent yesterday)

Since the changes in 1-7 are purely cosmetic, I preserved the acks I got.

Srikar, you acked 1, 2, 3, and 5 but didn't comment other changes. Please
let me know if I missed your emails. Do you agree with this series or you
have some concerns?

Now let me send the draft RFC patch which fixes the "call" handling...

Oleg.

 arch/x86/include/asm/uprobes.h |    7 +-
 arch/x86/kernel/uprobes.c      |  360 ++++++++++++++++++++--------------------
 kernel/events/uprobes.c        |   31 +---
 3 files changed, 199 insertions(+), 199 deletions(-)

