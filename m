Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbaGLBAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 21:00:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41303 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbaGLBAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 21:00:34 -0400
Message-ID: <53C08876.10209@zytor.com>
Date: Fri, 11 Jul 2014 17:59:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
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
Subject: Re: [RFC/PATCH -next 00/21] Address sanitizer for kernel (kasan)
 - dynamic memory error detector.
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 04:00 AM, Andrey Ryabinin wrote:
> 
> Address sanitizer dedicates 1/8 of the low memory to the shadow memory and uses direct
> mapping with a scale and offset to translate a memory address to its corresponding
> shadow address.
> 
> Here is function to translate address to corresponding shadow address:
> 
>      unsigned long kasan_mem_to_shadow(unsigned long addr)
>      {
> 		return ((addr) >> KASAN_SHADOW_SCALE_SHIFT)
>        	             + kasan_shadow_start - (PAGE_OFFSET >> KASAN_SHADOW_SCALE_SHIFT);
>      }
> 
> where KASAN_SHADOW_SCALE_SHIFT = 3.
> 

How does that work when memory is sparsely populated?

	-hpa

