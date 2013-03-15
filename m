Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab3COElE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 00:41:04 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55511 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3COElB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 00:41:01 -0400
Date: Fri, 15 Mar 2013 10:10:41 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        yrl.pp-manager.tt@hitachi.com, Steven Rostedt <rostedt@goodmis.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v2 2/2] [BUGFIX] kprobes/x86: Check Interrupt Flag
	modifier when registering probe
Message-ID: <20130315044041.GC31866@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20130314115230.19690.39387.stgit@mhiramat-M0-7522> <20130314115242.19690.33573.stgit@mhiramat-M0-7522>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314115242.19690.33573.stgit@mhiramat-M0-7522>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031504-4834-0000-0000-000004BD9E50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 08:52:43PM +0900, Masami Hiramatsu wrote:
> Currently kprobes check whether the copied instruction modifies
> IF (interrupt flag) on each probe hit. This means not only
> introducing overhead but also involving inat_get_opcode_attribute
> into kprobes hot path, and it can cause an infinit recursive
> call (and kernel panic in the end).
> 
> Actually, since the copied instruction itself never be modified
> on the buffer, it is needless to analyze the instruction every
> probe hit.
> 
> To fix this issue, we checks it only once when registering probe
> and store the result on ainsn->if_modifier.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Reported-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

