Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaJAPUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:20:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbaJAPU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:20:26 -0400
Message-ID: <542C1B9A.4050704@zytor.com>
Date: Wed, 01 Oct 2014 08:19:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Sebastian Lackner <sebastian@fds-team.de>
CC: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
References: <cover.1412138935.git.luto@amacapital.net> <0e906bdeba3660c9766248d3d7229e78a423ca5b.1412138935.git.luto@amacapital.net> <542B8C7F.70108@fds-team.de> <CALCETrVNMhvn6z_5=+6UavkR1m8cABrkSWsLpP_dLdG_3OipBA@mail.gmail.com>
In-Reply-To: <CALCETrVNMhvn6z_5=+6UavkR1m8cABrkSWsLpP_dLdG_3OipBA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2014 10:24 PM, Andy Lutomirski wrote:
> On Tue, Sep 30, 2014 at 10:09 PM, Sebastian Lackner
> <sebastian@fds-team.de> wrote:
>>> +     testl $X86_EFLAGS_NT,EFLAGS(%rsp)       /* saved EFLAGS match cpu */
>>> +     jz 1f
>>> +     pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_FIXED)
>>> +     popfq_cfi
>>> +1:
>>> +
>>
>> Do you think it makes sense to change the order here, so that no jump happens if
>> NT is not set (which happens a bit more often, than the other way round)? Just a
>> guess though, haven't measured if pipeline effects have such a big influence in this
>> case. ;)
>>
> 
> It should be immeasurable in a tight loop, since it will predict
> correctly almost every time.  And, unless cfi state works across
> .pushsection (does it?), getting the cfi annotations right will be
> more complicated.
> 

It does, actually... otherwise it would be almost impossible to use in a
lot of cases.

	-hpa


