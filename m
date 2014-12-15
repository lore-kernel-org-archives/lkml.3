Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaLONIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 08:08:19 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:47025 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaLONIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 08:08:17 -0500
Date: Mon, 15 Dec 2014 14:08:08 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, tglx@linutronix.de,
        David.Laight@ACULAB.COM, hughd@google.com, hocko@suse.cz
Subject: Re: [PATCH v2 0/5] Reenable might_sleep() checks for might_fault()
Message-ID: <20141215140808.7a165f00@thinkpad-w530>
In-Reply-To: <20141215125014.GI21343@twins.programming.kicks-ass.net>
References: <1418221414-60110-1-git-send-email-dahi@linux.vnet.ibm.com>
	<20141215104549.GY29390@twins.programming.kicks-ass.net>
	<20141215122127.5fd6f5ae@thinkpad-w530>
	<20141215125014.GI21343@twins.programming.kicks-ass.net>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121513-0009-0000-0000-00000261C847
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Dec 15, 2014 at 12:21:27PM +0100, David Hildenbrand wrote:
> > > On Wed, Dec 10, 2014 at 03:23:29PM +0100, David Hildenbrand wrote:
> > > 
> > > Did you look at the -rt patches where this comes from?
> > > 
> > > https://git.kernel.org/cgit/linux/kernel/git/clrkwllms/rt-linux.git/commit/?h=v3.14.21-rt9&id=b389ced19ab649438196d132768fe6522d2f052b
> > > https://git.kernel.org/cgit/linux/kernel/git/clrkwllms/rt-linux.git/commit/?h=v3.14.21-rt9&id=4fb7f9d416f7b34036d9d1b209e77c462ac0ee10
> > > https://git.kernel.org/cgit/linux/kernel/git/clrkwllms/rt-linux.git/commit/?h=v3.14.21-rt9&id=c730a4aade9e5c9b84f65de01d6612bf70c577e3
> > > https://git.kernel.org/cgit/linux/kernel/git/clrkwllms/rt-linux.git/commit/?h=v3.14.21-rt9&id=d365f5bf933e988a39874b33302f02ff6c7989b7
> > > https://git.kernel.org/cgit/linux/kernel/git/clrkwllms/rt-linux.git/commit/?h=v3.14.21-rt9&id=93eb18f43dfa5d49d99e2b8ad236eea2c35dd539
> > > https://git.kernel.org/cgit/linux/kernel/git/clrkwllms/rt-linux.git/commit/?h=v3.14.21-rt9&id=8947442e896921e1b645f9e1fd0f2beee103bba0
> > > 
> > > 
> > 
> > Thanks for the links - haven't seen these patches so far (somebody on the list
> > just mentioned that someone tried to demangle that stuff some time ago). But
> > good to know that somebody is working on that pagefault_disable() thing.
> > 
> > Do you know what the plans for this series are? So I can base my patches
> > (might_sleep() checks for might_fault()) on that queue.
> 
> As stated in that other email, there's no active work on this atm. Its
> just what -rt needed the pagefault_{en,dis}able() bits for. I think we
> should try and merge some of that upstream now that there is a stronger
> use case.
> 

Ah, now I get it. So the main question is which approach is better:

a) -rt version: Store the pagefault_count in struct task_struct()
b) my version: Storing it in thread_info

IOW: My series first and the -rt part (pagefault handlers, preempt fixup) on
top or -rt version first and my work (patch 3 + 4 ) on top.

Getting rid of that whole preemption handling in pagefault_disable() / fixing up
the pagefault handlers is something I would have addressed in future patches,
but that part seems to be just fine in the -rt code.

Thanks for having a look!

David

