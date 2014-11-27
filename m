Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaK0Oc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:32:58 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:41940 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaK0Ocz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:32:55 -0500
Message-ID: <547736EB.2090006@gmail.com>
Date: Thu, 27 Nov 2014 15:36:27 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>, "'Joe Perches'" <joe@perches.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: bpf_jit_comp: simplify trivial boolean return
References: <CAADnVQK3iui8cAmhi28=65p2CJbTu45fR98ri8Uh8xLRb=cwnA@mail.gmail.com> <1417032059.16355.4.camel@perches.com> <063D6719AE5E284EB5DD2968C1650D6D1C9FDA63@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1C9FDA63@AcuExch.aculab.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/11/2014 13:25, David Laight wrote:
> From: Joe Perches
>> On Wed, 2014-11-26 at 10:34 -0800, Alexei Starovoitov wrote:
>>> On Wed, Nov 26, 2014 at 10:02 AM, Joe Perches <joe@perches.com> wrote:
>>>> On Wed, 2014-11-26 at 09:23 -0800, Alexei Starovoitov wrote:
>>>>> On Wed, Nov 26, 2014 at 8:58 AM, Joe Perches <joe@perches.com> wrote:
>>>>>> Is there any value in reordering these tests for frequency
>>>>>> or maybe using | instead of || to avoid multiple jumps?
>>>>> probably not. It's not a critical path.
>>>>> compiler may fuse conditions depending on values anyway.
>>>>> If it was a critical path, we could have used
>>>>> (1 << reg) & mask trick.
>>>>> I picked explicit 'return true' else 'return false' here,
>>>>> because it felt easier to read. Just a matter of taste.
>>>> There is a size difference though: (allyesconfig)
>>>>
>>>> $ size arch/x86/net/built-in.o*
>>>>     text    data     bss     dec     hex filename
>>>>    12999    1012    4336   18347    47ab arch/x86/net/built-in.o.new
>>>>    13177    1076    4592   18845    499d arch/x86/net/built-in.o.old
>>> interesting. Compiler obviously thinks that 178 byte increase
>>> with -O2 is the right trade off. Which I agree with :)
>>>
>>> If I think dropping 'inline' and using -Os will give bigger savings...
>> This was allyesconfig which already uses -Os
>>
>> Using -O2, there is no difference using inline
>> or not, but the size delta with the bitmask is
>> much larger
>>
>> $ size arch/x86/net/built-in.o* (allyesconfig, but not -Os)
>>     text	   data	    bss	    dec	    hex	filename
>>    13410	    820	   3624	  17854	   45be	arch/x86/net/built-in.o.new
>>    16130	    884	   4200	  21214	   52de	arch/x86/net/built-in.o.old
>>    16130	    884	   4200	  21214	   52de	arch/x86/net/built-in.o.static
> That is quite a big % change in the code size.
> Why the change in data?
>
> 	David
>
>
>
Do you want me to propose a second version, or should I just
drop it all together ?

I am a new contributor so I have no experience in that sort of thing.

Quentin
