Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbaEFWtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 18:49:35 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54053 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbaEFWtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 18:49:33 -0400
Message-ID: <536966F5.2020600@hitachi.com>
Date: Wed, 07 May 2014 07:49:25 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Seth Jennings <sjenning@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
References: <cover.1398958771.git.jpoimboe@redhat.com> <20140505085537.GA32196@gmail.com> <20140505132638.GA14432@treble.redhat.com> <20140505141038.GA27403@localhost.localdomain> <20140505184304.GA15137@gmail.com> <20140505214919.GE2099@localhost.localdomain> <20140506121211.GA4125@treble.redhat.com> <20140506083346.2c96b8ad@gandalf.local.home>
In-Reply-To: <20140506083346.2c96b8ad@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/06 21:33), Steven Rostedt wrote:
> On Tue, 6 May 2014 07:12:11 -0500
> Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> 
>> Live patching is a very sensitive and risky operation, and from a kernel
>> standpoint we should make it as safe as we reasonably can.  But we can't
>> do much about careless users.  Ultimately the risk is in the hands of
>> the user and their choice of patches.  They need to absolutely
>> understand all the implications of patching a particular function.  If
>> the patch changes the way a function interacts with some external data,
>> then they're starting to tempt fate and they need to be extra careful.
>> This care needs to be taken for *all* kernel functions, not just for the
>> few that are called from kernel threads.
> 
> Ideally the kpatch tools should be able to somewhat prevent users from
> doing damage. Or at least make them type a sentence that says:
> 
>   I know what I'm doing and will not blame anyone but myself if this
>   kills the system along with all my puppies and kittens.
> 
> I'm guessing that kpatch needs to be marketed that a distro or "hired
> help" will be creating the patch and the admin only needs to "trust"
> the one that gave them the kpatch module to load. All the
> testing/checking that the module works will be done by kernel
> developers and not by any "users".

I strongly agreed. Desktop/Cloud users may not care about it, most of
users just update kernel and reboot. Somewhat "enterprise" users may
also like to do "rolling update" their cluster systems. Only limited
mission critical non-stop systems require it. And since they usually
don't want to loose distro support, all binary patches will be provided
and tested by distro kernel developers, not by users itself. :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


