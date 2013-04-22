Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3DVGME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 02:12:04 -0400
Received: from smtp-out-209.synserver.de ([212.40.185.209]:1029 "EHLO
	smtp-out-209.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3DVGMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 02:12:03 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 20166
Message-ID: <5174D47E.3090301@metafoo.de>
Date: Mon, 22 Apr 2013 08:11:10 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Damian Hobson-Garcia <dhobsong@igel.co.jp>
CC: linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC/PATCH 1/4] arm64: Provide default implementation for dma_{alloc,
 free}_attrs
References: <1366607349-2992-1-git-send-email-dhobsong@igel.co.jp>
In-Reply-To: <1366607349-2992-1-git-send-email-dhobsong@igel.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 07:09 AM, Damian Hobson-Garcia wrote:
> Most architectures that define CONFIG_HAVE_DMA, have implementations for
> both dma_alloc_attrs() and dma_free_attrs().  All achitectures that do
> not define CONFIG_HAVE_DMA also have both of these definitions provided by
> dma-mapping-broken.h.
> 
> Add default implementations for these functions on arm64.
> 
> Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
> ---
>  arch/arm64/include/asm/dma-mapping.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
> index 9947768..65ab181 100644
> --- a/arch/arm64/include/asm/dma-mapping.h
> +++ b/arch/arm64/include/asm/dma-mapping.h
> @@ -81,6 +81,9 @@ static inline void dma_mark_clean(void *addr, size_t size)
>  {
>  }
>  
> +#define dma_alloc_attrs(d, s, h, f, a) dma_alloc_coherent(d, s, h, f)
> +#define dma_free_attrs(d, s, h, f, a) dma_free_coherent(d, s, h, f)
> +
>  static inline void *dma_alloc_coherent(struct device *dev, size_t size,
>  				       dma_addr_t *dma_handle, gfp_t flags)
>  {

The other way around would be better, properly implement
dma_{alloc,free}_attrs and implement dma_{alloc,free}_coherent on top of
the. E.g. you are supposed to pass the attrs parameter to ops->alloc and
ops->free instead of NULL. And it will also allow us to move
dma_{alloc,free}_coherent to asm-generic/dma-mapping-common.h eventually.

- Lars
