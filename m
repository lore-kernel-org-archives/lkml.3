Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbaFSHef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 03:34:35 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47322 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaFSHee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 03:34:34 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-60-53a2928786d8
Message-id: <53A29158.2050809@samsung.com>
Date: Thu, 19 Jun 2014 11:29:28 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: slab.h: wrap the whole file with guarding macro
References: <1403100695-1350-1-git-send-email-a.ryabinin@samsung.com>
 <alpine.DEB.2.02.1406181321010.10339@chino.kir.corp.google.com>
In-reply-to: <alpine.DEB.2.02.1406181321010.10339@chino.kir.corp.google.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xy7rtkxYFG/xdoW4xZ/0aNovr394w
	WlzeNYfN4t6a/6wWbZ//AYklG5ksLm+dyezA7rFgU6nHplWdbB6bPk1i9zgx4zeLx5Mr05k8
	Ts77yebxeZNcAHsUl01Kak5mWWqRvl0CV8a39XNZCr6xV7w59ZmlgXExWxcjB4eEgInEkQXy
	XYycQKaYxIV764HCXBxCAksZJX5ue8kI4TQzSVxsbWYBqeIV0JJ4e/k6I4jNIqAqsezgNDYQ
	m01AT+LfrO1gQ0UFIiQeXxCCKBeU+DH5HliriICGRNuM/2ALmAWuMkqsntbEDpIQFvCQWH9p
	ESuILSTQzijRuDEIxOYU8JF49/A7WJxZQEdifyvELmYBeYnNa94yT2AUmIVkxywkZbOQlC1g
	ZF7FKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERL2X3YwLj5mdYhRgINRiYf3w9sFwUKsiWXF
	lbmHGCU4mJVEeFVTFwUL8aYkVlalFuXHF5XmpBYfYmTi4JRqYIx9Wndd5JGmYDZ7wInzc87e
	8JS0ODm/WmGWEfeet9NP7I162fTGh3Nq9BmnV3sXRipbP91qV6bjna997OZM5qWCLxV/Jbkd
	L+5bJLri26lPDmIqMy/fnS68fc3sawn7t83r1bm5fff3f9oL3y8/93252q1jRn3iZgqO7Atm
	XCvNuBiSkFQ613uxEktxRqKhFnNRcSIABKoysVkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/14 00:22, David Rientjes wrote:
> On Wed, 18 Jun 2014, Andrey Ryabinin wrote:
> 
>> Guarding section:
>> 	#ifndef MM_SLAB_H
>> 	#define MM_SLAB_H
>> 	...
>> 	#endif
>> currently doesn't cover the whole mm/slab.h. It seems like it was
>> done unintentionally.
>>
>> Wrap the whole file by moving closing #endif to the end of it.
>>
>> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> Looks like
> 
> ca34956b804b ("slab: Common definition for kmem_cache_node")
> e25839f67948 ("mm/slab: Sharing s_next and s_stop between slab and slub
> 276a2439ce79 ("mm/slab: Give s_next and s_stop slab-specific names")
> 
> added onto the header without the guard and it has been this way since 
> Jan 10 2013.  Andrey, how did you notice that this was an issue?  Simply 
> by visual inspection?
> 

I had to do some modifications in this file for some reasons, and for me it was hard to not
notice lack of endif in the end.
