Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaLDNoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:44:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231AbaLDNoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:44:16 -0500
Date: Thu, 4 Dec 2014 11:43:52 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Luiz Capitulino <lcapitulino@redhat.com>,
        Rik van Riel <riel@redhat.com>, Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org
Subject: Re: [patch -rt 2/2] KVM: lapic: mark LAPIC timer handler as irqsafe
Message-ID: <20141204134352.GA28510@amt.cnet>
References: <20141125172108.992070524@redhat.com>
 <20141125172329.580701786@redhat.com>
 <5474BE7C.5040909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5474BE7C.5040909@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 06:38:04PM +0100, Paolo Bonzini wrote:
> 
> 
> On 25/11/2014 18:21, Marcelo Tosatti wrote:
> > +
> > +	if (r == HRTIMER_RESTART) {
> > +		do {
> > +			ret = hrtimer_start_expires(data, HRTIMER_MODE_ABS);
> > +			if (ret == -ETIME)
> > +				hrtimer_add_expires_ns(&ktimer->timer,
> > +							ktimer->period);
> 
> Is it possible to just compute the time where the next interrupt
> happens?  

Yes but there is no guarantee hrtimer_start_expires will not fail.

> I suspect the printk and WARN_ON below can be easily triggered
> by a guest.

I'll remove those, thanks.


