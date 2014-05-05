Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaEETlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:41:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbaEETlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:41:20 -0400
Date: Mon, 5 May 2014 21:41:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] uprobes: add comment with insn opcodes, mnemonics
	and why we dont support them
Message-ID: <20140505194100.GA26916@redhat.com>
References: <1399314247-7368-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399314247-7368-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05, Denys Vlasenko wrote:
>
> + * Opcodes we'll probably never support:
> + * 6c-6f - ins,outs. SEGVs if used in userspace
> + * e4-e7 - in,out imm. SEGVs if used in userspace
> + * ec-ef - in,out acc. SEGVs if used in userspace

Well. I have no idea why they are nacked, but this is not the reason.

SEGVs are fine. Plus we have ioperm().

> + * cc - int3. SIGTRAP if used in userspace

SIGTRAP is not the reason. We do not want to enter do_int3() in UTASK_SSTEP
state with utask->active_uprobe != NULL etc. Too many potential complications.

Oleg.

