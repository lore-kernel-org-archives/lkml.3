Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaIOHS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 03:18:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12691 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbaIOHSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 03:18:24 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-6e-541692be5302
Message-id: <54169130.2000601@samsung.com>
Date: Mon, 15 Sep 2014 11:11:44 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.8.0
MIME-version: 1.0
To: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC/PATCH v2 05/10] mm: slub: share slab_err and object_err
 functions
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-6-git-send-email-a.ryabinin@samsung.com>
In-reply-to: <1410359487-31938-6-git-send-email-a.ryabinin@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t/xy7r7JomFGJxvtLH4vXcmq8Wc9WvY
	LI5c+85ucf3bG0aLTy8fMFo8f/iQ3WLCwzZ2i2kbxS1WdjezWWx/9pbJYmXnA1aLy7vmsFnc
	W/Of1aLt8z8gsWQjk8XiI7eZLd49m8xscXXVQXaLHxseszoIe8zf+ZHRY+esu+weCzaVeize
	85LJY9OqTjaPTZ8msXt0vb3C5HFixm8WjydXpjN5fHx6i8Xj8yY5jxMtX1gDeKK4bFJSczLL
	Uov07RK4Mr6cvshesI+34tix5ywNjPe4uhg5OSQETCS2bfrJDGGLSVy4t56ti5GLQ0hgKaPE
	sZYLLBBOM5PE5N4NbCBVvAJaEj/3fQGzWQRUJXoWrWIEsdkE9CT+zdoOFhcViJCYsn8pK0S9
	oMSPyfdYQGwRASeJZX862EGGMgt8YJE4tn49O0hCWCBU4sjbi+wQ2/YzSkzeeYIJJMEp4C5x
	9+BUsG5mAXWJSfMWMUPY8hKb17xlnsAoMAvJkllIymYhKVvAyLyKUTS1NLmgOCk910ivODG3
	uDQvXS85P3cTIyRKv+5gXHrM6hCjAAejEg/vhS/CIUKsiWXFlbmHGCU4mJVEeAPdxUKEeFMS
	K6tSi/Lji0pzUosPMTJxcEo1MLJr/U+csPxtrxlnSr7WulKTp0z6sS8bYpYvcnr+dn7527Cu
	gKW8O6P/+nwNn+ovr7Dx57esuWnX1k1/o/agpiXz00n99b6Njf9/ftY7Icp8/opw6BlbF59H
	jnL3bnCeq9kT7ljPyyiX57vn4oKciaUqi8/av9nkHxHK/j3YYvZirzNMTDw6GUosxRmJhlrM
	RcWJAKCvhBewAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 06:31 PM, Andrey Ryabinin wrote:
> Remove static and add function declarations to mm/slab.h so they
> could be used by kernel address sanitizer.
> 

The same as with virt_to_obj. include/linux/slub_def.h is much better place for this than mm/slab.h.


> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>  mm/slab.h | 5 +++++
>  mm/slub.c | 4 ++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 3e3a6ae..87491dd 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -345,6 +345,11 @@ static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int node)
>  
>  void *slab_next(struct seq_file *m, void *p, loff_t *pos);
>  void slab_stop(struct seq_file *m, void *p);
> +void slab_err(struct kmem_cache *s, struct page *page,
> +		const char *fmt, ...);
> +void object_err(struct kmem_cache *s, struct page *page,
> +		u8 *object, char *reason);
> +
>  
>  static inline void *virt_to_obj(struct kmem_cache *s, void *slab_page, void *x)
>  {
> diff --git a/mm/slub.c b/mm/slub.c
> index fa86e58..c4158b2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -639,14 +639,14 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
>  	dump_stack();
>  }
>  
> -static void object_err(struct kmem_cache *s, struct page *page,
> +void object_err(struct kmem_cache *s, struct page *page,
>  			u8 *object, char *reason)
>  {
>  	slab_bug(s, "%s", reason);
>  	print_trailer(s, page, object);
>  }
>  
> -static void slab_err(struct kmem_cache *s, struct page *page,
> +void slab_err(struct kmem_cache *s, struct page *page,
>  			const char *fmt, ...)
>  {
>  	va_list args;
> 

