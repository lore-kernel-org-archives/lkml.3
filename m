Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbaEHWVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:21:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:59190 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaEHWVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:21:24 -0400
Date: Fri, 9 May 2014 00:21:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC PATCH] ftrace/x86: Move the mcount/fentry code out of
 entry_64.S
In-Reply-To: <20140508152152.2130e8cf@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1405090019510.6261@ionos.tec.linutronix.de>
References: <20140508152152.2130e8cf@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Steven Rostedt wrote:

> 
> As the mcount code gets more complex, it really does not belong
> in the entry.S file. By moving it into its own file "mcount.S"
> keeps things a bit cleaner.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> 
> Note:
> With changes to the ftrace infrastructure to help with the current
> influx of live patching facilities that we are seeing, I'm going to
> have to make new changes to mcount trampolines. Currently they live in
> entry*.S. They were only placed there for convenience, but not because
> that was the proper place to place it. As other architectures have a
> separate mcount.S file, I think it would be prudent to have x86 do the
> same. Especially as the trampoline code may start to expand for the
> live patching work. Currently, only x86_64 is converted, but there's no
> reason that i386 can't have it as well.
> 
> Thoughts?

I'm fine with the code move per se. That's a good thing.

The live patcher argumentation for it is more than questionable.

Thanks,

	tglx
