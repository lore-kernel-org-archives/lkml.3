Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaEHEcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 00:32:10 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54434 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaEHEcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 00:32:08 -0400
Message-ID: <536B0887.70505@linux.vnet.ibm.com>
Date: Thu, 08 May 2014 10:01:03 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <mgalbraith@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] CPU hotplug: Slow down hotplug operations
References: <1399492661-891-1-git-send-email-bp@alien8.de> <20140507130655.9f7c46de8cb39726079458fb@linux-foundation.org> <alpine.DEB.2.02.1405072214420.6261@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1405072214420.6261@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050804-7014-0000-0000-000004D98D05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 01:52 AM, Thomas Gleixner wrote:
> On Wed, 7 May 2014, Andrew Morton wrote:
>> On Wed,  7 May 2014 21:57:41 +0200 Borislav Petkov <bp@alien8.de> wrote:
>>
>>> We have all those eager tester dudes which scratch up a dirty script to
>>> pound on CPU hotplug senselessly and then report bugs they've managed to
>>> trigger.
>>>
>>> Well, first of all, most, if not all, bugs they trigger are CPU hotplug
>>> related anyway. But we know hotplug is full of duct tape and brown
>>> paper bags. So we end up clearly wasting too much time dealing with a
>>> mechanism we know it is b0rked in the first place.
>>>
>>> Oh, and I would understand if that pounding were close to some real
>>> usage patterns but I've yet to receive a justification for toggling
>>> cores on- and offline senselessly.
>>>
>>> In any case, before this gets rewritten properly (I'm being told we
>>> might get lucky after all) let's slow down hotplugging on purpose and
>>> thus make it uninteresting, as a temporary brown paper bag solution
>>> until the real thing gets done.
>>>
>>> This way we'll save us a lot of time and efforts in chasing the wrong
>>> bugs.
>>
>> Well, I only yesterday merged Srivatsa's `CPU hotplug, stop-machine:
>> plug race-window that leads to "IPI-to-offline-CPU"' bugfix.  That bug
>> presumably wouldn't have been fixed if this patch was in place.
> 
> True.
> 
> OTOH, if people would have spent the same amount of time to rewrite
> the hotplug mess, we would have a way bigger benefit. But no, we
> prefer to add more layers of duct tape and bandaid hackery to it. 
> 
> I tried a redesign and run out of cycles, but the patches are out
> there and none of the folks who promised to complete them ever
> delivered. If nothing fundamental changes, I'm going to spend some
> serious time on it in the next couple of month.
>

Yeah, that's quite unfortunate. Even several of my own attempts to try
and fix some of the chronic issues of CPU hotplug (such as the removal
of CPU hotplug's dependency on stop-machine, consolidation of all the
duplicated and buggy CPU hotplug code in various architectures etc.) all
met a similar fate. Initially there was some amount of consensus on these
patchsets and designs, but eventually they got nowhere due to lack of any
further feedback or signs of upstream acceptance.


Stop-machine()-free CPU hotplug, v6:
http://lwn.net/Articles/538819/

With performance improvements:
http://article.gmane.org/gmane.linux.kernel/1435249

Attempt to upstream that patchset in parts, v3:
http://lwn.net/Articles/556727/

Generic SMP boot/cpu-hotplug framework to consolidate arch/ code:
https://lwn.net/Articles/500185/

But, luckily the recent work to fix the notifier deadlock mess actually
went upstream, fairly quickly. So we have one less CPU hotplug problem
to fix! :-)
https://lkml.org/lkml/2014/3/10/522

Regards,
Srivatsa S. Bhat

