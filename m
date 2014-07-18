Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030745AbaGRNv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:51:59 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:41971 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932309AbaGRNvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:51:42 -0400
Date: Fri, 18 Jul 2014 09:51:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ftrace/core v3 2/3] ftrace, kprobes: Support IPMODIFY
 flag to find IP modify conflict
Message-ID: <20140718095132.34c9179e@gandalf.local.home>
In-Reply-To: <53C8C813.2060709@hitachi.com>
References: <20140715060015.12195.74457.stgit@kbuild-fedora.novalocal>
	<20140715060028.12195.33527.stgit@kbuild-fedora.novalocal>
	<20140717144110.0fb00723@gandalf.local.home>
	<53C8C813.2060709@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014 16:09:07 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:


> > "The ops can modify the IP register. This can only be set along with
> > SAVE_REGS. If another ops is already registered for any of the
> > functions that this ops will be registered for, then this ops will fail
> > to register."
> 
> Not only register, but also set_filter_ip ;)
> "...will fail to register or set_filter_ip."

Sure.


> >> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> >> index 3214289..e52d86f 100644
> >> --- a/kernel/kprobes.c
> >> +++ b/kernel/kprobes.c
> > 
> > I think this should be split into two patches. One that adds the ftrace
> > infrastructure, and the other that adds the kprobes user of the
> > IPMODIFY flag.
> 
> Hmm, I thought that it was natural to introduce new feature and its user
> together, so that we could use git-bisect safely.

It should still be bisect friendly. That is, the feature is added
before the user, not the user before the feature ;-)

I know some people like the feature and user in one patch, but for me,
when the user is in a different sub system (here it's kprobes) from the
infrastructure that is changing (ftrace), I prefer separate patches.

The user patch shows me where the users are. When they are one patch, I
tend to have them get lost.

-- Steve
