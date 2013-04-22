Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3DVNRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:17:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59572 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3DVNRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:17:09 -0400
Date: Mon, 22 Apr 2013 06:16:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, tiwai@suse.de,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: irq 16: nobody cared
Message-ID: <20130422131644.GH3509@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130421181035.GC4559@pd.tnic>
 <20130421185609.GD3509@linux.vnet.ibm.com>
 <20130421190655.GA5807@pd.tnic>
 <20130421203447.GE3509@linux.vnet.ibm.com>
 <20130421205139.GC5807@pd.tnic>
 <20130421214241.GA4593@pd.tnic>
 <20130421220015.GF3509@linux.vnet.ibm.com>
 <20130421221242.GB4593@pd.tnic>
 <20130422080136.GA7080@gmail.com>
 <20130422091847.GB4637@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130422091847.GB4637@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042213-7282-0000-0000-0000166C0452
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 11:18:47AM +0200, Borislav Petkov wrote:
> On Mon, Apr 22, 2013 at 10:01:36AM +0200, Ingo Molnar wrote:
> > Hm, this really smells like a workaround: treating the symptom, not
> > the cause.
> 
> Well, I just tested Takashi's add missing synchronize_irq() to the
> suspend path of snd_hda_intel and it doesn't help.
> 
> So it could be an issue with this driver or only this hw/driver can
> exacerbate RCU this much to trigger the spurious irq machinery.
> 
> > How can an increase in grace-periods break drivers and suspend? Do we
> > understand exactly what happens there?
> 
> I'd rather look into Paul's direction here. :)

I believe that we need both -- a fix that prevents the stray irq for
normal CONFIG_RCU_FAST_NO_HZ grace periods and also expediting grace
periods during suspend/resume.  I am greedy that way.  ;-)

						Thanx, Paul

> > If we do, can we fix that instead of tweaking the RCU timeouts?
> 
> Well, I was under the impression yesterday that we actually want
> to switch to expedited grace periods for suspend/resume *anyway*,
> regardless of drivers.
> 
> Paul?
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 

