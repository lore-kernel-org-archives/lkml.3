Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbaKULHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:07:16 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60238 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaKULHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:07:13 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-7b-546f1cd7c1ba
Message-id: <546F1CD1.3060600@samsung.com>
Date: Fri, 21 Nov 2014 14:06:57 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v6 00/11] Kernel address sanitizer - runtime memory
 debugger.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
 <5461B906.1040803@samsung.com>
 <20141118125843.434c216540def495d50f3a45@linux-foundation.org>
 <CAPAsAGwZtfzx5oM73bOi_kw5BqXrwGd_xmt=m6xxU6uECA+H9Q@mail.gmail.com>
 <20141120090356.GA6690@gmail.com>
 <CACT4Y+aOKzq0AzvSJrRC-iU9LmmtLzxY=pxzu8f4oT-OZk=oLA@mail.gmail.com>
 <20141120150033.4cd1ca25be4a9b00a7074149@linux-foundation.org>
In-reply-to: <20141120150033.4cd1ca25be4a9b00a7074149@linux-foundation.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0iTYRjHeb/jXA4+56EXk4SRRILzQBcvYuKFxAd2EehF5YVNHWo5lc2Z
	GpFkaGqpJDZdA0dTaNNYTkUNFTNt5szMw2dHdTmPOU2zkqTVDhd59+P5n24eHi7cIAJ5WTn5
	UnmOJFtE8QmLw8yFzQXlJkXU7IrRQX8jiTTGNgoNc79oNPdzEyDbYDlAu+uLAHXO3cLQqtVK
	o1prGY0etB9F+qpSCj1cWCJQ94odQ/qKRRJNP9NQaL7tL4laHWMATQ1qMXR7YBJDZd8dJDLf
	G8SQ/ZOKQGXN7Rgyd3XiSDf8EUdbK3U46jDV4+hLtZ1Gs4bnNHrzx0yi/adLZFww29S7A9he
	9Wea1ZqUbMfjUFbXt46xJkMFxZp279NspX0GY7cmJmh2tOGAYG0zKozVVdeR7M7yB4LdM3A4
	uz0wS7Hj2mH6vO8lfky6NDurQCoPj73Mz9xoraHz+viF45YxrASs0pXAiweZ0/D18B7wcACc
	nDdSLhYyLQDqvxGVgO/kUgz2GLvcgoAJhbXmadzFBBMCO/QWN1OMGDrU3W6PP3MBzrRpgMfv
	A/fr5gkX+zGJ0NZZSrtKcYbjwX0r5w77OoVRvYbyrHE4ND9ZdCe8mAS4vDPlbOI5E2K48DbU
	dcaZYNjRZsdrAaM+tKH+71IfcmkBbgD+UmVaniI1QxYlVkhkCmVOhjgtV2YCnv/40QNaXkYP
	AYYHRN6CSbUsSUhKChRFsiEAebjIT3DNNzdJKEiXFBVL5bkpcmW2VDEEMJ5XYAm4uXxjpL/c
	lhJui8uf0jXEtIb83u7y/RphGOd86gWWZEuarsvaqG+eHlGeiQy7c7wxYvTqrEy5dveUPna8
	1RD0XpiacSQhotoYXXxu6diGf9PmIx+p5uS7E/F7opV67uKVmLNre4XkqwDqhSq5yjuuJfW6
	ODrRZiMzpFz8vCpKRCgyJZGhuFwh+QdmqYGY/QIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2014 02:00 AM, Andrew Morton wrote:
> On Thu, 20 Nov 2014 20:32:30 +0400 Dmitry Vyukov <dvyukov@google.com> wrote:
> 
>> Let me provide some background first.
> 
> Well that was useful.  Andrey, please slurp Dmitry's info into the 0/n
> changelog?
> 

Sure.

> Also, some quantitative info about the kmemleak overhead would be
> useful.
> 

Confused. Perhaps you mean kmemcheck?

I did some brief performance testing:

$ netperf -l 30

		MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to localhost (127.0.0.1) port 0 AF_INET
		Recv   Send    Send
		Socket Socket  Message  Elapsed
		Size   Size    Size     Time     Throughput
		bytes  bytes   bytes    secs.    10^6bits/sec

no debug:	87380  16384  16384    30.00    41624.72

kasan inline:	87380  16384  16384    30.00    12870.54

kasan outline:	87380  16384  16384    30.00    10586.39

kmemcheck: 	87380  16384  16384    30.03      20.23


So on this workload kasan x500-x600 times faster then kmemcheck.


> In this discussion you've mentioned a few planned kasan enhancements. 
> Please also list those and attempt to describe the amount of effort and
> complexity levels.  Partly so other can understand the plans and partly
> so we can see what we're semi-committing ourselves to if we merge this
> stuff.
> 

