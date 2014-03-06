Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbaCFAD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:03:58 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44576 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857AbaCFAD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:03:56 -0500
Message-ID: <5317BB2A.8000703@oracle.com>
Date: Wed, 05 Mar 2014 17:02:50 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, David Lang <david@lang.hm>
CC: Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@kernel.org>, peterz@infradead.org,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de> <8738ix5uyk.fsf@tassilo.jf.intel.com> <20140305145420.GA30173@redhat.com> <20140305155601.GF22728@two.firstfloor.org> <20140305163644.GA2824@redhat.com> <53175D54.1020804@oracle.com> <alpine.DEB.2.02.1403051506550.6682@nftneq.ynat.uz> <5317B7D5.2030403@oracle.com> <5317B9B2.8070205@zytor.com>
In-Reply-To: <5317B9B2.8070205@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 04:56 PM, H. Peter Anvin wrote:
> On 03/05/2014 03:48 PM, Khalid Aziz wrote:
>>
>> Cost is writing to a memory location since thread is using mmap, not
>> insignificant but hardly expensive. Thread does not need to know how
>> much time it has left in current timeslice. It always sets the flag to
>> request pre-emption immunity before entering the critical section and
>> clears the flag when it exits its critical section. If the thread comes
>> up for pre-emption while the flag is set, it gets immunity. If it does
>> not, flag will be cleared at the end of critical section any way.
>>
>
> A little more than that.  The scheduler needs to set *another* flag
> telling the process to yield upon leaving the critical section; if the
> process doesn't, the scheduler needs to keep enough accounting to know
> to penalize the process, or this method will not be usable for
> unprivileged processes.

Yes, you had made that suggestion earlier and I like it. It will be in 
v2 patch. I am thinking of making the penalty be denial of next 
preemption immunity request if a process fails to yield when it should 
have. Sounds good?

Thanks,
Khalid
