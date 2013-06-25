Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3FYSkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:40:40 -0400
Received: from relay3.sgi.com ([192.48.152.1]:52582 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753291Ab3FYSki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:40:38 -0400
Message-ID: <51C9E422.6040304@sgi.com>
Date: Tue, 25 Jun 2013 11:40:34 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Nathan Zimmer <nzimmer@sgi.com>, Robin Holt <holt@sgi.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <20130621165142.GA32125@kroah.com> <51C48745.9030304@zytor.com> <CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com> <20130621185056.GA23473@kroah.com> <51C4C5F3.3050800@sgi.com> <CAE9FiQXaUNbK9+g-7j6gfvLrSvUJFWWKapDv658LPe4VfbH=tQ@mail.gmail.com> <51C9D4ED.5070805@sgi.com> <51C9DEC1.6030602@zytor.com>
In-Reply-To: <51C9DEC1.6030602@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 6/25/2013 11:17 AM, H. Peter Anvin wrote:
> On 06/25/2013 10:35 AM, Mike Travis wrote:
>>
>> The two params that I couldn't figure out how to provide except via kernel
>> param option was the memory block size (128M or 2G) and the physical
>> address space per node.  The other 3 params can be automatically
>> setup by a script when the total system size is known.  As soon as we
>> verify on the 32TB system and surmise what will be needed for 64TB,
>> then those 3 params can probably disappear.
>>
> 
> "Setup by script" is a no-go.  You *have* the total system size already,
> it is in the e820 tables (anything which isn't in e820 is hotplug, that
> automagically gets deferred.)

Okay, I'll figure something out.  If Yinghai's SRAT patch can help
with the node address space, then I might be able to determine if
the system is a UV which is the only system I see that uses 2G
memory blocks.  (Or make get_memory_block_size() a global.)

Then a simple param to start the insertion early or defer it until
the system is fully up is still useful, and that's easy to understand.

[I think we still want to keep the actual process of moving memory
to the absent list an option, yes?  If for no other reason except
to rule out this code when a problem crops up.  Or at least have a
way to disable the process if it's CONFIG'd in.]

> 
> However, please consider Ingo's counterproposal of doing this via the
> buddy allocator, i.e. hugepages being broken on demand.  That is a
> *very* powerful model, although would require more infrastructure.

We will certainly continue to make improvements as larger system sizes
become more commonplace (and customers continue to complain :).  But
we are cutting it close to including this into the nextgen distro
releases, so it would have to be a follow on project.  (I've been
working on this patch since last November.)

Thanks,
Mike

> 
> 	-hpa
> 
> 
