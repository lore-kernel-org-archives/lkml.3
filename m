Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbaDGMib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:38:31 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:40877 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaDGMi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:38:28 -0400
MIME-Version: 1.0
In-Reply-To: <1395576796-17896-1-git-send-email-eu@opreamatei.ro>
References: <1395576796-17896-1-git-send-email-eu@opreamatei.ro>
Date: Mon, 7 Apr 2014 15:38:27 +0300
Message-ID: <CABeAxaf=xC3sTJg88BsC_msm=fbNd6LkxZKySRwugA6S8zcSbA@mail.gmail.com>
Subject: Re: [PATCH] staging: cxt1e1: hwprobe: fix incorrect type in assignment
From: Matei Oprea <eu@opreamatei.ro>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: driverdev <devel@driverdev.osuosl.org>, linux-kernel@vger.kernel.org,
        Matei Oprea <eu@opreamatei.ro>,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments on this ?
ᐧ

On Sun, Mar 23, 2014 at 2:13 PM, Matei Oprea <eu@opreamatei.ro> wrote:
> This patch fixes "incorrect type in argument 1" warning from sparse.
>
> Signed-off-by: Matei Oprea <eu@opreamatei.ro>
> Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
> ---
>  drivers/staging/cxt1e1/hwprobe.c       |    6 +++---
>  drivers/staging/cxt1e1/pmcc4_private.h |    2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
> index 9b4198b..1a145ea 100644
> --- a/drivers/staging/cxt1e1/hwprobe.c
> +++ b/drivers/staging/cxt1e1/hwprobe.c
> @@ -174,12 +174,12 @@ cleanup_ioremap(void)
>                 if (hi->pci_slot == 0xff)
>                         break;
>                 if (hi->addr_mapped[0]) {
> -                       iounmap((void *)(hi->addr_mapped[0]));
> +                       iounmap(hi->addr_mapped[0]);
>                         release_mem_region((long) hi->addr[0], hi->len[0]);
>                         hi->addr_mapped[0] = 0;
>                 }
>                 if (hi->addr_mapped[1]) {
> -                       iounmap((void *)(hi->addr_mapped[1]));
> +                       iounmap(hi->addr_mapped[1]);
>                         release_mem_region((long) hi->addr[1], hi->len[1]);
>                         hi->addr_mapped[1] = 0;
>                 }
> @@ -329,7 +329,7 @@ c4hw_attach_all(void)
>                                 return -ENOMEM;
>                         }
>
> -                       hi->addr_mapped[j] = (unsigned long)ioremap(hi->addr[j], hi->len[j]);
> +                       hi->addr_mapped[j] = ioremap(hi->addr[j], hi->len[j]);
>                         if (!hi->addr_mapped[j]) {
>                                 pr_warning("%s: ioremap fails, addr=0x%lx, len=0x%lx ?\n",
>                                            hi->devname, hi->addr[j], hi->len[j]);
> diff --git a/drivers/staging/cxt1e1/pmcc4_private.h b/drivers/staging/cxt1e1/pmcc4_private.h
> index eb28f09..451f12f 100644
> --- a/drivers/staging/cxt1e1/pmcc4_private.h
> +++ b/drivers/staging/cxt1e1/pmcc4_private.h
> @@ -262,7 +262,7 @@ struct s_hdw_info
>      struct pci_dev *pdev[2];
>
>      unsigned long addr[2];
> -    unsigned long addr_mapped[2];
> +    void __iomem *addr_mapped[2];
>      unsigned long len[2];
>
>      union
> --
> 1.7.9.5
>



-- 
Oprea Matei
