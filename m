Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbaCEQhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:37:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbaCEQhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:37:50 -0500
Date: Wed, 5 Mar 2014 17:36:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Khalid Aziz <khalid.aziz@oracle.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        peterz@infradead.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
Message-ID: <20140305163644.GA2824@redhat.com>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de> <8738ix5uyk.fsf@tassilo.jf.intel.com> <20140305145420.GA30173@redhat.com> <20140305155601.GF22728@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305155601.GF22728@two.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Andi Kleen wrote:
>
> On Wed, Mar 05, 2014 at 03:54:20PM +0100, Oleg Nesterov wrote:
> > On 03/04, Andi Kleen wrote:
> > >
> > > Anything else?
> >
> > Well, we have yield_to(). Perhaps sys_yield_to(lock_owner) can help.
> > Or perhaps sys_futex() can do this if it knows the owner. Don't ask
> > me what exactly I mean though ;)
>
> You mean yield_to() would extend the time slice?
>
> That would be the same as the mmap page, just with a syscall right?

Not the same. Very roughly I meant something like

	my_lock()
	{
		if (!TRY_LOCK()) {
			yield_to(owner);
			LOCK();
		}

		owner = gettid();
	}

But once again, I am not sure if this makes any sense.

Oleg.

