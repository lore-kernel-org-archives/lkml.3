Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3HFC0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 22:26:18 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:50829 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382Ab3HFC0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 22:26:17 -0400
Message-ID: <52005EB8.7050907@akamai.com>
Date: Mon, 05 Aug 2013 22:26:00 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Richard Henderson <rth@twiddle.net>, Marek Polacek <polacek@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
References: <1375721715.22073.80.camel@gandalf.local.home> <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com> <1375725328.22073.101.camel@gandalf.local.home> <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com> <CA+55aFw=OX3Zz_PJc7NUGwFLAE1RYUsPe9Dn8qHDN0nZeW2R5A@mail.gmail.com> <CA+55aFyzmGzv3C9gy5Xi=pSmAOzpYMNAqrrrZmsvNbt4LdrorQ@mail.gmail.com> <20130805194009.GZ17022@redhat.com> <520003B8.8090503@akamai.com> <52000C76.3060601@twiddle.net>
In-Reply-To: <52000C76.3060601@twiddle.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 04:35 PM, Richard Henderson wrote:
> On 08/05/2013 09:57 AM, Jason Baron wrote:
>> On 08/05/2013 03:40 PM, Marek Polacek wrote:
>>> On Mon, Aug 05, 2013 at 11:34:55AM -0700, Linus Torvalds wrote:
>>>> On Mon, Aug 5, 2013 at 11:24 AM, Linus Torvalds
>>>> <torvalds@linux-foundation.org> wrote:
>>>>> Ugh. I can see the attraction of your section thing for that case, I
>>>>> just get the feeling that we should be able to do better somehow.
>>>> Hmm.. Quite frankly, Steven, for your use case I think you actually
>>>> want the C goto *labels* associated with a section. Which sounds like
>>>> it might be a cleaner syntax than making it about the basic block
>>>> anyway.
>>> FWIW, we also support hot/cold attributes for labels, thus e.g.
>>>
>>>     if (bar ())
>>>       goto A;
>>>     /* ... */
>>> A: __attribute__((cold))
>>>     /* ... */
>>>
>>> I don't know whether that might be useful for what you want or not though...
>>>
>>>      Marek
>>>
>> It certainly would be.
>>
>> That was how I wanted to the 'static_key' stuff to work, but unfortunately the
>> last time I tried it, it didn't move the text out-of-line any further than it
>> was already doing. Would that be expected? The change for us, if it worked
>> would be quite simple. Something like:
> It is expected.  One must use -freorder-blocks-and-partition, and use real
> profile feedback to get blocks moved completely out-of-line.
>
> Whether that's a sensible default or not is debatable.
>

Hi Steve,

I think if the 'cold' attribute on the default disabled static_key 
branch moved the text completely out-of-line, it would satisfy your 
requirement here?

If you like this approach, perhaps we can make something like this work 
within gcc. As its already supported, but doesn't quite go far enough 
for our purposes.

Also, if we go down this path, it means the 2-byte jump sequence is 
probably not going to be too useful.

Thanks,

-Jason




