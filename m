Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaIZSsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 14:48:04 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:40751 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbaIZSsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:48:02 -0400
MIME-Version: 1.0
In-Reply-To: <CACT4Y+bptO341KQAQMSzUVV22KsjuomdTeDip=HaHJ3+1kvraQ@mail.gmail.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
	<1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
	<54259BD4.8090508@oracle.com>
	<CACT4Y+Y0fzbs4DPt3n30R33cYqXEZ8E86tzCfzL6RUE9f+-r=w@mail.gmail.com>
	<CAPAsAGyDpnhpMquXi-K4wdDEbj-5W44uJLircsok7ziOO_m66g@mail.gmail.com>
	<CACT4Y+bptO341KQAQMSzUVV22KsjuomdTeDip=HaHJ3+1kvraQ@mail.gmail.com>
Date: Fri, 26 Sep 2014 22:48:00 +0400
Message-ID: <CAJOtW+7UJQ2=66vELbyfXumQ=c9LknRAzXmd6Z6ea7i4oy6FwA@mail.gmail.com>
Subject: Re: [PATCH v3 00/13] Kernel address sanitizer - runtime memory debugger.
From: Yuri Gribov <tetra2005@gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kbuild@vger.kernel.org,
        x86@kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 9:29 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
> So in kernel we will need to support all API versions, and the
> following looks like a much simpler way to identify current API
> version:
>> #if __GNUC__ == 5
>> #define ASAN_V4

What about having compiler(s) predefine some __SANITIZE_ADDRESS_ABI__
macro for this? Hacking on __GNUC__ may not work given the zoo of GCC
versions out there (FSF, Linaro, vendor toolchains, etc.)?

-Y
