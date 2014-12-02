Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159AbaLBT5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:57:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:49757 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933377AbaLBT5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:57:03 -0500
Date: Tue, 2 Dec 2014 20:56:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: "Berthier, Emmanuel" <emmanuel.berthier@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
In-Reply-To: <CALCETrWxXm_Cvu+3dakCFX1GSN2KcaoxC+qbTr8Z7ha2CtEEXw@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412022044410.16275@nanos>
References: <65CD3FC07F3BF942ABE211646D72D770356EACA5@IRSMSX110.ger.corp.intel.com> <1417099205-13309-1-git-send-email-emmanuel.berthier@intel.com> <alpine.DEB.2.11.1411271609510.3961@nanos> <CALCETrWKiTdzSQ6kKPaufHoW2aTjPtqkQy9cyq_YiBwoowe-+g@mail.gmail.com>
 <65CD3FC07F3BF942ABE211646D72D770356EB2B2@IRSMSX110.ger.corp.intel.com> <CALCETrWO5jVaXrvtMmxEtV0-9husbwFrm=FLWUvEJJev25KXmg@mail.gmail.com> <65CD3FC07F3BF942ABE211646D72D770356EC658@IRSMSX110.ger.corp.intel.com>
 <CALCETrWxXm_Cvu+3dakCFX1GSN2KcaoxC+qbTr8Z7ha2CtEEXw@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014, Andy Lutomirski wrote:
> TBH, I'm wondering whether this is actually a good idea.  It might be
> more valuable and less scary to try to make this work for BUG instead.
> To get the most impact, it might be worth allocating a new exception
> vector for BUG and using 'int 0xwhatever', and the prologue to that
> could read out all the MSRs without any branches.

BUG is pretty uninteresting. We usually know how we got there. Now
where LBR might be useful is if you have stack corruption and branch
into nirvana or access random crap via a few hoops. There the LBR data
might help, because the corrupted stack does not tell anything.

So yes, this is a corner case debugging scenario, but given the
complexity of coordination with perf and the possible intrusiveness in
the low level entry path, we really need to see a few real world
examples where this helps, aside of the constructed case.

Thanks,

	tglx
