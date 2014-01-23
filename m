Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaAWQKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:10:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:61865 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751001AbaAWQKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:10:21 -0500
Date: Thu, 23 Jan 2014 11:10:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v6 7/8] x86: patch all traced function calls using the
 int3-based framework
Message-ID: <20140123111018.5cb064e4@gandalf.local.home>
In-Reply-To: <1390486902.16203.161.camel@pathway.suse.cz>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
	<1386690140-19941-8-git-send-email-pmladek@suse.cz>
	<20140115104741.2d78cee4@gandalf.local.home>
	<1390396845.16203.58.camel@pathway.suse.cz>
	<1390486902.16203.161.camel@pathway.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 15:21:42 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> It means that the slowness caused by tracing "text_poke*" stuff is
> comparable with the slowness caused by "run_sync()". It might mean that
> "text_poke_bp_list" is not worth the added complexity.

I'm starting to think it's fine keeping ftrace and text_poke separate.
Ftrace is rather the NMI of text modification. It's extremely invasive
and has more corner cases than anything else. I rather not complicate
the more generic text_poke just to satisfy ftrace. Perhaps if it was
not such an arch specific change it may be worth it. As these only have
to deal with x86, and the only rational in doing it is to get ftrace to
use text_poke() (one code base for all), I think we can drop it.

Having them separate isn't that bad either, as both get heavy testing
as they both are used in normal development.

> 
> Well, the iterator-based implementation is complex but still faster.
> Also the many sync calls might be more painful for a busy system that
> heavy use of the int3 handler. So, "text_poke_bp_list" still might be
> useful.

That said, I'm sure text_poke can use some clean ups. That would be
nice as well. I think batch processing with the list may be more useful
for things like kprobes and jump labels.

-- Steve

