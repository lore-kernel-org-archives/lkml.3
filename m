Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaCXO1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:27:39 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:14376 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753337AbaCXO1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:27:38 -0400
Date: Mon, 24 Mar 2014 10:27:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: ftrace/kprobes: Warning when insmod two modules
Message-ID: <20140324102735.122e1cf2@gandalf.local.home>
In-Reply-To: <5330164D.6030507@hitachi.com>
References: <1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com>
	<5330164D.6030507@hitachi.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 20:26:05 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

 
> Thank you for reporting with this pretty backtrace :)
> Steven, I think this is not the kprobe bug but ftrace (and perhaps, module).
> 
> If the ftrace can set loading module text read only before the module subsystem
> expected, I think it should be protected by the module subsystem itself
> (e.g. set_all_modules_text_ro(rw) skips the modules which is MODULE_STATE_COMING)
> 

I have to admit. I never thought about having the module init code
enabling ftrace :-)

Yeah, it looks like we need to handle this case. I'll take a look into
it.

Thanks for the report,

-- Steve
