Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaEFWdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 18:33:20 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52820 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaEFWdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 18:33:19 -0400
Message-ID: <53696327.9010806@hitachi.com>
Date: Wed, 07 May 2014 07:33:11 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Seth Jennings <sjenning@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
References: <cover.1398958771.git.jpoimboe@redhat.com> <20140505085537.GA32196@gmail.com> <20140505132638.GA14432@treble.redhat.com> <20140505141038.GA27403@localhost.localdomain> <20140505184304.GA15137@gmail.com> <5368CB6E.3090105@hitachi.com> <20140506082604.31928cb9@gandalf.local.home>
In-Reply-To: <20140506082604.31928cb9@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/06 21:26), Steven Rostedt wrote:
> On Tue, 06 May 2014 20:45:50 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> 
>> However, I also think if users can accept such freezing wait-time,
>> it means they can also accept kexec based "checkpoint-restart" patching.
>> So, I think the final goal of the kpatch will be live patching without
>> stopping the machine. I'm discussing the issue on github #138, but that is
>> off-topic. :)
>>
> 
> I agree with Ingo too. Being conservative at first is the right
> approach here. We should start out with a stop_machine making sure that
> everything is sane before we continue. Sure, that's not much different
> than a kexec, but lets take things one step at a time.

Agreed. that is a correct way to move things forward.
Anyway, my stop_machine-less approach still has many implementation
issues. It should be solved in upstream, not out-of-tree. So, this
topic is off-topic at this stage. :) We need to focus on how to
merge live-patch into upstream kernel.

> ftrace did the stop_machine (and still does for some archs), and slowly
> moved to a more efficient method. kpatch/kgraft should follow suit.

Sure, that's a best story of how things should be evolved on the kernel :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


