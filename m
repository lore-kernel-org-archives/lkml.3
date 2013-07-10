Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3GJLnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:43:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab3GJLnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:43:02 -0400
Date: Wed, 10 Jul 2013 14:41:50 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Andrew Jones <drjones@redhat.com>, mingo@redhat.com, ouyang@cs.pitt.edu,
        habanero@linux.vnet.ibm.com, jeremy@goop.org, x86@kernel.org,
        konrad.wilk@oracle.com, hpa@zytor.com, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, gregkh@suse.de, agraf@suse.de,
        chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
Message-ID: <20130710114150.GU24941@redhat.com>
References: <1372171802.3804.30.camel@oc2024037011.ibm.com>
 <51CAAA26.4090204@linux.vnet.ibm.com>
 <20130626113744.GA6300@hawk.usersys.redhat.com>
 <20130626125240.GY18508@redhat.com>
 <51CAEF45.3010203@linux.vnet.ibm.com>
 <20130626161130.GB18152@redhat.com>
 <51CB2AD9.5060508@linux.vnet.ibm.com>
 <51DBD3C2.2040807@linux.vnet.ibm.com>
 <20130710103325.GP24941@redhat.com>
 <51DD445C.5070801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DD445C.5070801@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 04:54:12PM +0530, Raghavendra K T wrote:
> >>Ingo, Gleb,
> >>
> >> From the results perspective, Andrew Theurer, Vinod's test results are
> >>pro-pvspinlock.
> >>Could you please help me to know what will make it a mergeable
> >>candidate?.
> >>
> >I need to spend more time reviewing it :) The problem with PV interfaces
> >is that they are easy to add but hard to get rid of if better solution
> >(HW or otherwise) appears.
> 
> Infact Avi had acked the whole V8 series, but delayed for seeing how
> PLE improvement would affect it.
> 
I see that Ingo was happy with it too.

> The only addition from that series has been
> 1. tuning the SPIN_THRESHOLD to 32k (from 2k)
> and
> 2. the halt handler now calls vcpu_on_spin to take the advantage of
> PLE improvements. (this can also go as an independent patch into
> kvm)
> 
> The rationale for making SPIN_THERSHOLD 32k needs big explanation.
> Before PLE improvements, as you know,
> kvm undercommit scenario was very worse in ple enabled cases.
> (compared to ple disabled cases).
> pvspinlock patches behaved equally bad in undercommit. Both had
> similar reason so at the end there was no degradation w.r.t base.
> 
> The reason for bad performance in PLE case was unneeded vcpu
> iteration in ple handler resulting in high yield_to calls and double
> run queue locks.
> With pvspinlock applied, same villain role was played by excessive
> halt exits.
> 
> But after ple handler improved, we needed to throttle unnecessary halts
> in undercommit for pvspinlock to be on par with 1x result.
> 
Make sense. I will review it ASAP. BTW the latest version is V10 right?

--
			Gleb.
