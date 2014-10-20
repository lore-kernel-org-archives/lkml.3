Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaJTSxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:53:25 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:52896 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752561AbaJTSxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:53:24 -0400
Date: Mon, 20 Oct 2014 14:53:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kprobes: introduce ARCH_HANDLES_KPROBES_ON_FTRACE
Message-ID: <20141020145321.0af7a4dd@gandalf.local.home>
In-Reply-To: <54446B92.1040507@hitachi.com>
References: <1413387978-984-1-git-send-email-heiko.carstens@de.ibm.com>
	<1413387978-984-2-git-send-email-heiko.carstens@de.ibm.com>
	<54446B92.1040507@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014 10:55:30 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:


> Hmm, this looks a bit not straight. Maybe we'd better introduce a local
> check_ftrace_location() function which always returns 0 if
> CONFIG_ARCH_HANDLES_KPROBES_ON_FTRACE(with a comment! :)) as below.
> 
> int check_ftrace_location(kp)
> {
> 	unsigned long ftrace_address;
> 
> 	/* If an architecture handles kprobes on ftrace, we don't check it */
> 	if (IS_ENABLED(CONFIG_ARCH_HANDLES_KPROBES_ON_FTRACE))
> 		return 0;
> 
> 	...
> }

We can also just make that function weak, and let the archs override
the default behavior?

-- Steve
