Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965185Ab3FTIkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:40:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965175Ab3FTIks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:40:48 -0400
Date: Thu, 20 Jun 2013 10:30:04 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Batalov Eugene <eabatalov89@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eugene Batalov <ebatalov@parallels.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv1] kvm guest: fix uninitialized kvmclock read by KVM
 guest
Message-ID: <20130620103004.4aa39c47@nial.usersys.redhat.com>
In-Reply-To: <51C1B23B.7080703@redhat.com>
References: <20130610201933.GA31409@amt.cnet>
	<1371319305-590-1-git-send-email-ebatalov@parallels.com>
	<20130618222114.GC13856@amt.cnet>
	<51C1AC93.6010001@redhat.com>
	<CAJF2t5sYHy9q9a7-fZauf1Z7_FkK1_DOP13GHji=8-vDUsnnsQ@mail.gmail.com>
	<51C1B23B.7080703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jun 2013 15:29:31 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 19/06/2013 15:20, Batalov Eugene ha scritto:
> > 
> > I've missed this detail. It looks like Igor's patch doesn't bring
> > secondary cpus kvm_clocksource behavior back to one before the regression,
> > Before the regression per_cpu variables are used to allocate
> > kvm_pv_clock areas.
> > To to usage of percpu variables bootstrap cpu kvm_clock area contents
> > were copied to smp secondary cpus kvm_clock areas when they were started.
> > Bootstrap cpu kvm_clock area was not zeroed at this time.
> > So kvm_pv_clock for secondary cpus never returned "zero" clock before
> > the regression.
> > 
> > During the analysis of the bug I introduced idea to return zero before
> > kvm clocksource is initialized for secondary cpus
> > just like bootstrap cpu does on kernel boot. You can read that in BZ.
> 
> Yes, this is why I prefer to invert the two function calls.  But Igor's
> patch fixes the hang (trivially because version is even) and is more
> appropriate for -rc6.

I'll post this swap shortly, but zeroing out hv_clock at init time,
would be still needed to provide sane values there if ftrace enabled
at that time.

> 
> Paolo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

