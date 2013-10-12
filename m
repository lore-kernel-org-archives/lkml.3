Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3JLCKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 22:10:53 -0400
Received: from intranet.asianux.com ([58.214.24.6]:26638 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3JLCKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 22:10:51 -0400
X-Spam-Score: -100.8
Message-ID: <5258AF6E.9010708@asianux.com>
Date: Sat, 12 Oct 2013 10:09:50 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Will Deacon <will.deacon@arm.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm/arm64: remove atomic_clear_mask() in "include/asm/atomic.h"
References: <5256121A.9030504@asianux.com> <52561269.60900@asianux.com> <20131010100733.GH3817@mudshark.cambridge.arm.com> <52568998.2080108@asianux.com> <20131010142305.GG6199@mudshark.cambridge.arm.com> <525751E2.3020207@asianux.com> <20131011104419.GE14732@mudshark.cambridge.arm.com> <5257E033.3090607@asianux.com> <5257E539.9080902@asianux.com> <CAFLxGvwsx2YfNHiGtjWsANfVW74PT3KneLA-T6SpY4NEp_OSUA@mail.gmail.com> <20131011122846.GK14732@mudshark.cambridge.arm.com> <5257F710.5090706@nod.at> <5258A7AC.4060902@asianux.com>
In-Reply-To: <5258A7AC.4060902@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2013 09:36 AM, Chen Gang wrote:
> On 10/11/2013 09:03 PM, Richard Weinberger wrote:
>> Am 11.10.2013 14:28, schrieb Will Deacon:
>>> On Fri, Oct 11, 2013 at 01:08:17PM +0100, Richard Weinberger wrote:
>>>> On Fri, Oct 11, 2013 at 1:47 PM, Chen Gang <gang.chen@asianux.com> wrote:
>>>>> In current kernel wide source code, except other architectures, only
>>>>> s390 scsi drivers use atomic_clear_mask(), and arm/arm64 need not
>>>>> support s390 drivers.
>>>>>
>>>>> So remove atomic_clear_mask() from "arm[64]/include/asm/atomic.h".
>>>>
>>>> Is it really worth removing such a primitive?
>>>> If someone needs it later he has to implement it from scratch and
>>>> introduces bugs...
>>>
>>> The version we have (on ARM64 anyway) already has bugs. Given the choice
>>> between fixing code that has no callers and simply removing it, I'd go for
>>> the latter.
>>
>> Yeah, if it's broken and has no real users, send it to hell. :)
>>
> 
> OK, thanks.
> 
> 
> Hmm... at least, the original API definition is not well enough: "need
> use 'unsigned int' and 'atomic_t' instead of 'unsigned long' for the
> type of parameters".
> 
> But can we say "under arm64, it must be a bug"? (although I agree it is
> very easy to let callers miss using it -- then may cause issue).
> 
> In my opinion, it belongs to "API definition issue" not implementation
> bug: "if all callers are carefully enough, it will not make issues"
> (e.g. in "./kernel" sub-system, we can meet many such kinds of things).
> 

For "./kernel" sub-system, it really it is, if necessary, I can provide
3 samples.  ;-)

> 
> 
> Thanks.
> 
>> Thanks,
>> //richard
>>
>>
>>
> 


-- 
Chen Gang
