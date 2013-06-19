Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3FSN3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:29:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481Ab3FSN3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:29:40 -0400
Message-ID: <51C1B23B.7080703@redhat.com>
Date: Wed, 19 Jun 2013 15:29:31 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Batalov Eugene <eabatalov89@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Eugene Batalov <ebatalov@parallels.com>, kvm@vger.kernel.org,
        Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv1] kvm guest: fix uninitialized kvmclock read by KVM guest
References: <20130610201933.GA31409@amt.cnet> <1371319305-590-1-git-send-email-ebatalov@parallels.com> <20130618222114.GC13856@amt.cnet> <51C1AC93.6010001@redhat.com> <CAJF2t5sYHy9q9a7-fZauf1Z7_FkK1_DOP13GHji=8-vDUsnnsQ@mail.gmail.com>
In-Reply-To: <CAJF2t5sYHy9q9a7-fZauf1Z7_FkK1_DOP13GHji=8-vDUsnnsQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/06/2013 15:20, Batalov Eugene ha scritto:
> 
> I've missed this detail. It looks like Igor's patch doesn't bring
> secondary cpus kvm_clocksource behavior back to one before the regression,
> Before the regression per_cpu variables are used to allocate
> kvm_pv_clock areas.
> To to usage of percpu variables bootstrap cpu kvm_clock area contents
> were copied to smp secondary cpus kvm_clock areas when they were started.
> Bootstrap cpu kvm_clock area was not zeroed at this time.
> So kvm_pv_clock for secondary cpus never returned "zero" clock before
> the regression.
> 
> During the analysis of the bug I introduced idea to return zero before
> kvm clocksource is initialized for secondary cpus
> just like bootstrap cpu does on kernel boot. You can read that in BZ.

Yes, this is why I prefer to invert the two function calls.  But Igor's
patch fixes the hang (trivially because version is even) and is more
appropriate for -rc6.

Paolo
