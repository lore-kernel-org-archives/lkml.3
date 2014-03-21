Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbaCUOEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:04:10 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:47392 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaCUOEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:04:09 -0400
MIME-Version: 1.0
In-Reply-To: <1395409943-19023-1-git-send-email-eu@opreamatei.ro>
References: <1395409943-19023-1-git-send-email-eu@opreamatei.ro>
Date: Fri, 21 Mar 2014 07:04:07 -0700
Message-ID: <CAHj3AV=K8XU_Tik6pB4d0E6Mb5f+YhHtn1pEA2hWKqDqCWs8iQ@mail.gmail.com>
Subject: Re: [PATCH] drivers: staging: cxt1e1: hwprobe Fix different address spaces
From: Denis Kirjanov <kirjanov@gmail.com>
To: Matei Oprea <eu@opreamatei.ro>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/14, Matei Oprea <eu@opreamatei.ro> wrote:
> Fix different address spaces when unmapping IO. hi->addr_mapped[0]
> and hi->addr_mapped[1] should be tagged __iomem.
>
> Signed-off-by: Matei Oprea <eu@opreamatei.ro>
> Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
> ---
>  drivers/staging/cxt1e1/hwprobe.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/cxt1e1/hwprobe.c
> b/drivers/staging/cxt1e1/hwprobe.c
> index 9b4198b..f55c27e 100644
> --- a/drivers/staging/cxt1e1/hwprobe.c
> +++ b/drivers/staging/cxt1e1/hwprobe.c
> @@ -174,12 +174,12 @@ cleanup_ioremap(void)
>  		if (hi->pci_slot == 0xff)
>  			break;
>  		if (hi->addr_mapped[0]) {
> -			iounmap((void *)(hi->addr_mapped[0]));
> +			iounmap((void __iomem *)(hi->addr_mapped[0]));
>  			release_mem_region((long) hi->addr[0], hi->len[0]);
>  			hi->addr_mapped[0] = 0;
>  		}
>  		if (hi->addr_mapped[1]) {
> -			iounmap((void *)(hi->addr_mapped[1]));
> +			iounmap((void __iomem *)(hi->addr_mapped[1]));
>  			release_mem_region((long) hi->addr[1], hi->len[1]);
>  			hi->addr_mapped[1] = 0;
>  		}

__iomem annotations should be added to the private structure pointers.
Look at the iounmap usage in the drivers.

> --
> 1.7.9.5
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
>


-- 
Regards,
Denis
