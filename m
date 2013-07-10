Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3GJLY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:24:57 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:46116 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab3GJLYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:24:55 -0400
Message-ID: <51DD455D.4000701@linux.vnet.ibm.com>
Date: Wed, 10 Jul 2013 16:58:29 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Andrew Jones <drjones@redhat.com>,
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
References: <1372171802.3804.30.camel@oc2024037011.ibm.com> <51CAAA26.4090204@linux.vnet.ibm.com> <20130626113744.GA6300@hawk.usersys.redhat.com> <20130626125240.GY18508@redhat.com> <51CAEF45.3010203@linux.vnet.ibm.com> <20130626161130.GB18152@redhat.com> <51CB2AD9.5060508@linux.vnet.ibm.com> <51DBD3C2.2040807@linux.vnet.ibm.com> <20130710103325.GP24941@redhat.com> <20130710104047.GP25631@dyad.programming.kicks-ass.net> <20130710104717.GR24941@redhat.com>
In-Reply-To: <20130710104717.GR24941@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071011-2674-0000-0000-000009BF0873
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 04:17 PM, Gleb Natapov wrote:
> On Wed, Jul 10, 2013 at 12:40:47PM +0200, Peter Zijlstra wrote:
>> On Wed, Jul 10, 2013 at 01:33:25PM +0300, Gleb Natapov wrote:
>>
>> Here's an idea, trim the damn email ;-) -- not only directed at gleb.
>>
> Good idea.
>
>>>> Ingo, Gleb,
>>>>
>>>>  From the results perspective, Andrew Theurer, Vinod's test results are
>>>> pro-pvspinlock.
>>>> Could you please help me to know what will make it a mergeable
>>>> candidate?.
>>>>
>>> I need to spend more time reviewing it :) The problem with PV interfaces
>>> is that they are easy to add but hard to get rid of if better solution
>>> (HW or otherwise) appears.
>>
>> How so? Just make sure the registration for the PV interface is optional; that
>> is, allow it to fail. A guest that fails the PV setup will either have to try
>> another PV interface or fall back to 'native'.
>>
> We have to carry PV around for live migration purposes. PV interface
> cannot disappear under a running guest.
>

IIRC, The only requirement was running state of the vcpu to be retained.
This was addressed by
[PATCH RFC V10 13/18] kvm : Fold pv_unhalt flag into GET_MP_STATE ioctl 
to aid migration.

I would have to know more if I missed something here.

>>>> I agree that Jiannan's Preemptable Lock idea is promising and we could
>>>> evaluate that  approach, and make the best one get into kernel and also
>>>> will carry on discussion with Jiannan to improve that patch.
>>> That would be great. The work is stalled from what I can tell.
>>
>> I absolutely hated that stuff because it wrecked the native code.
> Yes, the idea was to hide it from native code behind PV hooks.
>

