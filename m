Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3DVXOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 19:14:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab3DVXOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 19:14:08 -0400
Message-ID: <5175C42C.1030901@redhat.com>
Date: Mon, 22 Apr 2013 19:13:48 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jiannan Ouyang <ouyang@cs.pitt.edu>, LKML <linux-kernel@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Karen Noel <knoel@redhat.com>
Subject: Re: Preemptable Ticket Spinlock
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com> <51745650.9050204@redhat.com> <m2k3nuw7oj.fsf@firstfloor.org>
In-Reply-To: <m2k3nuw7oj.fsf@firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 05:56 PM, Andi Kleen wrote:
> Rik van Riel <riel@redhat.com> writes:
>>
>> If we always incremented the ticket number by 2 (instead of 1), then
>> we could use the lower bit of the ticket number as the spinlock.
>
> Spinning on a single bit is very inefficient, as you need to do
> try lock in a loop which is very unfriendly to the MESI state protocol.
> It's much better to have at least three states and allow
> spinning-while-reading-only.
>
> This is typically very visible on systems with >2S.

Absolutely, the spinning should be read-only, until the CPU
sees that the desired bit is clear.  MESI-friendly spinning
is essential.

-- 
All rights reversed
