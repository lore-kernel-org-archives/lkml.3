Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3GJKsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:48:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab3GJKsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:48:45 -0400
Date: Wed, 10 Jul 2013 13:47:17 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andrew Jones <drjones@redhat.com>, mingo@redhat.com,
        ouyang@cs.pitt.edu, habanero@linux.vnet.ibm.com, jeremy@goop.org,
        x86@kernel.org, konrad.wilk@oracle.com, hpa@zytor.com,
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
Message-ID: <20130710104717.GR24941@redhat.com>
References: <1372171802.3804.30.camel@oc2024037011.ibm.com>
 <51CAAA26.4090204@linux.vnet.ibm.com>
 <20130626113744.GA6300@hawk.usersys.redhat.com>
 <20130626125240.GY18508@redhat.com>
 <51CAEF45.3010203@linux.vnet.ibm.com>
 <20130626161130.GB18152@redhat.com>
 <51CB2AD9.5060508@linux.vnet.ibm.com>
 <51DBD3C2.2040807@linux.vnet.ibm.com>
 <20130710103325.GP24941@redhat.com>
 <20130710104047.GP25631@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710104047.GP25631@dyad.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 12:40:47PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 10, 2013 at 01:33:25PM +0300, Gleb Natapov wrote:
> 
> Here's an idea, trim the damn email ;-) -- not only directed at gleb.
> 
Good idea.

> > > Ingo, Gleb,
> > > 
> > > From the results perspective, Andrew Theurer, Vinod's test results are
> > > pro-pvspinlock.
> > > Could you please help me to know what will make it a mergeable
> > > candidate?.
> > > 
> > I need to spend more time reviewing it :) The problem with PV interfaces
> > is that they are easy to add but hard to get rid of if better solution
> > (HW or otherwise) appears.
> 
> How so? Just make sure the registration for the PV interface is optional; that
> is, allow it to fail. A guest that fails the PV setup will either have to try
> another PV interface or fall back to 'native'.
> 
We have to carry PV around for live migration purposes. PV interface
cannot disappear under a running guest.

> > > I agree that Jiannan's Preemptable Lock idea is promising and we could
> > > evaluate that  approach, and make the best one get into kernel and also
> > > will carry on discussion with Jiannan to improve that patch.
> > That would be great. The work is stalled from what I can tell.
> 
> I absolutely hated that stuff because it wrecked the native code.
Yes, the idea was to hide it from native code behind PV hooks.

--
			Gleb.
