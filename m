Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbaLEQRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:17:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaLEQR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:17:29 -0500
Date: Fri, 5 Dec 2014 14:17:01 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, Luiz Capitulino <lcapitulino@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>, kvm@vger.kernel.org
Subject: Re: [patch -rt 2/2] KVM: lapic: mark LAPIC timer handler as irqsafe
Message-ID: <20141205161701.GA29003@amt.cnet>
References: <20141125172108.992070524@redhat.com>
 <20141125172329.580701786@redhat.com>
 <5474D476.3020506@redhat.com>
 <alpine.DEB.2.11.1411252123480.3961@nanos>
 <54806756.30503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54806756.30503@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 02:53:26PM +0100, Paolo Bonzini wrote:
> 
> 
> On 25/11/2014 21:24, Thomas Gleixner wrote:
> > On Tue, 25 Nov 2014, Rik van Riel wrote:
> >> On 11/25/2014 12:21 PM, Marcelo Tosatti wrote:
> >>> Since lapic timer handler only wakes up a simple waitqueue,
> >>> it can be executed from hardirq context.
> >>>
> >>> Reduces average cyclictest latency by 3us.
> >>
> >> Can this patch be merged in the KVM tree, and go
> >> upstream via Paolo?
> > 
> > Not really as it has RT dependencies ....
> 
> Can hrtimer_start_expires even return ETIME on a non-RT kernel?  If yes,
> I can take patch 2.  If not, it's better to keep both patches in the RT
> tree.
> 
> Paolo

It can't. We're still evaluating the necessity of this patch, will
resubmit accordingly.

