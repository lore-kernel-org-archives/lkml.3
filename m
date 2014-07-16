Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965235AbaGPPTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:19:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934419AbaGPPTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:19:01 -0400
Date: Wed, 16 Jul 2014 17:18:58 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] ensure guest's kvmclock never goes backwards when TSC
 jumps backward
Message-ID: <20140716171858.6c8cd597@igors-macbook-pro.local>
In-Reply-To: <53C69269.3080204@redhat.com>
References: <1405504368-5581-1-git-send-email-imammedo@redhat.com>
	<53C6517D.9090600@redhat.com>
	<20140716114100.GA7394@amt.cnet>
	<20140716155523.174a6b0e@igors-macbook-pro.local>
	<53C68931.7000308@redhat.com>
	<20140716165153.02d403c1@igors-macbook-pro.local>
	<53C69269.3080204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014 16:55:37 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 16/07/2014 16:51, Igor Mammedov ha scritto:
> >>>> I'm not sure that a per-CPU value is enough; your patch can make
> >>>> the problem much less frequent of course, but I'm not sure
> >>>> neither detection nor correction are 100% reliable.  Your
> >>>> addition is basically a faster but less reliable version of the
> >>>> last_value logic.
> >>>
> >>> How is it less reliable than last_value logic?
> >>
> >> Suppose CPU 1 is behind by 3 nanoseconds
> >>
> >>     CPU 0                      CPU 1
> >>     time = 100                              (at time 100)
> >>                                time = 99    (at time 102)
> >>     time = 104                              (at time 104)
> >>                                time = 105   (at time 108)
> >>
> >> Your patch will not detect this.
> > Is it possible for each cpu to have it's own time?
> 
> Yes, that's one of the reasons for TSC not to be stable (it could
> also happen simply because the value of TSC_ADJUST MSR is bogus).
I was wondering not about TSC but kvmclock -> sched_clock.
If they are percpu and can differ for each CPU than above diagram if
fine as far as time on each CPU is monotonic and there is not need to
detect that time on each CPU is different.


> 
> Paolo
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

