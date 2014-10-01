Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaJAOSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:18:49 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43601 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaJAOSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:18:46 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-27-542c0d4432b0
Message-id: <542C0BA3.7000504@samsung.com>
Date: Wed, 01 Oct 2014 18:11:47 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.8.0
MIME-version: 1.0
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
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
 <542BE977.3040807@samsung.com>
 <CACT4Y+ZXcZ=BLGjXamfpV+5R-5pahKGTeMcRoLkcxY7PQGatjw@mail.gmail.com>
In-reply-to: <CACT4Y+ZXcZ=BLGjXamfpV+5R-5pahKGTeMcRoLkcxY7PQGatjw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRiA+c59q8lxTv0wKB2kodOU/PGlFRFBJyIQWhckyOWGF5zKTjMt
	CG8pmyKiabrUJFOaDVzLvKFFw1RISEoTvOHQjKnTvFTGatVxf/z3wPu87/PjZXCpmQhi0jJv
	aXSZqgw5JSbee4YnIs9KFMpoa+U+5B6oJ1FDh4VCg59/0mi9rRygyR+rAG065wHqnCzE0FeH
	g0aVjhIa1b4IROayIgp1L7kwZDbMk+hTXwOF5ix/STT8qhNHLYPTOFpbqsbRRPtbGu1YF8jT
	Ms7SZAHc494NwPWaZmmu2abnWvqdGGdrN1CcbbOK5oyucYwbqXMT3OL4Q4zb+DJFcOuvJyhu
	y3aQGyneJhN8EsUn1JqMtByN7uipJHGqs2Yby3aIc4cbu4h8MMMYgYiBbCx852zDvBwAx+Y6
	KIGlbCuAZdVHjED8n4swOLPkJIyAYSRsOCz4dVtwCPYwLH5uJwSm2CjoMXXv7vqz1+CDN62k
	wBLWF+5Uz+06MjYUFqyUU8JNnF0jYV3vfVwY+LFKWGGuIbyxLgJ2PNrBhZiIvQSHGhSCg7Nh
	sKrpCe7lQ/ClxYVXAta0p2Hao5n2aM0Abwf+Gn1yNn8zRRsTxau0vD4zJSo5S2sD3vdu94CW
	oTg7YBkg3y8JTopQSklVDp+ntQPI4HKZhBYplFKJWpV3R6PLuqHTZ2h4O8AYUVA+aN7Kky1M
	/U4s+9Z38qmhBx/wiV9ThDj8noWlKHwN/L2I2O4DqVj0ZQ8bemH1TE5SLTrn0h1Pb/n4odjd
	eGXUqi4dKB3zBLiXEyNDNg4HB6bXu1fpu9LkXP2IMiRO/d02e2waXV0+PxoXP/9HVSHpS1+x
	+iyWjLLXLxam9SeMywk+VRUTjut41T8F3XtXvAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 05:27 PM, Dmitry Vyukov wrote:
> On Wed, Oct 1, 2014 at 3:45 PM, Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
>> On 10/01/2014 02:39 PM, Catalin Marinas wrote:
>>> On Mon, Sep 29, 2014 at 03:10:01PM +0100, Dmitry Vyukov wrote:
>>>> On Fri, Sep 26, 2014 at 9:36 PM, Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:
>>>>> 2014-09-26 21:10 GMT+04:00 Dmitry Vyukov <dvyukov@google.com>:
>>>>>> Looks good to me.
>>>>>>
>>>>>> We can disable kasan instrumentation of this file as well.
>>>>>
>>>>> Yes, but why? I don't think we need that.
>>>>
>>>> Just gut feeling. Such tools usually don't play well together. For
>>>> example, due to asan quarantine lots of leaks will be missed (if we
>>>> pretend that tools work together, end users will use them together and
>>>> miss bugs). I won't be surprised if leak detector touches freed
>>>> objects under some circumstances as well.
>>>> We can do this if/when discover actual compatibility issues, of course.
>>>
>>> I think it's worth testing them together first.
>>>
>>
>> I did test them together. With this patch applied both tools works without problems.
> 
> What do you mean "works without problems"? Are you sure that kmemleak
> still detects all leaks it is intended to detect?
> 

Yes I'm sure about that. And how kasan could affect on kmemleak's capability to detect leaks?

