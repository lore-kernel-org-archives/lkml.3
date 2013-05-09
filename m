Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab3EIFpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:45:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47782 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab3EIFpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:45:12 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <201305090113.19684.vapier@gentoo.org>
References: <1368072057-7832-1-git-send-email-vapier@gentoo.org> <201305090008.47432.vapier@gentoo.org> <518B2387.9030408@zytor.com> <201305090113.19684.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86: make stat/statfs 64-bit for x86_64 kernels
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 08 May 2013 22:44:48 -0700
To: Mike Frysinger <vapier@gentoo.org>
CC: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <c63a3480-11e7-4966-ae11-628ef8f1eca5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm... Okay, I'm mistaken then.  I guess it doesn't matter.

Mike Frysinger <vapier@gentoo.org> wrote:

>On Thursday 09 May 2013 00:18:15 H. Peter Anvin wrote:
>> On 05/08/2013 09:08 PM, Mike Frysinger wrote:
>> > On Thursday 09 May 2013 00:04:03 H. Peter Anvin wrote:
>> >> On 05/08/2013 09:00 PM, Mike Frysinger wrote:
>> >>> When including these headers in the x32 ABI, the structs get
>> >>> declared with 32bit sizes which is incorrect.  Use long long
>> >>> and such to make it work both with x32 and x86_64.
>> >> 
>> >> I'm not sure if it is okay to change the types, even within the
>> >> same size.  Perhaps use __u64/__s64?
>> > 
>> > sorry, i don't follow.  changing types isn't ok (unsigned long to
>> > unsigned long long), but changing to __u64 is ok (unsigned long to
>> > __u64 which is typedefed to unsigned long long) ?
>> > 
>> > i don't have a problem using __u64/__s64, i just don't understand
>> > your logic.
>> 
>> In userspace, __u64 is often defined as "unsigned long" on 64 bits.
>
>my tests would seem to indicate otherwise, at least for x86:
>$ gcc -E - <<<"#include <linux/types.h>" | grep '__u64;'
>__extension__ typedef unsigned long long __u64;
>
>$ gcc -m32 -E - <<<"#include <linux/types.h>" | grep '__u64;'
>__extension__ typedef unsigned long long __u64;
>
>$ gcc -mx32 -E - <<<"#include <linux/types.h>" | grep '__u64;'
>__extension__ typedef unsigned long long __u64;
>
>and doing a printf("%i\n", sizeof(__u64)) shows 8 for each of the above
>builds
>-mike

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
