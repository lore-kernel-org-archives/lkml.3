Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaBQSdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:33:43 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:42645 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbaBQSdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:33:42 -0500
Message-ID: <53025602.90907@linaro.org>
Date: Mon, 17 Feb 2014 10:33:38 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org
CC: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH V2] staging: ion: replace ion_phys_addr_t with phys_addr_t
References: <1392595206-6650-1-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1392595206-6650-1-git-send-email-tomas.winkler@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2014 04:00 PM, Tomas Winkler wrote:
> Looks like phys_addr_t's are fully plumbed in the kernel.

This needs a better commit description.

Also you should include Colin and the rest of the Android kernel folks
(cc'ed in this mail) so they can review and hopefully provide acks.

thanks
-john

>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
> V2: remove one more comment regarding ion_phys_addr_t
>
>  drivers/staging/android/ion/ion.c               |  2 +-
>  drivers/staging/android/ion/ion.h               | 12 +++---------
>  drivers/staging/android/ion/ion_carveout_heap.c | 14 +++++++-------
>  drivers/staging/android/ion/ion_chunk_heap.c    |  2 +-
>  drivers/staging/android/ion/ion_cma_heap.c      |  2 +-
>  drivers/staging/android/ion/ion_priv.h          | 10 +++++-----
>  drivers/staging/android/ion/ion_system_heap.c   |  2 +-
>  7 files changed, 19 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> index 14cb6c6..fb0d105 100644
> --- a/drivers/staging/android/ion/ion.c
> +++ b/drivers/staging/android/ion/ion.c
> @@ -547,7 +547,7 @@ void ion_free(struct ion_client *client, struct ion_handle *handle)
>  EXPORT_SYMBOL(ion_free);
>  
>  int ion_phys(struct ion_client *client, struct ion_handle *handle,
> -	     ion_phys_addr_t *addr, size_t *len)
> +	     phys_addr_t *addr, size_t *len)
>  {
>  	struct ion_buffer *buffer;
>  	int ret;
> diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
> index dcd2a0c..43b76f3 100644
> --- a/drivers/staging/android/ion/ion.h
> +++ b/drivers/staging/android/ion/ion.h
> @@ -28,12 +28,6 @@ struct ion_mapper;
>  struct ion_client;
>  struct ion_buffer;
>  
> -/* This should be removed some day when phys_addr_t's are fully
> -   plumbed in the kernel, and all instances of ion_phys_addr_t should
> -   be converted to phys_addr_t.  For the time being many kernel interfaces
> -   do not accept phys_addr_t's that would have to */
> -#define ion_phys_addr_t unsigned long
> -
>  /**
>   * struct ion_platform_heap - defines a heap in the given platform
>   * @type:	type of the heap from ion_heap_type enum
> @@ -52,9 +46,9 @@ struct ion_platform_heap {
>  	enum ion_heap_type type;
>  	unsigned int id;
>  	const char *name;
> -	ion_phys_addr_t base;
> +	phys_addr_t base;
>  	size_t size;
> -	ion_phys_addr_t align;
> +	phys_addr_t align;
>  	void *priv;
>  };
>  
> @@ -145,7 +139,7 @@ void ion_free(struct ion_client *client, struct ion_handle *handle);
>   * holding a reference.
>   */
>  int ion_phys(struct ion_client *client, struct ion_handle *handle,
> -	     ion_phys_addr_t *addr, size_t *len);
> +	     phys_addr_t *addr, size_t *len);
>  
>  /**
>   * ion_map_dma - return an sg_table describing a handle
> diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/staging/android/ion/ion_carveout_heap.c
> index 3cb05b9..295340e 100644
> --- a/drivers/staging/android/ion/ion_carveout_heap.c
> +++ b/drivers/staging/android/ion/ion_carveout_heap.c
> @@ -28,10 +28,10 @@
>  struct ion_carveout_heap {
>  	struct ion_heap heap;
>  	struct gen_pool *pool;
> -	ion_phys_addr_t base;
> +	phys_addr_t base;
>  };
>  
> -ion_phys_addr_t ion_carveout_allocate(struct ion_heap *heap,
> +phys_addr_t ion_carveout_allocate(struct ion_heap *heap,
>  				      unsigned long size,
>  				      unsigned long align)
>  {
> @@ -45,7 +45,7 @@ ion_phys_addr_t ion_carveout_allocate(struct ion_heap *heap,
>  	return offset;
>  }
>  
> -void ion_carveout_free(struct ion_heap *heap, ion_phys_addr_t addr,
> +void ion_carveout_free(struct ion_heap *heap, phys_addr_t addr,
>  		       unsigned long size)
>  {
>  	struct ion_carveout_heap *carveout_heap =
> @@ -58,11 +58,11 @@ void ion_carveout_free(struct ion_heap *heap, ion_phys_addr_t addr,
>  
>  static int ion_carveout_heap_phys(struct ion_heap *heap,
>  				  struct ion_buffer *buffer,
> -				  ion_phys_addr_t *addr, size_t *len)
> +				  phys_addr_t *addr, size_t *len)
>  {
>  	struct sg_table *table = buffer->priv_virt;
>  	struct page *page = sg_page(table->sgl);
> -	ion_phys_addr_t paddr = PFN_PHYS(page_to_pfn(page));
> +	phys_addr_t paddr = PFN_PHYS(page_to_pfn(page));
>  
>  	*addr = paddr;
>  	*len = buffer->size;
> @@ -75,7 +75,7 @@ static int ion_carveout_heap_allocate(struct ion_heap *heap,
>  				      unsigned long flags)
>  {
>  	struct sg_table *table;
> -	ion_phys_addr_t paddr;
> +	phys_addr_t paddr;
>  	int ret;
>  
>  	if (align > PAGE_SIZE)
> @@ -111,7 +111,7 @@ static void ion_carveout_heap_free(struct ion_buffer *buffer)
>  	struct ion_heap *heap = buffer->heap;
>  	struct sg_table *table = buffer->priv_virt;
>  	struct page *page = sg_page(table->sgl);
> -	ion_phys_addr_t paddr = PFN_PHYS(page_to_pfn(page));
> +	phys_addr_t paddr = PFN_PHYS(page_to_pfn(page));
>  
>  	ion_heap_buffer_zero(buffer);
>  
> diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
> index d40f5f8..86b467e 100644
> --- a/drivers/staging/android/ion/ion_chunk_heap.c
> +++ b/drivers/staging/android/ion/ion_chunk_heap.c
> @@ -27,7 +27,7 @@
>  struct ion_chunk_heap {
>  	struct ion_heap heap;
>  	struct gen_pool *pool;
> -	ion_phys_addr_t base;
> +	phys_addr_t base;
>  	unsigned long chunk_size;
>  	unsigned long size;
>  	unsigned long allocated;
> diff --git a/drivers/staging/android/ion/ion_cma_heap.c b/drivers/staging/android/ion/ion_cma_heap.c
> index f0f9889..f1e9211 100644
> --- a/drivers/staging/android/ion/ion_cma_heap.c
> +++ b/drivers/staging/android/ion/ion_cma_heap.c
> @@ -129,7 +129,7 @@ static void ion_cma_free(struct ion_buffer *buffer)
>  
>  /* return physical address in addr */
>  static int ion_cma_phys(struct ion_heap *heap, struct ion_buffer *buffer,
> -			ion_phys_addr_t *addr, size_t *len)
> +			phys_addr_t *addr, size_t *len)
>  {
>  	struct ion_cma_heap *cma_heap = to_cma_heap(buffer->heap);
>  	struct device *dev = cma_heap->dev;
> diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
> index 0942a7f..f16e70f 100644
> --- a/drivers/staging/android/ion/ion_priv.h
> +++ b/drivers/staging/android/ion/ion_priv.h
> @@ -42,7 +42,7 @@ struct ion_buffer *ion_handle_buffer(struct ion_handle *handle);
>   * @priv_virt:		private data to the buffer representable as
>   *			a void *
>   * @priv_phys:		private data to the buffer representable as
> - *			an ion_phys_addr_t (and someday a phys_addr_t)
> + *			an phys_addr_t
>   * @lock:		protects the buffers cnt fields
>   * @kmap_cnt:		number of times the buffer is mapped to the kernel
>   * @vaddr:		the kenrel mapping if kmap_cnt is not zero
> @@ -69,7 +69,7 @@ struct ion_buffer {
>  	size_t size;
>  	union {
>  		void *priv_virt;
> -		ion_phys_addr_t priv_phys;
> +		phys_addr_t priv_phys;
>  	};
>  	struct mutex lock;
>  	int kmap_cnt;
> @@ -106,7 +106,7 @@ struct ion_heap_ops {
>  			unsigned long align, unsigned long flags);
>  	void (*free)(struct ion_buffer *buffer);
>  	int (*phys)(struct ion_heap *heap, struct ion_buffer *buffer,
> -		    ion_phys_addr_t *addr, size_t *len);
> +		    phys_addr_t *addr, size_t *len);
>  	struct sg_table * (*map_dma)(struct ion_heap *heap,
>  				     struct ion_buffer *buffer);
>  	void (*unmap_dma)(struct ion_heap *heap, struct ion_buffer *buffer);
> @@ -282,9 +282,9 @@ void ion_cma_heap_destroy(struct ion_heap *);
>   * kernel api to allocate/free from carveout -- used when carveout is
>   * used to back an architecture specific custom heap
>   */
> -ion_phys_addr_t ion_carveout_allocate(struct ion_heap *heap, unsigned long size,
> +phys_addr_t ion_carveout_allocate(struct ion_heap *heap, unsigned long size,
>  				      unsigned long align);
> -void ion_carveout_free(struct ion_heap *heap, ion_phys_addr_t addr,
> +void ion_carveout_free(struct ion_heap *heap, phys_addr_t addr,
>  		       unsigned long size);
>  /**
>   * The carveout heap returns physical addresses, since 0 may be a valid
> diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
> index 9849f39..79422c3 100644
> --- a/drivers/staging/android/ion/ion_system_heap.c
> +++ b/drivers/staging/android/ion/ion_system_heap.c
> @@ -442,7 +442,7 @@ static void ion_system_contig_heap_free(struct ion_buffer *buffer)
>  
>  static int ion_system_contig_heap_phys(struct ion_heap *heap,
>  				       struct ion_buffer *buffer,
> -				       ion_phys_addr_t *addr, size_t *len)
> +				       phys_addr_t *addr, size_t *len)
>  {
>  	struct sg_table *table = buffer->priv_virt;
>  	struct page *page = sg_page(table->sgl);

