Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbaGIOc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:32:26 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:51944 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293AbaGIOcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:32:25 -0400
Date: Wed, 9 Jul 2014 09:32:21 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 12/21] mm: util: move krealloc/kzfree
 to slab_common.c
In-Reply-To: <1404905415-9046-13-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.11.1407090931350.1384@gentwo.org>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1404905415-9046-13-git-send-email-a.ryabinin@samsung.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2014, Andrey Ryabinin wrote:

> To avoid false positive reports in kernel address sanitizer krealloc/kzfree
> functions shouldn't be instrumented. Since we want to instrument other
> functions in mm/util.c, krealloc/kzfree moved to slab_common.c which is not
> instrumented.
>
> Unfortunately we can't completely disable instrumentation for one function.
> We could disable compiler's instrumentation for one function by using
> __atribute__((no_sanitize_address)).
> But the problem here is that memset call will be replaced by instumented
> version kasan_memset since currently it's implemented as define:

Looks good to me and useful regardless of the sanitizer going in.

Acked-by: Christoph Lameter <cl@linux.com>
