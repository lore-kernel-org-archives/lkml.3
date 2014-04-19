Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161041AbaDSRBn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 13:01:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161018AbaDSRBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 13:01:42 -0400
Date: Sat, 19 Apr 2014 19:01:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] uprobes/x86: cleanup validate_insn_* paths, fix
	X86_X32 case
Message-ID: <20140419170104.GA30667@redhat.com>
References: <20140417200228.GA31097@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417200228.GA31097@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, feel free to ignore 1-4, but could you look at 5/5? It lacks the
test-case because I do not have a x32-ready testing machine.

On 04/17, Oleg Nesterov wrote:
>
> This series only fixes the problem. I'll send more changes to address
> some of TODO's mentioned in the changelogs later. In particular, we
> need to do something with "callw", see "Note: in 13/15.

So, what do you all think we should do with "callw"? Jim votes for
declining to probe callw, and I fully agree.

Any objection?

Until then, lets cleanup the validate_insn_* paths and fix another bug.
This cleanup can also simplify the next "reject callw" change.

Oleg.

 arch/x86/kernel/process_64.c |    7 +-
 arch/x86/kernel/uprobes.c    |  126 ++++++++++++++++++------------------------
 2 files changed, 58 insertions(+), 75 deletions(-)

