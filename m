Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbaGIVTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:19:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:26174 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaGIVTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:19:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,633,1400050800"; 
   d="scan'208";a="541093258"
Message-ID: <53BDB1D6.1090605@intel.com>
Date: Wed, 09 Jul 2014 14:19:18 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>, linux-kernel@vger.kernel.org
CC: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 00/21] Address sanitizer for kernel (kasan)
 - dynamic memory error detector.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is totally self-serving (and employer-serving), but has anybody
thought about this large collection of memory debugging tools that we
are growing?  It helps to have them all in the same places in the menus
(thanks for adding it to Memory Debugging, btw!).

But, this gives us at least four things that overlap with kasan's
features on some level.  Each of these has its own advantages and
disadvantages, of course:

1. DEBUG_PAGEALLOC
2. SLUB debugging / DEBUG_OBJECTS
3. kmemcheck
4. kasan
... and there are surely more coming down pike.  Like Intel MPX:

> https://software.intel.com/en-us/articles/introduction-to-intel-memory-protection-extensions

Or, do we just keep adding these overlapping tools and their associated
code over and over and fragment their user bases?

You're also claiming that "KASAN is better than all of
CONFIG_DEBUG_PAGEALLOC".  So should we just disallow (or hide)
DEBUG_PAGEALLOC on kernels where KASAN is available?

Maybe we just need to keep these out of mainline and make Andrew carry
it in -mm until the end of time. :)
