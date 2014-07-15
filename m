Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaGOPIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:08:38 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40000 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaGOPIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:08:31 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-24-53c543ec2ff1
Message-id: <53C542A0.5050107@samsung.com>
Date: Tue, 15 Jul 2014 19:02:56 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Christoph Lameter <cl@gentwo.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
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
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 14/21] mm: slub: kasan: disable kasan when
 touching unaccessible memory
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1404905415-9046-15-git-send-email-a.ryabinin@samsung.com>
 <20140715060405.GI11317@js1304-P5Q-DELUXE> <53C4DA54.3010502@samsung.com>
 <20140715081852.GL11317@js1304-P5Q-DELUXE>
 <alpine.DEB.2.11.1407150924320.10593@gentwo.org>
In-reply-to: <alpine.DEB.2.11.1407150924320.10593@gentwo.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA03RW0iTYRjAcd7vtG+r6dfUeLMwWHVjuU7CXiIlK+KLboIRRES5dKjopm1t
	pCQtPMTmCs/ZcrFSk5mH3IjN0yZzZmFOc2WStQ6WJDUlTRgoVnNdePd74P/wXDw0LmgjYuks
	xRWZUiHNEVI8Ynh1aCLh57FByb7SSoSW++6SqL6jlULN9SYMlX8u5SBLWRGF7DMBDFl0n0hk
	nZ4g0Uq3A0O+7noK+Vv/kGjKx0fj/WYMFTvHMFS6uEoip2X0nxo7MdTgmcLR3EwVjmzWGhwF
	n0yTR2LY4iIDxboGlGyX8QOHNVvVrLVFR7HWhUoOqw+8xtg5r5fDPq9bJlhb43X217d3BDvv
	fEOxL80eDrtojTsdcY53OF2Wk6WRKfcmp/IyH427QJ4p4qrdUoFrQc8GPeDSkEmErt5lMuzN
	cMzfQekBjxYwTQDWDd3Aw0MRBg1BDx6q+Ew87FoYASETzC741N+OhUwxIrhqtFMhxzBnYf/t
	GTLcb4LBKj8RcjRzCi7qdGu7ONNGQnf75ZCjGAV0jJat9QKmHYO+6sKQuUwS7Hlx73+/B7pK
	aqmwt0NbawAvB4xx3Qnjusy4LjMDvAXEyNRpeapLGfIDIpVUrlIrMkRpuXIrCL94yQGanh1y
	A4YGwo38yVqPREBKNap8uRtAGhdG87ckDkoE/HRpfoFMmXtRqc6RqdwAo7mxWiAZGflCeE4U
	Sg8OMfeDDQOT6q58tDNhq8Gg9V6ItEluUbU3a5xArd9mf/i4F8vWPoiKv9Y8+9snjsuO9Jyc
	/fFeJUhq1Iv7aG7yfLopbrerxOR4dQeeb/Piw4OmioC4ILJatHS88eNXjcX/1vl9ekUTkZIi
	28F2HhXD1DNCQpUp3R+PK1XSvyvznuLAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/14 18:26, Christoph Lameter wrote:
> On Tue, 15 Jul 2014, Joonsoo Kim wrote:
> 
>>> I think putting disable/enable only where we strictly need them might be a problem for future maintenance of slub.
>>> If someone is going to add a new function call somewhere, he must ensure that it this call won't be a problem
>>> for kasan.
>>
>> I don't agree with this.
>>
>> If someone is going to add a slab_pad_check() in other places in
>> slub.c, we should disable/enable kasan there, too. This looks same
>> maintenance problem to me. Putting disable/enable only where we
>> strictly need at least ensures that we don't need to care when using
>> slub internal functions.
>>
>> And, if memchr_inv() is problem, I think that you also need to add hook
>> into validate_slab_cache().
>>
>> validate_slab_cache() -> validate_slab_slab() -> validate_slab() ->
>> check_object() -> check_bytes_and_report() -> memchr_inv()
> 
> I think adding disable/enable is good because it separates the payload
> access from metadata accesses. This may be useful for future checkers.
> Maybe call it something different so that this is more generic.
> 
> metadata_access_enable()
> 
> metadata_access_disable()
> 
> ?
> 
It sounds like a good idea to me. However in this patch, besides from protecting metadata accesses,
this calls also used in setup_objects for wrapping ctor call. It used there because all pages in allocate_slab
are poisoned, so at the time when ctors are called all object's memory marked as poisoned.

I think this could be solved by removing kasan_alloc_slab_pages() hook form allocate_slab() and adding
kasan_slab_free() hook after ctor call.
But I guess in that case padding at the end of slab will be unpoisoined.

> Maybe someone else has a better idea?
> 
> 
> 

