Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155AbaJALxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:53:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53366 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaJALw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:52:58 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-48-542beb181e4e
Message-id: <542BE977.3040807@samsung.com>
Date: Wed, 01 Oct 2014 15:45:59 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.8.0
MIME-version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v3 11/13] kmemleak: disable kasan instrumentation for
 kmemleak
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-12-git-send-email-a.ryabinin@samsung.com>
 <CACT4Y+aJ9htaruQ1Nn7+MSGwtNzRb_hfytQo98J1wq5N6oh1BA@mail.gmail.com>
 <CAPAsAGxLxCxOayqcu=PbgFG6J7JEuL8J3+ouz94p_k0v0Hy=wA@mail.gmail.com>
 <CACT4Y+Z4N5hpz_ZXFOCCbv7sbz2kzrF6gYHMbasDFNwpdOK30Q@mail.gmail.com>
 <20141001103930.GG20364@e104818-lin.cambridge.arm.com>
In-reply-to: <20141001103930.GG20364@e104818-lin.cambridge.arm.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t/xq7oSr7VDDB4fYbb4vXcmq8Wc9WvY
	LI5c+85u8X5ZD6PF9W9vGC0+vXzAaLHlehOTxfOHD9ktJjxsY7eYtlHcYmV3M5vF9mdvmSxW
	dj5gtbi8aw6bxb01/1ktjm/dwmyx+MhtZot3zyYzW1xddZDd4seGx6wOIh5r5q1h9Ji/8yOj
	x85Zd9k9Fmwq9Vi85yWTx6ZVnWwemz5NYvfoenuFyePEjN8sHk+uTGfy+Pj0FovH+31X2Tw+
	b5LzONHyhTWAL4rLJiU1J7MstUjfLoEr48PZ42wF/TwVS7Y8YWlgvMnZxcjJISFgInHv50Fm
	CFtM4sK99WxdjFwcQgJLGSX+NVxjA0kICTQzSUza5wpi8wpoSXSumsYKYrMIqEq865oC1swm
	oCfxb9Z2sHpRgQiJKfuXskLUC0r8mHyPBcQWEQiWWProFyPIAmaBg6wSH69sYwdJCAuESPSt
	nMoCsfkcs8T74xcYQRKcAs4Sm94dBJvKLKAjsb91GpQtL7F5zVvmCYwCs5AsmYWkbBaSsgWM
	zKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQiL46w7GpcesDjEKcDAq8fBqpGuHCLEmlhVX
	5h5ilOBgVhLh7XkJFOJNSaysSi3Kjy8qzUktPsTIxMEp1cDYbVFS/Fr0sEKUsUbqywfCzzfs
	910p98Mwo+LdpG3XrlzM1OF3v5oUevD5Z7HbxtnHT6552raYceFT3XenJquUrzKqztAym5vS
	nt9qu4DDfAe/iNafK5XxcTv93edsDPgYOM/y7tGq97oXWr1invYfbv7r4HqpIGTNYl6Wd8du
	nzZQmmLlwJ+sxFKckWioxVxUnAgABhh0o74CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 02:39 PM, Catalin Marinas wrote:
> On Mon, Sep 29, 2014 at 03:10:01PM +0100, Dmitry Vyukov wrote:
>> On Fri, Sep 26, 2014 at 9:36 PM, Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:
>>> 2014-09-26 21:10 GMT+04:00 Dmitry Vyukov <dvyukov@google.com>:
>>>> Looks good to me.
>>>>
>>>> We can disable kasan instrumentation of this file as well.
>>>
>>> Yes, but why? I don't think we need that.
>>
>> Just gut feeling. Such tools usually don't play well together. For
>> example, due to asan quarantine lots of leaks will be missed (if we
>> pretend that tools work together, end users will use them together and
>> miss bugs). I won't be surprised if leak detector touches freed
>> objects under some circumstances as well.
>> We can do this if/when discover actual compatibility issues, of course.
> 
> I think it's worth testing them together first.
> 

I did test them together. With this patch applied both tools works without problems.


> One issue, as mentioned in the patch log, is that the size information
> that kmemleak gets is the one from the kmem_cache object rather than the
> original allocation size, so this would be rounded up.
> 
> Kmemleak should not touch freed objects (if an object is freed during a
> scan, it is protected by some lock until the scan completes). There is a
> bug however which I haven't got to fixing it yet, if kmemleak fails for
> some reason (cannot allocate memory) and disables itself, it may access
> some freed object (though usually hard to trigger).
> 

