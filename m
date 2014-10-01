Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaJAN1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:27:40 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:57157 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaJAN1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:27:39 -0400
MIME-Version: 1.0
In-Reply-To: <542BE977.3040807@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-12-git-send-email-a.ryabinin@samsung.com>
 <CACT4Y+aJ9htaruQ1Nn7+MSGwtNzRb_hfytQo98J1wq5N6oh1BA@mail.gmail.com>
 <CAPAsAGxLxCxOayqcu=PbgFG6J7JEuL8J3+ouz94p_k0v0Hy=wA@mail.gmail.com>
 <CACT4Y+Z4N5hpz_ZXFOCCbv7sbz2kzrF6gYHMbasDFNwpdOK30Q@mail.gmail.com>
 <20141001103930.GG20364@e104818-lin.cambridge.arm.com> <542BE977.3040807@samsung.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 1 Oct 2014 17:27:11 +0400
Message-ID: <CACT4Y+ZXcZ=BLGjXamfpV+5R-5pahKGTeMcRoLkcxY7PQGatjw@mail.gmail.com>
Subject: Re: [PATCH v3 11/13] kmemleak: disable kasan instrumentation for kmemleak
To: Andrey Ryabinin <a.ryabinin@samsung.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 3:45 PM, Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
> On 10/01/2014 02:39 PM, Catalin Marinas wrote:
>> On Mon, Sep 29, 2014 at 03:10:01PM +0100, Dmitry Vyukov wrote:
>>> On Fri, Sep 26, 2014 at 9:36 PM, Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:
>>>> 2014-09-26 21:10 GMT+04:00 Dmitry Vyukov <dvyukov@google.com>:
>>>>> Looks good to me.
>>>>>
>>>>> We can disable kasan instrumentation of this file as well.
>>>>
>>>> Yes, but why? I don't think we need that.
>>>
>>> Just gut feeling. Such tools usually don't play well together. For
>>> example, due to asan quarantine lots of leaks will be missed (if we
>>> pretend that tools work together, end users will use them together and
>>> miss bugs). I won't be surprised if leak detector touches freed
>>> objects under some circumstances as well.
>>> We can do this if/when discover actual compatibility issues, of course.
>>
>> I think it's worth testing them together first.
>>
>
> I did test them together. With this patch applied both tools works without problems.

What do you mean "works without problems"? Are you sure that kmemleak
still detects all leaks it is intended to detect?
