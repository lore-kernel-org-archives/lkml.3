Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaKKKwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:52:35 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbaKKKwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:52:33 -0500
Message-ID: <5461EA6B.9020305@nod.at>
Date: Tue, 11 Nov 2014 11:52:27 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, luto@amacapital.net
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-arch@vger.kernel.org,
        viro@zeniv.linux.org.uk, richard.weinberger@gmail.com, hpa@zytor.com,
        mingo@kernel.org, keescook@chromium.org
Subject: Re: [PATCH v2] all arches, signal: Move restart_block to struct task_struct
References: <43c88012a4959cd427ab634906e697fbc524e847.1414604015.git.luto@amacapital.net>	<alpine.DEB.2.11.1410291908290.5308@nanos>	<CALCETrWtBCFXzwCAh8fpeFv-EvPxYW20oRmFk1iCYwUvpft=Rw@mail.gmail.com> <20141110.211319.1983610686941713044.davem@davemloft.net>
In-Reply-To: <20141110.211319.1983610686941713044.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.11.2014 um 03:13 schrieb David Miller:
> From: Andy Lutomirski <luto@amacapital.net>
> Date: Mon, 10 Nov 2014 14:03:23 -0800
> 
>> On Wed, Oct 29, 2014 at 11:12 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>> On Wed, 29 Oct 2014, Andy Lutomirski wrote:
>>>
>>>> If an attacker can cause a controlled kernel stack overflow,
>>>> overwriting the restart block is a very juicy exploit target.
>>>> Moving the restart block to struct task_struct prevents this
>>>> exploit.
>>>>
>>>> Note that there are other fields in thread_info that are also easy
>>>> targets, at least on some architectures.
>>>>
>>>> It's also a decent simplification, since the restart code is more or
>>>> less identical on all architectures.
>>>
>>> I think that's the most important change. Moving common stuff into
>>> common code. The side effect of slightly reducing the attack surface
>>> is nice, but as Al pointed out not really the big win here.
>>
>> Having gotten exactly zero feedback from any arch maintainer outside
>> of x86, am I supposed to pester people further?
> 
> No objections wrt. sparc and if things break I'll help fix it.

Same for UML.
Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
