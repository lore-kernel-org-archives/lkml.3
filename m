Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3GKAPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:15:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49002 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab3GKAPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:15:42 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130710151611.GY24941@redhat.com>
References: <20130626113744.GA6300@hawk.usersys.redhat.com> <20130626125240.GY18508@redhat.com> <51CAEF45.3010203@linux.vnet.ibm.com> <20130626161130.GB18152@redhat.com> <51CB2AD9.5060508@linux.vnet.ibm.com> <51DBD3C2.2040807@linux.vnet.ibm.com> <20130710103325.GP24941@redhat.com> <20130710104047.GP25631@dyad.programming.kicks-ass.net> <20130710104717.GR24941@redhat.com> <20130710150315.GE11007@phenom.dumpdata.com> <20130710151611.GY24941@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 10 Jul 2013 20:12:13 -0400
To: Gleb Natapov <gleb@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andrew Jones <drjones@redhat.com>, mingo@redhat.com,
        ouyang@cs.pitt.edu, habanero@linux.vnet.ibm.com, jeremy@goop.org,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, xen-devel@lists.xensource.com,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        andi@firstfloor.org, attilio.rao@citrix.com, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Message-ID: <5c137b3e-58fc-4e98-a048-e6ee023323d2@email.android.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov <gleb@redhat.com> wrote:
>On Wed, Jul 10, 2013 at 11:03:15AM -0400, Konrad Rzeszutek Wilk wrote:
>> On Wed, Jul 10, 2013 at 01:47:17PM +0300, Gleb Natapov wrote:
>> > On Wed, Jul 10, 2013 at 12:40:47PM +0200, Peter Zijlstra wrote:
>> > > On Wed, Jul 10, 2013 at 01:33:25PM +0300, Gleb Natapov wrote:
>> > > 
>> > > Here's an idea, trim the damn email ;-) -- not only directed at
>gleb.
>> > > 
>> > Good idea.
>> > 
>> > > > > Ingo, Gleb,
>> > > > > 
>> > > > > From the results perspective, Andrew Theurer, Vinod's test
>results are
>> > > > > pro-pvspinlock.
>> > > > > Could you please help me to know what will make it a
>mergeable
>> > > > > candidate?.
>> > > > > 
>> > > > I need to spend more time reviewing it :) The problem with PV
>interfaces
>> > > > is that they are easy to add but hard to get rid of if better
>solution
>> > > > (HW or otherwise) appears.
>> > > 
>> > > How so? Just make sure the registration for the PV interface is
>optional; that
>> > > is, allow it to fail. A guest that fails the PV setup will either
>have to try
>> > > another PV interface or fall back to 'native'.
>> > > 
>> > We have to carry PV around for live migration purposes. PV
>interface
>> > cannot disappear under a running guest.
>> 
>> Why can't it? This is the same as handling say XSAVE operations. Some
>hosts
>> might have it - some might not. It is the job of the toolstack to
>make sure
>> to not migrate to the hosts which don't have it. Or bound the guest
>to the
>> lowest interface (so don't enable the PV interface if the other hosts
>in the
>> cluster can't support this flag)?
>XSAVE is HW feature and it is not going disappear under you after
>software
>upgrade. Upgrading kernel on part of your hosts and no longer been
>able to migrate to them is not something people who use live migration
>expect. In practise it means that updating all hosts in a datacenter to
>newer kernel is no longer possible without rebooting VMs.
>
>--
>			Gleb.

I see. Perhaps then if the hardware becomes much better at this then another PV interface can be provided which will use the static_key to turn off the PV spin lock and use the bare metal version (or perhaps some forms of super ellision locks). That does mean the host has to do something when this PV interface is invoked for the older guests. 

Anyhow that said I think the benefits are pretty neat right now and benefit much and worrying about whether the hardware vendors will provide something new is not benefiting users. What perhaps then needs to be addressed is how to have an obsolete mechanism in this if the hardware becomes superb? 
-- 
Sent from my Android phone. Please excuse my brevity.
