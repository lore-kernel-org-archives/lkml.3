Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3DVUIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:08:22 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40257
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754886Ab3DVUIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:08:21 -0400
Message-ID: <1366661294.6454.18.camel@laptop>
Subject: Re: Preemptable Ticket Spinlock
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Jiannan Ouyang <ouyang@cs.pitt.edu>, LKML <linux-kernel@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Karen Noel <knoel@redhat.com>
Date: Mon, 22 Apr 2013 22:08:14 +0200
In-Reply-To: <517595FA.800@redhat.com>
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
	   <51745650.9050204@redhat.com> <1366631460.4443.3.camel@laptop>
	  <51753289.70406@redhat.com> <1366660147.6454.6.camel@laptop>
	 <517595FA.800@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-22 at 15:56 -0400, Rik van Riel wrote:
> On 04/22/2013 03:49 PM, Peter Zijlstra wrote:
> > On Mon, 2013-04-22 at 08:52 -0400, Rik van Riel wrote:
> 
> >> If the native spin_lock code has been called already at
> >> that time, the native code would still need to be modified
> >> to increment the ticket number by 2, so we end up with a
> >> compatible value in each spin lock's .tickets field, and
> >> prevent a deadlock after we switch over to the paravirt
> >> variant.
> >
> > I thought the stuff already made it upstream, but apparently not; the
> > lastest posting I'm aware of is here:
> >
> >    https://lkml.org/lkml/2012/5/2/105
> >
> > That stuff changes the normal ticket increment as well..
> 
> Jiannan,
> 
> It looks like the patch above could make a good patch
> 1 (or 2) in your patch series :)

I much prefer the entire series from Jeremy since it maintains the
ticket semantics and doesn't degrade the lock to unfair under
contention.

Now I suppose there's a reason its not been merged yet and I suspect
its !paravirt hotpath impact which wasn't rightly justified or somesuch
so maybe someone can work on that or so.. dunno.


