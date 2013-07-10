Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab3GJLbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:31:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735Ab3GJLbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:31:34 -0400
Date: Wed, 10 Jul 2013 14:29:24 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andrew Jones <drjones@redhat.com>,
        mingo@redhat.com, ouyang@cs.pitt.edu, habanero@linux.vnet.ibm.com,
        jeremy@goop.org, x86@kernel.org, konrad.wilk@oracle.com, hpa@zytor.com,
        pbonzini@redhat.com, linux-doc@vger.kernel.org,
        xen-devel@lists.xensource.com, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, gregkh@suse.de, agraf@suse.de,
        chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
Message-ID: <20130710112924.GT24941@redhat.com>
References: <20130626113744.GA6300@hawk.usersys.redhat.com>
 <20130626125240.GY18508@redhat.com>
 <51CAEF45.3010203@linux.vnet.ibm.com>
 <20130626161130.GB18152@redhat.com>
 <51CB2AD9.5060508@linux.vnet.ibm.com>
 <51DBD3C2.2040807@linux.vnet.ibm.com>
 <20130710103325.GP24941@redhat.com>
 <20130710104047.GP25631@dyad.programming.kicks-ass.net>
 <20130710104717.GR24941@redhat.com>
 <51DD455D.4000701@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DD455D.4000701@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 04:58:29PM +0530, Raghavendra K T wrote:
> On 07/10/2013 04:17 PM, Gleb Natapov wrote:
> >On Wed, Jul 10, 2013 at 12:40:47PM +0200, Peter Zijlstra wrote:
> >>On Wed, Jul 10, 2013 at 01:33:25PM +0300, Gleb Natapov wrote:
> >>
> >>Here's an idea, trim the damn email ;-) -- not only directed at gleb.
> >>
> >Good idea.
> >
> >>>>Ingo, Gleb,
> >>>>
> >>>> From the results perspective, Andrew Theurer, Vinod's test results are
> >>>>pro-pvspinlock.
> >>>>Could you please help me to know what will make it a mergeable
> >>>>candidate?.
> >>>>
> >>>I need to spend more time reviewing it :) The problem with PV interfaces
> >>>is that they are easy to add but hard to get rid of if better solution
> >>>(HW or otherwise) appears.
> >>
> >>How so? Just make sure the registration for the PV interface is optional; that
> >>is, allow it to fail. A guest that fails the PV setup will either have to try
> >>another PV interface or fall back to 'native'.
> >>
> >We have to carry PV around for live migration purposes. PV interface
> >cannot disappear under a running guest.
> >
> 
> IIRC, The only requirement was running state of the vcpu to be retained.
> This was addressed by
> [PATCH RFC V10 13/18] kvm : Fold pv_unhalt flag into GET_MP_STATE
> ioctl to aid migration.
> 
> I would have to know more if I missed something here.
> 
I was not talking about the state that has to be migrated, but
HV<->guest interface that has to be preserved after migration.

--
			Gleb.
