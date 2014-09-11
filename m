Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaIKD4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 23:56:42 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20755 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaIKD4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 23:56:41 -0400
Message-ID: <54111D3B.6060609@oracle.com>
Date: Wed, 10 Sep 2014 23:55:39 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>, linux-kernel@vger.kernel.org
CC: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC/PATCH v2 01/10] Add kernel address sanitizer infrastructure.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com> <1410359487-31938-2-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1410359487-31938-2-git-send-email-a.ryabinin@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 10:31 AM, Andrey Ryabinin wrote:
> +ifdef CONFIG_KASAN
> +  ifeq ($(call cc-option, $(CFLAGS_KASAN)),)
> +    $(warning Cannot use CONFIG_KASAN: \
> +	      -fsanitize=kernel-address not supported by compiler)
> +  endif
> +endif

This seems to always indicate that my gcc doesn't support
-fsanitize=kernel-address:

Makefile:769: Cannot use CONFIG_KASAN: -fsanitize=kernel-address not supported by compiler

Even though:

$ gcc --version
gcc (GCC) 5.0.0 20140904 (experimental)
Copyright (C) 2014 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ cat test.c
#include <stdio.h>
#include <sys/mman.h>

void __asan_init_v3(void) { }

int main(int argc, char *argv[])
{
        return 0;
}
$ gcc -fsanitize=kernel-address test.c
$ ./a.out
$


Thanks,
Sasha
