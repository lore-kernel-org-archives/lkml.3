Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbaEFM0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:26:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:59222 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752419AbaEFM0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:26:08 -0400
Date: Tue, 6 May 2014 08:26:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Seth Jennings <sjenning@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140506082604.31928cb9@gandalf.local.home>
In-Reply-To: <5368CB6E.3090105@hitachi.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
	<20140505085537.GA32196@gmail.com>
	<20140505132638.GA14432@treble.redhat.com>
	<20140505141038.GA27403@localhost.localdomain>
	<20140505184304.GA15137@gmail.com>
	<5368CB6E.3090105@hitachi.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2014 20:45:50 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:


> However, I also think if users can accept such freezing wait-time,
> it means they can also accept kexec based "checkpoint-restart" patching.
> So, I think the final goal of the kpatch will be live patching without
> stopping the machine. I'm discussing the issue on github #138, but that is
> off-topic. :)
> 

I agree with Ingo too. Being conservative at first is the right
approach here. We should start out with a stop_machine making sure that
everything is sane before we continue. Sure, that's not much different
than a kexec, but lets take things one step at a time.

ftrace did the stop_machine (and still does for some archs), and slowly
moved to a more efficient method. kpatch/kgraft should follow suit.

-- Steve
