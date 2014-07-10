Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaGJOAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:00:23 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51103 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaGJOAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:00:20 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-89-53be9c704fda
Message-id: <53BE9B25.6090906@samsung.com>
Date: Thu, 10 Jul 2014 17:54:45 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
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
Subject: Re: [RFC/PATCH RESEND -next 03/21] x86: add kasan hooks fort
 memcpy/memmove/memset functions
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1404905415-9046-4-git-send-email-a.ryabinin@samsung.com>
 <87ion6nxap.fsf@tassilo.jf.intel.com>
In-reply-to: <87ion6nxap.fsf@tassilo.jf.intel.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0iTYRiGe7+zo9nXPPTij4xRJErThtFbhBhBfAShIFFEYFOXCk7H1kQr
	UpqnmZbOJB2ay1SYDMxv4GGtNURcB/GshdpcmQeqWSapMLGc++O/i4frvu8fD4OLuokwJjP7
	tlyVLcsSUwLiw7Zz8oSywZ4U43SfRt7X9SRq6DBTqH9qg0Yf138CVPWlhEamh1oKdS96MGTS
	uUnEz0+RaMvag6FxawOFXOZ/JJoZF6IxhxFDRfYRDJWsbZPIbhreoZZODL3on8HRymINjix8
	LY42X86T8aFckbaC4pp6VwHXa/hMc0Zew/HtOorj/+hprtwzgXErQ0M097bOS3DfJp5inKWl
	gFtdmCa4X/ZJihs09tPcGn848cB1wbk0eVZmrlwVHXdTkPF4dohUuqg8d309UQhsZDkIYCAb
	C5ff8bSfQ+GIq4MqBwJGxLYC2OZs3ZVErBaDurZwHwvZSGh+srwTYBiCPQZHdWm+M8VK4Lah
	m/JxCHsNOh4tkn79INyscRE+PZg9Cp3vA331OLtBwo5Sx64fxKbD2goL7d81AbhUOb0bDmCl
	sGthHfMxzh6H+mfNuJ/DocXswasAa9izYdijGfZoRoC3gxC5JlWpTklXSCVqmUKtyU6XpOYo
	eOB/9t8e0Dpwtg+wDBDvFy6/siWJSFmuOl/RByCDi4OF32vtSSJhmiz/jlyVk6zSZMnVfQBj
	AsIKwcR84+8piQcLL66OrK6TXgriHyQkNs0qzzNfiycHQnKlustnjAn3tSnei2Nzcxc81YKu
	pWjvSOwRt7Us+U3ggOIHU/ip0XVLftcd1Wy1SHQlUfH/PFcqIyJKxZ3OLfFwmcOWFzOYeuNe
	c+tzPidl39bVUY/tUEEcGNPrlYmnxIQ6Q3YyElepZf8Brt8Q68oCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/14 23:31, Andi Kleen wrote:
> Andrey Ryabinin <a.ryabinin@samsung.com> writes:
>> +
>> +#undef memcpy
>> +void *kasan_memset(void *ptr, int val, size_t len);
>> +void *kasan_memcpy(void *dst, const void *src, size_t len);
>> +void *kasan_memmove(void *dst, const void *src, size_t len);
>> +
>> +#define memcpy(dst, src, len) kasan_memcpy((dst), (src), (len))
>> +#define memset(ptr, val, len) kasan_memset((ptr), (val), (len))
>> +#define memmove(dst, src, len) kasan_memmove((dst), (src), (len))
> 
> I don't think just define is enough, gcc can call these functions
> implicitely too (both with and without __). For example for a struct copy.
> 
> You need to have true linker level aliases. 
> 

It's true, but problem with linker aliases that they cannot be disabled for some files
we don't want to instrument.

> -Andi
> 

