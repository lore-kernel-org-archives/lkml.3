Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab3J1PBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:01:23 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:57795 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab3J1PBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:01:18 -0400
Date: Mon, 28 Oct 2013 16:01:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
Message-ID: <20131028150114.GA12905@gmail.com>
References: <525BD08C.2080101@t-online.de>
 <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
 <CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com>
 <alpine.DEB.2.02.1310251221310.5266@ionos.tec.linutronix.de>
 <CA+55aFxw1Hm4QVeEigkByP5RppSL30oHnLoR16C=henf-a=uFQ@mail.gmail.com>
 <20131026114303.GA24067@gmail.com>
 <526E79A2.9080303@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526E79A2.9080303@t-online.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Knut Petersen <Knut_Petersen@t-online.de> wrote:

> On 26.10.2013 13:43, Ingo Molnar wrote:
> >* Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> >>On Fri, Oct 25, 2013 at 11:23 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >>>Enable DEBUG_OBJECTS, DEBUG_OBJECTS_FREE, DEBUG_OBJECTS_TIMERS
> >>Yes, but nobody has actually been able to trigger it with those.
> >>It's pretty rare, and the debug options are so expensive that they
> >>aren't reasonable to enable generally...
> >>
> >>So we need to try to figure out how to trigger it, or narrow
> >>things down some way..
> >If it's timing then maybe the 1 seconds delay isn't enough
> >(especially if it's boot related, where we have a couple of delays
> >already) - the patch below triples it.
> >
> >(If the bug goes away due to some other side effect then this patch
> >won't make a difference to reproducability.)
> 
> I tried that patch, together with all the kobj debug options 
> enabled. With that kernel configuration I was unable to reproduce 
> the problem during 500 typical workload / reboot cycles. Without 
> the debug options I was able to reproduce the last reported panic 
> after 91 cycles. The debug options seem to change timing 
> sufficiently to mask the bug ;-(

Could you send me the kernel config please?

Thanks,

	Ingo
