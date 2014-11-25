Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaKYOQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:16:50 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49111 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbaKYOQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:16:48 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-06-54748f4eb053
Message-id: <54748F4A.8030003@samsung.com>
Date: Tue, 25 Nov 2014 17:16:42 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Dmitry Chernenkov <dmitryc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Michal Marek <mmarek@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 01/12] Add kernel address sanitizer infrastructure.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-2-git-send-email-a.ryabinin@samsung.com>
 <CAA6XgkH4soz_oCiO+X2Tibc3H6NHiZJp5ySzk5SSntD9dV6Gfw@mail.gmail.com>
In-reply-to: <CAA6XgkH4soz_oCiO+X2Tibc3H6NHiZJp5ySzk5SSntD9dV6Gfw@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t/xK7p+/SUhBj2NzBa/985ktZizfg2b
	xZFr39ktrn97w2jx5EA7o8Wnlw8YLbZcb2KyeP7wIbvFhIdt7BbTNopbrOxuZrPY/uwtk8XK
	zgesFpd3zWGzuLfmP6vFpQMLmCxa9l1gsjjee4DJ4u2d6SwWi4/cZrZ492wys8XVVQfZLX5s
	eMzqIO4xf+dHRo+ds+6yeyzYVOqxeYWWx+I9L5k8Nq3qZPPY9GkSu0fX2ytMHidm/GbxeHJl
	OpPH4r7JrB4fn95i8Xi/7yqbx5kFR9g9Pm+S8zjR8oU1QCCKyyYlNSezLLVI3y6BK+PzFrWC
	26wVd/q3MTUwnmLpYuTkkBAwkXjWeI0RwhaTuHBvPVsXIxeHkMBSRonOZZ+ZQBJCAs1MEpt3
	pIPYvAJaEqvO/AdrYBFQldjy+hrYIDYBPYl/s7azgdiiAhESV9bMYYSoF5T4MfkeWI0IUO/5
	Dw9YQRYwCxxmk3h+Yip7FyMHh7CAl8TXh6YQi1uYJA4uXAQ2iFMgWOL9ysfMIDXMAuoSU6bk
	goSZBeQlNq95yzyBUWAWkhWzEKpmIalawMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMk
	0r/uYFx6zOoQowAHoxIP7424khAh1sSy4srcQ4wSHMxKIrxBvUAh3pTEyqrUovz4otKc1OJD
	jEwcnFINjP0hUx+1P0rsqX+6p/9Zd84xhkY5sQvPbrwpqT2VveOrojn3vsuPm9//mz7X6ueO
	t82bjF44HdoS4iHJN6NvSqx2xqEf3M3pLrsFrLUPJqltjjBQXTd/alXP7tDgBdpnuufxbp7W
	/+DNDo34iiOGt8r8uI+/SWivkEvj/baO4/3Eru5E/U3mG5VYijMSDbWYi4oTAQZz7gTSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 03:40 PM, Dmitry Chernenkov wrote:
> I'm a little concerned with how enabling/disabling works. If an
> enable() is forgotten once, it's disabled forever. If disable() is
> forgotten once, the toggle is reversed for the forseable future. MB
> check for inequality in kasan_enabled()? like current->kasan_depth >=
> 0 (will need a signed int for the field). Do you think it's going to
> decrease performance?

I think that check in kasan_enabled shouldn't hurt much.
But it also doesn't look very useful for me.

There are only few user of kasan_disable_local/kasan_enable_local, it's easy to review them.
And in future we also shouldn't have a lot of new users of those functions.

> 
> LGTM
> 
> 

