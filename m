Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab3GKJtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 05:49:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab3GKJtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 05:49:36 -0400
Date: Thu, 11 Jul 2013 12:48:33 +0300
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
        linux-kernel@vger.kernel.org, riel@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
Message-ID: <20130711094833.GC8575@redhat.com>
References: <1372171802.3804.30.camel@oc2024037011.ibm.com>
 <51CAAA26.4090204@linux.vnet.ibm.com>
 <20130626113744.GA6300@hawk.usersys.redhat.com>
 <20130626125240.GY18508@redhat.com>
 <51CAEF45.3010203@linux.vnet.ibm.com>
 <20130626161130.GB18152@redhat.com>
 <51CB2AD9.5060508@linux.vnet.ibm.com>
 <51DBD3C2.2040807@linux.vnet.ibm.com>
 <20130710103325.GP24941@redhat.com>
 <51DE771F.7070805@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DE771F.7070805@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 02:43:03PM +0530, Raghavendra K T wrote:
> On 07/10/2013 04:03 PM, Gleb Natapov wrote:
> [...] trimmed
> 
> >>>Yes. you are right. dynamic ple window was an attempt to solve it.
> >>>
> >>>Probelm is, reducing the SPIN_THRESHOLD is resulting in excess halt
> >>>exits in under-commits and increasing ple_window may be sometimes
> >>>counter productive as it affects other busy-wait constructs such as
> >>>flush_tlb AFAIK.
> >>>So if we could have had a dynamically changing SPIN_THRESHOLD too, that
> >>>would be nice.
> >>>
> >>
> >>Gleb, Andrew,
> >>I tested with the global ple window change (similar to what I posted
> >>here https://lkml.org/lkml/2012/11/11/14 ),
> >This does not look global. It changes PLE per vcpu.
> 
> Okay. Got it. I was thinking it would change the global value. But IIRC
>  It is changing global sysfs value and per vcpu ple_window.
> Sorry. I missed this part yesterday.
> 
Yes, it changes sysfs value but this does not affect already created
vcpus.

> >
> >>But did not see good result. May be it is good to go with per VM
> >>ple_window.
> >>
> >>Gleb,
> >>Can you elaborate little more on what you have in mind regarding per
> >>VM ple_window. (maintaining part of it as a per vm variable is clear
> >>to
> >>  me), but is it that we have to load that every time of guest entry?
> >>
> >Only when it changes, shouldn't be to often no?
> 
> Ok. Thinking how to do. read the register and writeback if there need
> to be a change during guest entry?
> 
Why not do it like in the patch you've linked? When value changes write it
to VMCS of the current vcpu.

--
			Gleb.
