Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab3GKKuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:50:35 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:48215 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab3GKKud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:50:33 -0400
Message-ID: <51DE8EC6.6020700@linux.vnet.ibm.com>
Date: Thu, 11 Jul 2013 16:23:58 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Andrew Jones <drjones@redhat.com>, mingo@redhat.com, ouyang@cs.pitt.edu,
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
References: <20130626113744.GA6300@hawk.usersys.redhat.com> <20130626125240.GY18508@redhat.com> <51CAEF45.3010203@linux.vnet.ibm.com> <20130626161130.GB18152@redhat.com> <51CB2AD9.5060508@linux.vnet.ibm.com> <51DBD3C2.2040807@linux.vnet.ibm.com> <20130710103325.GP24941@redhat.com> <51DE771F.7070805@linux.vnet.ibm.com> <20130711094833.GC8575@redhat.com> <51DE849E.4020405@linux.vnet.ibm.com> <20130711101104.GF8575@redhat.com>
In-Reply-To: <20130711101104.GF8575@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071110-0260-0000-0000-0000034BB645
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 03:41 PM, Gleb Natapov wrote:
> On Thu, Jul 11, 2013 at 03:40:38PM +0530, Raghavendra K T wrote:
>>>>>> Gleb,
>>>>>> Can you elaborate little more on what you have in mind regarding per
>>>>>> VM ple_window. (maintaining part of it as a per vm variable is clear
>>>>>> to
>>>>>>   me), but is it that we have to load that every time of guest entry?
>>>>>>
>>>>> Only when it changes, shouldn't be to often no?
>>>>
>>>> Ok. Thinking how to do. read the register and writeback if there need
>>>> to be a change during guest entry?
>>>>
>>> Why not do it like in the patch you've linked? When value changes write it
>>> to VMCS of the current vcpu.
>>>
>>
>> Yes. can be done. So the running vcpu's ple_window gets updated only
>> after next pl-exit. right?
> I am not sure what you mean. You cannot change vcpu's ple_window while
> vcpu is in a guest mode.
>

I agree with that. Both of us are on the same page.
  What I meant is,
suppose the per VM ple_window changes when a vcpu x of that VM  was running,
it will get its ple_window updated during next run.

