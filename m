Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaI2O23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:28:29 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:52219 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaI2O22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:28:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAPAsAGzDWQ6LKN1RN6u0cv6eTVfxgRT6NCpGA08dC6dnDiUKmA@mail.gmail.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-14-git-send-email-a.ryabinin@samsung.com>
 <CACT4Y+bTXPzYH+TMjM9-NyVajZms8zKdEMMLDPvOKvRSoD8tog@mail.gmail.com> <CAPAsAGzDWQ6LKN1RN6u0cv6eTVfxgRT6NCpGA08dC6dnDiUKmA@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 29 Sep 2014 18:28:06 +0400
Message-ID: <CACT4Y+ZVPV51vBDKTQ-snQ360kTc6axNS1g_02EA0h75Gqd3Bw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 13/13] kasan: introduce inline instrumentation
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
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
        x86@kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 9:33 PM, Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:
> 2014-09-26 21:18 GMT+04:00 Dmitry Vyukov <dvyukov@google.com>:
>>
>> Yikes!
>> So this works during bootstrap, for user memory accesses, valloc
>> memory, etc, right?
>>
>
> Yes, this works. Userspace memory access in instrumented code will
> produce general protection fault,
> so it won't be unnoticed.


Great!
What happens during early bootstrap when shadow is not mapped yet?
