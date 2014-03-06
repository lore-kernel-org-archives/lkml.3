Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaCFQN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:13:56 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47081 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaCFQNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:13:55 -0500
Message-ID: <53189E7A.2070902@oracle.com>
Date: Thu, 06 Mar 2014 09:12:42 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Lang <david@lang.hm>, Kevin Easton <kevin@guarana.org>
CC: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        peterz@infradead.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, oleg@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <8738ix5uyk.fsf@tassilo.jf.intel.com> <20140306121333.GA12127@chicago.guarana.org> <alpine.DEB.2.02.1403060624150.32171@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1403060624150.32171@nftneq.ynat.uz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 07:25 AM, David Lang wrote:
> On Thu, 6 Mar 2014, Kevin Easton wrote:
>
>> On Tue, Mar 04, 2014 at 04:51:15PM -0800, Andi Kleen wrote:
>>> Anything else?
>>
>> If it was possible to make the time remaining in the current timeslice
>> available to userspace through the vdso, the thread could do something
>> like:
>>
>> if (sys_timeleft() < CRITICAL_SECTION_SIZE)
>>    yield();
>> lock();
>>
>> to avoid running out of timeslice in the middle of the critical section.
>
> but won't the system call result in context switches? According to
> Kevin, even a context switch to another thread and back immediatly is
> bad enough to need to be avoided, so replacing that with the context
> switch to the kernel and back isn't a subtantial win.
>
> David Lang

Using vdso reduces the cost of system call significantly, but as Peter 
pointed out a thread can not really rely upon the number it will get back.

--
Khalid
