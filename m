Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaCFO1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:27:05 -0500
Received: from mail.lang.hm ([64.81.33.126]:55278 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbaCFO1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:27:03 -0500
Date: Thu, 6 Mar 2014 06:25:50 -0800 (PST)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Kevin Easton <kevin@guarana.org>
cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Khalid Aziz <khalid.aziz@oracle.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        peterz@infradead.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, oleg@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
In-Reply-To: <20140306121333.GA12127@chicago.guarana.org>
Message-ID: <alpine.DEB.2.02.1403060624150.32171@nftneq.ynat.uz>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <8738ix5uyk.fsf@tassilo.jf.intel.com>
 <20140306121333.GA12127@chicago.guarana.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014, Kevin Easton wrote:

> On Tue, Mar 04, 2014 at 04:51:15PM -0800, Andi Kleen wrote:
>> Anything else?
>
> If it was possible to make the time remaining in the current timeslice
> available to userspace through the vdso, the thread could do something like:
>
> if (sys_timeleft() < CRITICAL_SECTION_SIZE)
>    yield();
> lock();
>
> to avoid running out of timeslice in the middle of the critical section.

but won't the system call result in context switches? According to Kevin, even a 
context switch to another thread and back immediatly is bad enough to need to be 
avoided, so replacing that with the context switch to the kernel and back isn't 
a subtantial win.

David Lang
