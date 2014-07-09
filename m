Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbaGIVpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:45:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:61169 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbaGIVpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:45:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,633,1400050800"; 
   d="scan'208";a="567575388"
From: Andi Kleen <andi@firstfloor.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>, linux-kernel@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
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
Subject: Re: [RFC/PATCH RESEND -next 00/21] Address sanitizer for kernel (kasan) - dynamic memory error detector.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
	<53BDB1D6.1090605@intel.com>
Date: Wed, 09 Jul 2014 14:44:56 -0700
In-Reply-To: <53BDB1D6.1090605@intel.com> (Dave Hansen's message of "Wed, 09
	Jul 2014 14:19:18 -0700")
Message-ID: <8761j6nr53.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <dave.hansen@intel.com> writes:
>
> You're also claiming that "KASAN is better than all of

better as in finding more bugs, but surely not better as in
"do so with less overhead"

> CONFIG_DEBUG_PAGEALLOC".  So should we just disallow (or hide)
> DEBUG_PAGEALLOC on kernels where KASAN is available?

I don't think DEBUG_PAGEALLOC/SLUB debug and kasan really conflict.

DEBUG_PAGEALLOC/SLUB is "much lower overhead but less bugs found".
KASAN is "slow but thorough" There are niches for both.

But I could see KASAN eventually deprecating kmemcheck, which
is just incredible slow.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
