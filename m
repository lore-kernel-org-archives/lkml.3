Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbaI2Oer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:34:47 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46790 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaI2Oeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:34:44 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-6a-54296e019180
Message-id: <54296C62.2080604@samsung.com>
Date: Mon, 29 Sep 2014 18:27:46 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.8.0
MIME-version: 1.0
To: Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
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
        x86@kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [RFC PATCH v3 13/13] kasan: introduce inline instrumentation
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-14-git-send-email-a.ryabinin@samsung.com>
 <CACT4Y+bTXPzYH+TMjM9-NyVajZms8zKdEMMLDPvOKvRSoD8tog@mail.gmail.com>
 <CAPAsAGzDWQ6LKN1RN6u0cv6eTVfxgRT6NCpGA08dC6dnDiUKmA@mail.gmail.com>
 <CACT4Y+ZVPV51vBDKTQ-snQ360kTc6axNS1g_02EA0h75Gqd3Bw@mail.gmail.com>
In-reply-to: <CACT4Y+ZVPV51vBDKTQ-snQ360kTc6axNS1g_02EA0h75Gqd3Bw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t/xy7qMeZohBh8emlj83juT1WLO+jVs
	FkeufWe3uP7tDaPFp5cPGC22XG9isnj+8CG7xYSHbewW0zaKW6zsbmaz2P7sLZPFys4HrBaX
	d81hs7i35j+rRcu+C0wWx7duYbZYfOQ2s8W7Z5OZLa6uOshu8WPDY1YHEY/5Oz8yeuycdZfd
	Y8GmUo/Fe14yeWxa1cnmsenTJHaPrrdXmDxOzPjN4vHkynQmj49Pb7F4vN93lc3jzIIj7B6f
	N8l5nGj5whrAF8Vlk5Kak1mWWqRvl8CVcbLxJWPBb5aK7kebWBsYm1i6GDk5JARMJFbOWccK
	YYtJXLi3nq2LkYtDSGApo8S7T13sEE4zk8SRG6vBqngFtCTmP7vKDGKzCKhKXDnaBmazCehJ
	/Ju1nQ3EFhWIkJiyfylUvaDEj8n3wLaJCARIvDn7gxVkKLPAYlaJu4cus4MkhAU8JW713GSG
	2DaVWeLqkV1MIAlOgWCJ+yu3gU1iFlCXmDRvETOELS+xec1b5gmMArOQLJmFpGwWkrIFjMyr
	GEVTS5MLipPSc430ihNzi0vz0vWS83M3MUJi+OsOxqXHrA4xCnAwKvHwcqzQCBFiTSwrrsw9
	xCjBwawkwmuXohkixJuSWFmVWpQfX1Sak1p8iJGJg1OqgfHCqcb+c+2lnMe8l97s1M4pFbFa
	ertb8s4Jp5k7ll1e6FzRftoikf/SXbvTYl9EHLV/5BcWt53eM9Pp9h9bL9ei32aNct4vPe7X
	3ttumNZ25saSLc7KHeqfWUIEUtatNrBd8s4gtSvHtWWx+KrfW2Wd+pZO8LyQP2WOYFS+/gZP
	r7u8cftKTJVYijMSDbWYi4oTAU3bMby/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 06:28 PM, Dmitry Vyukov wrote:
> On Fri, Sep 26, 2014 at 9:33 PM, Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:
>> 2014-09-26 21:18 GMT+04:00 Dmitry Vyukov <dvyukov@google.com>:
>>>
>>> Yikes!
>>> So this works during bootstrap, for user memory accesses, valloc
>>> memory, etc, right?
>>>
>>
>> Yes, this works. Userspace memory access in instrumented code will
>> produce general protection fault,
>> so it won't be unnoticed.
> 
> 
> Great!
> What happens during early bootstrap when shadow is not mapped yet?
> 

Shadow mapped very early. Any instrumented code executes only after shadow mapped.
