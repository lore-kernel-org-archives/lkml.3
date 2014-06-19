Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbaFSOks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:40:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138AbaFSOkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:40:45 -0400
Message-ID: <53A2F63D.6010704@redhat.com>
Date: Thu, 19 Jun 2014 16:39:57 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Eric Northup <digitaleric@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, gleb@kernel.org,
        Stephane Eranian <eranian@google.com>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] kvm: Implement PEBS virtualization
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org> <1401412327-14810-5-git-send-email-andi@firstfloor.org> <CAG7+5M2h1_h2fW1KiD-ReXuxDe_EwmBUOJRwjgAvR79sUBxtgA@mail.gmail.com> <20140602195711.GQ25366@two.firstfloor.org>
In-Reply-To: <20140602195711.GQ25366@two.firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/06/2014 21:57, Andi Kleen ha scritto:
> > It would be a bigger concern if we expected virtual PMU migration to
> > work, but I think it would be nice to update kvm_pmu_cpuid_update() to
> > notice the presence/absence of the new CPUID bits, and then store that
> > into per-VM kvm_pmu->pebs_allowed rather than relying only on the
> > per-host perf_pebs_virtualization().
>
> I hope at some point it can work. There shouldn't be any problems
> with migrating to the same CPU model, in many cases (same event
> and same PEBS format) it'll likely even work between models or
> gracefully degrade.

The code is there in both kernel and QEMU, it's just very little tested.

Paolo
