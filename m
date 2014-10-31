Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbaJaUP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:15:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51331 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758685AbaJaUPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:15:54 -0400
Message-ID: <5453EDCA.6040406@zytor.com>
Date: Fri, 31 Oct 2014 13:15:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Andi Kleen <ak@linux.intel.com>
CC: Randy Dunlap <rdunlap@infradead.org>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Junjie Mao <eternal.n08@gmail.com>
Subject: Re: [PATCH] x86, boot: add hex output for debugging
References: <20141031162037.GA26233@www.outflux.net> <5453C49A.2000500@infradead.org> <20141031174251.GM3274@tassilo.jf.intel.com> <20141031201156.GJ2851@redhat.com>
In-Reply-To: <20141031201156.GJ2851@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2014 01:11 PM, Vivek Goyal wrote:
> On Fri, Oct 31, 2014 at 10:42:51AM -0700, Andi Kleen wrote:
>>>> +void __puthex(unsigned long value)
>>>> +{
>>>> +	char alpha[2] = "0";
>>>> +	int bits;
>>>> +	unsigned char byte;
>>>
>>> what is 'byte' for?  (unused)
>>
>> Well the whole function is unused. We don't normally add unused functions
>> to the code because they bitrot too easily.
> 
> I think this is useful. I had to write similar code for printing out
> values during early boot.
> 
> May be we can print some values if CONFIG_X86_VERBOSE_BOOTUP=y.
> That way it will not be an unused code and others can reuse it easily
> to print additional data during debugging.
> 

The various addresses involved in decompression (load address, relocated
address, etc.) might be good ideas.

	-hpa


