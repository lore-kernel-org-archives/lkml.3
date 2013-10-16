Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab3JPPDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:03:07 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:48259 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab3JPPDG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 16 Oct 2013 11:03:06 -0400
Message-Id: <525EC6C402000078000FB895@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 16 Oct 2013 16:03:00 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux@roeck-us.net>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: unify copy_from_user() checking
References: <525E964402000078000FB70C@nat28.tlf.novell.com>
 <525E9BF7.7020706@linux.intel.com>
In-Reply-To: <525E9BF7.7020706@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.10.13 at 16:00, Arjan van de Ven <arjan@linux.intel.com> wrote:
>> +static inline unsigned long __must_check copy_from_user(void *to,
>> +					  const void __user *from,
>> +					  unsigned long n)
>> +{
>> +	int sz = __compiletime_object_size(to);
>> +
>> +	might_fault();
>> +	if (likely(sz == -1 || sz >= n))
>> +		n = _copy_from_user(to, from, n);
>> +	else if(__builtin_constant_p(n))
>> +		copy_from_user_overflow();
> 
> 
> this part I am not so sure about.
> the original intent was that even if n is not constant, the compiler must 
> still be able
> to prove that it is smaller than sz using the range tracking feature in gcc!

I had pointed out cases in the patch description where I was getting
a warning when I think I shouldn't, and since I pay attention to
warnings this keeps me going back to the sources whenever I didn't
look at the reason long enough and forgot whether it's safe to ignore
these warnings. Warnings are nice and useful, but especially when
they sound dangerous having false positives isn't helpful at all.

> In fact, that was the whole point.
> The code (at the time, they're all fixed) found cases where the checks done 
> to "n" were off by one
> etc...
> 
> by requiring "n" to be constant for these checks you remove that layer of 
> checking.
> 
> if you have found cases where this matters... maybe you found a new security 
> issue...

Iirc I could convince myself that in the cited cases the warnings
were there for no reason.

Jan

