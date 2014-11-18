Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbaKRU6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:58:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbaKRU6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:58:46 -0500
Date: Tue, 18 Nov 2014 12:58:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
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
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/11] Kernel address sanitizer - runtime memory
 debugger.
Message-Id: <20141118125843.434c216540def495d50f3a45@linux-foundation.org>
In-Reply-To: <5461B906.1040803@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
	<1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
	<5461B906.1040803@samsung.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014 10:21:42 +0300 Andrey Ryabinin <a.ryabinin@samsung.com> wrote:

> Hi Andrew,
> 
> Now we have stable GCC(4.9.2) which supports kasan and from my point of view patchset is ready for merging.
> I could have sent v7 (it's just rebased v6), but I see no point in doing that and bothering people,
> unless you are ready to take it.

It's a huge pile of tricky code we'll need to maintain.  To justify its
inclusion I think we need to be confident that kasan will find a
significant number of significant bugs that
kmemcheck/debug_pagealloc/slub_debug failed to detect.

How do we get that confidence?  I've seen a small number of
minorish-looking kasan-detected bug reports go past, maybe six or so. 
That's in a 20-year-old code base, so one new minor bug discovered per
three years?  Not worth it!

Presumably more bugs will be exposed as more people use kasan on
different kernel configs, but will their number and seriousness justify
the maintenance effort?

If kasan will permit us to remove kmemcheck/debug_pagealloc/slub_debug
then that tips the balance a little.  What's the feasibility of that?


Sorry to play the hardass here, but someone has to ;)
