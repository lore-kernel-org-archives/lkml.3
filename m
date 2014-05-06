Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240AbaEFHce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:32:34 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:40032 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934205AbaEFHcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:32:33 -0400
Date: Tue, 6 May 2014 09:32:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Lang <david@lang.hm>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140506073228.GA26271@gmail.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
 <alpine.LRH.2.00.1405021504320.22053@twin.jikos.cz>
 <alpine.DEB.2.02.1405051633080.14881@nftneq.ynat.uz>
 <alpine.LNX.2.00.1405060147190.3969@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1405060147190.3969@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Mon, 5 May 2014, David Lang wrote:
> 
> > how would you know that all instances of the datastructure in memory 
> > have= been touched? just because all tasks have run and are outside the 
> > function in question doesn't tell you data structures have been 
> > converted. You have n= o way of knowing when (or if) the next call to 
> > the modified function will take place on any potential in-memory 
> > structure.
> 
> The problem you are trying to avoid here is functions expecting to read 
> "v2" format of the data from memory, while there are still tasks that are 
> unpredictably writing "v1" format of the data to the memory.
> 
> There are several ways to attack this problem:
> 
> - stop the whole system, convert all the existing data structures to new 
>   format (which might potentially be non-trivial, mostly because you 
>   have to *know* where all the data structures have been allocated), apply 
>   patch, resume operation [ksplice, probably kpatch in future]
> - restrict the data format to be backwards compatible [to be done 
>   manually during patch creation, currently what kGraft needs to do in 
>   such case]
> - have a proxy code which can read both "v1" and "v2" formats, and writes 
>   back in the same format it has seen the data structure on input
> - once all the *code* has been converted, it still has to understand "v1" 
>   and "v2", but it can now start writing out "v2" format only [possible 
>   with kGraft, not implemented in automated fashion]
> 
> Ideas are of course more than welcome.

So what I'm curious about, what is the actual 'in the field' distro 
experience, about the type of live-patches that get pushed with 
urgency?

My guess would be that the overwhelming majority of live-patches don't 
change data structures - and hence the right initial model would be to 
ensure (via tooling, and via review) that 'v1' and 'v2' data is 
exactly the same.

The most abstract way to 'live patch' a kernel is to do a checkpoint 
save on all application state, to reboot the kernel, boot into the 
patched kernel and then restore all application state seemlessly.

i.e. the CR effort that has been going on for years, to save/restore 
all state that is exposed through a kernel ABI. That allows a complete 
kernel to be switched out, without affecting applications.

Thanks,

	Ingo
