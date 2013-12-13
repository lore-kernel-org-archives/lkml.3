Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab3LMCCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:02:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3LMCCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:02:23 -0500
Date: Thu, 12 Dec 2013 18:04:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dma-buf: Implement test module
Message-ID: <20131213020413.GD13333@kroah.com>
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386858989-1487-1-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 03:36:29PM +0100, Thierry Reding wrote:
> This is a simple test module that can be used to allocate, export and
> delete DMA-BUF objects. It can be used to test DMA-BUF sharing in
> systems that lack a real second driver.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/base/Kconfig        |   4 +
>  drivers/base/Makefile       |   1 +
>  drivers/base/dma-buf-test.c | 308 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 313 insertions(+)
>  create mode 100644 drivers/base/dma-buf-test.c
> 
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index e373671652b0..bed2abb9491b 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -200,6 +200,10 @@ config DMA_SHARED_BUFFER
>  	  APIs extension; the file's descriptor can then be passed on to other
>  	  driver.
>  
> +config DMA_BUF_TEST
> +	tristate "DMA-BUF test module"
> +	depends on DMA_SHARED_BUFFER

We need some good documentation here.

> > +static struct miscdevice dmabuf_device = {
> +	.minor = 128,

Why did you pick this minor?  Why not just make it dynamic?

thanks,

greg k-h
