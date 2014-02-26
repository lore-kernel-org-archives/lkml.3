Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaBZJ3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:29:44 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:48067 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaBZJ3m convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 26 Feb 2014 04:29:42 -0500
Message-Id: <530DC21F020000780011F67D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 26 Feb 2014 09:29:51 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <davem@davemloft.net>, <mingo@elte.hu>, <tglx@linutronix.de>,
        "Daniel Borkmann" <dborkman@redhat.com>, <ffusco@redhat.com>,
        <tgraf@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86/hash: swap parameters of crc32_u32()
References: <53073986020000780011E2E1@nat28.tlf.novell.com>
 <530CFC93.8080505@zytor.com> <530CFE3A.2090403@redhat.com>
 <530CFF25.1080100@zytor.com>
In-Reply-To: <530CFF25.1080100@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.02.14 at 21:37, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 02/25/2014 12:34 PM, Daniel Borkmann wrote:
>> On 02/25/2014 09:26 PM, H. Peter Anvin wrote:
>>> On 02/21/2014 02:33 AM, Jan Beulich wrote:
>>>> ... to match its two callers (i.e. the alternative would have been to
>>>> swap the arguments at the call sites).
>>>>
>>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>>> Cc: Francesco Fusco <ffusco@redhat.com>
>>>> Cc: Daniel Borkmann <dborkman@redhat.com>
>>>> Cc: Thomas Graf <tgraf@redhat.com>
>>>> Cc: David S. Miller <davem@davemloft.net>
>>>> ---
>>>>   arch/x86/lib/hash.c |    2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> Jan, do you want to do an updated version of this patch?  Daniel, I
>>> presume you are going to push this patch?
>> 
>> Good point. I'm fine if this is going to be picked up
>> by x86 maintainers. Feel free to add my ...
>> 
>> Acked-by: Daniel Borkmann <dborkman@redhat.com>
>> 
>> ... if you want to do an updated version that also
>> includes our recent findings/discussion, Jan.
>> 
> 
> Well, I don't want to change the names of the arguments in the inline
> function unless we also change the their functions and actually reverse
> the order of the operands as used.

So I'm confused now: Whether we change the function's
parameters or the callers' argument order has the same net effect:
It's either (with the current patch)

static inline u32 crc32_u32(u32 val, u32 crc)
		seed = crc32_u32(*p32++, seed);
		seed = crc32_u32(tmp, seed);
		seed = crc32_u32(*p32++, seed);

or it would be (with parameter order kept and argument order
swapped)

static inline u32 crc32_u32(u32 crc, u32 val)
		seed = crc32_u32(seed, *p32++);
		seed = crc32_u32(seed, tmp);
		seed = crc32_u32(seed, *p32++);

I.e. it is precisely the case that their names and functions disagree
in the current (unpatched) version.

Jan

