Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab3GJKm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:42:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45776 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab3GJKmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:42:23 -0400
Date: Wed, 10 Jul 2013 12:40:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
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
Message-ID: <20130710104047.GP25631@dyad.programming.kicks-ass.net>
References: <20130601192125.5966.35563.sendpatchset@codeblue>
 <1372171802.3804.30.camel@oc2024037011.ibm.com>
 <51CAAA26.4090204@linux.vnet.ibm.com>
 <20130626113744.GA6300@hawk.usersys.redhat.com>
 <20130626125240.GY18508@redhat.com>
 <51CAEF45.3010203@linux.vnet.ibm.com>
 <20130626161130.GB18152@redhat.com>
 <51CB2AD9.5060508@linux.vnet.ibm.com>
 <51DBD3C2.2040807@linux.vnet.ibm.com>
 <20130710103325.GP24941@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710103325.GP24941@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 01:33:25PM +0300, Gleb Natapov wrote:

Here's an idea, trim the damn email ;-) -- not only directed at gleb.

> > Ingo, Gleb,
> > 
> > From the results perspective, Andrew Theurer, Vinod's test results are
> > pro-pvspinlock.
> > Could you please help me to know what will make it a mergeable
> > candidate?.
> > 
> I need to spend more time reviewing it :) The problem with PV interfaces
> is that they are easy to add but hard to get rid of if better solution
> (HW or otherwise) appears.

How so? Just make sure the registration for the PV interface is optional; that
is, allow it to fail. A guest that fails the PV setup will either have to try
another PV interface or fall back to 'native'.

> > I agree that Jiannan's Preemptable Lock idea is promising and we could
> > evaluate that  approach, and make the best one get into kernel and also
> > will carry on discussion with Jiannan to improve that patch.
> That would be great. The work is stalled from what I can tell.

I absolutely hated that stuff because it wrecked the native code.
