Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbaLAXNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:13:34 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35737 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaLAXNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:13:33 -0500
Date: Mon, 1 Dec 2014 15:13:30 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Michal Marek <mmarek@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v8 01/12] Add kernel address sanitizer infrastructure.
In-Reply-To: <1417104057-20335-2-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.10.1412011512390.26834@chino.kir.corp.google.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1417104057-20335-1-git-send-email-a.ryabinin@samsung.com> <1417104057-20335-2-git-send-email-a.ryabinin@samsung.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014, Andrey Ryabinin wrote:

> diff --git a/Documentation/kasan.txt b/Documentation/kasan.txt
> new file mode 100644
> index 0000000..a3a9009
> --- /dev/null
> +++ b/Documentation/kasan.txt
> @@ -0,0 +1,169 @@
> +Kernel address sanitizer
> +================
> +
> +0. Overview
> +===========
> +
> +Kernel Address sanitizer (KASan) is a dynamic memory error detector. It provides
> +a fast and comprehensive solution for finding use-after-free and out-of-bounds
> +bugs.
> +
> +KASan uses compile-time instrumentation for checking every memory access,
> +therefore you will need a certain version of GCC >= 4.9.2
> +
> +Currently KASan is supported only for x86_64 architecture and requires that the
> +kernel be built with the SLUB allocator.
> +
> +1. Usage
> +=========
> +
> +To enable KASAN configure kernel with:
> +
> +	  CONFIG_KASAN = y
> +
> +and choose between CONFIG_KASAN_OUTLINE and CONFIG_KASAN_INLINE. Outline/inline
> +is compiler instrumentation types. The former produces smaller binary the
> +latter is 1.1 - 2 times faster. Inline instrumentation requires GCC 5.0 or
> +latter.
> +
> +Currently KASAN works only with the SLUB memory allocator.
> +For better bug detection and nicer report, enable CONFIG_STACKTRACE and put
> +at least 'slub_debug=U' in the boot cmdline.
> +
> +To disable instrumentation for specific files or directories, add a line
> +similar to the following to the respective kernel Makefile:
> +
> +        For a single file (e.g. main.o):
> +                KASAN_SANITIZE_main.o := n
> +
> +        For all files in one directory:
> +                KASAN_SANITIZE := n
> +

More precisely, this requires CONFIG_SLUB_DEBUG and not just CONFIG_SLUB.
