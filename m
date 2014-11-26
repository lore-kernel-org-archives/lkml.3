Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaKZVm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:42:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaKZVm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:42:27 -0500
Date: Wed, 26 Nov 2014 13:42:26 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 2/2] staging: android: ion: One function call less in
 ion_buffer_create() after error detection
Message-ID: <20141126214226.GB31904@kroah.com>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54722893.6020301@users.sourceforge.net>
 <54722AF8.3000609@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54722AF8.3000609@users.sourceforge.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 07:44:08PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 23 Nov 2014 19:12:29 +0100
> 
> The jump label "err1" was used by the ion_buffer_create() function in case of
> a memory allocation failure just to pass a null pointer to a vfree() function
> call by a data structure element.
> This implementation detail could be improved by the deletion of this
> inappropriate jump label.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/staging/android/ion/ion.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> index df12cc3..7a26b85 100644
> --- a/drivers/staging/android/ion/ion.c
> +++ b/drivers/staging/android/ion/ion.c
> @@ -226,7 +226,7 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
>  		buffer->pages = vmalloc(sizeof(struct page *) * num_pages);
>  		if (!buffer->pages) {
>  			ret = -ENOMEM;
> -			goto err1;
> +			goto err2;
>  		}
>  
>  		for_each_sg(table->sgl, sg, table->nents, i) {
> @@ -262,7 +262,6 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
>  err:
>  	heap->ops->unmap_dma(heap, buffer);
>  	heap->ops->free(buffer);
> -err1:
>  	vfree(buffer->pages);
>  err2:

Now we have "err" and "err2", which doesn't make much sense, please fix
up.

