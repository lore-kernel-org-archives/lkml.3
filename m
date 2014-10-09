Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbaJII4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:56:32 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:41409 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaJII40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:56:26 -0400
MIME-Version: 1.0
In-Reply-To: <1412695544-17251-2-git-send-email-cristian.stoica@freescale.com>
References: <1412695544-17251-1-git-send-email-cristian.stoica@freescale.com>
	<1412695544-17251-2-git-send-email-cristian.stoica@freescale.com>
Date: Thu, 9 Oct 2014 10:56:24 +0200
Message-ID: <CAFLxGvxygJY_dQte+wHqWauDYx=datvgX5Z_ckP4znUiPno5Yw@mail.gmail.com>
Subject: Re: [PATCH 2/2] uio: support memory sizes larger than 32 bits
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Cristian Stoica <cristian.stoica@freescale.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 5:25 PM, Cristian Stoica
<cristian.stoica@freescale.com> wrote:
> This is a completion to 27a90700a4275c5178b883b65927affdafa5185c
> The size field is also increased to allow values larger than 32 bits
> on platforms that have more than 32 bit physical addresses.
>
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
> ---
>  Documentation/DocBook/uio-howto.tmpl | 2 +-
>  drivers/uio/uio.c                    | 2 +-
>  include/linux/uio_driver.h           | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
> index bbe9c1f..1fdc246 100644
> --- a/Documentation/DocBook/uio-howto.tmpl
> +++ b/Documentation/DocBook/uio-howto.tmpl
> @@ -540,7 +540,7 @@ appears in sysfs.
>  </para></listitem>
>
>  <listitem><para>
> -<varname>unsigned long size</varname>: Fill in the size of the
> +<varname>resource_size_t size</varname>: Fill in the size of the
>  memory block that <varname>addr</varname> points to. If <varname>size</varname>
>  is zero, the mapping is considered unused. Note that you
>  <emphasis>must</emphasis> initialize <varname>size</varname> with zero for
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index a673e5b..eaa7347 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -73,7 +73,7 @@ static ssize_t map_addr_show(struct uio_mem *mem, char *buf)
>
>  static ssize_t map_size_show(struct uio_mem *mem, char *buf)
>  {
> -       return sprintf(buf, "0x%lx\n", mem->size);
> +       return sprintf(buf, "0x%llx\n", (unsigned long long)mem->size);

We have special printk format strings to handle resource_size_t, please
see Documentation/printk-formats.txt.

>  }
>
>  static ssize_t map_offset_show(struct uio_mem *mem, char *buf)
> diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
> index 1ad4724..df6e42e 100644
> --- a/include/linux/uio_driver.h
> +++ b/include/linux/uio_driver.h
> @@ -35,7 +35,7 @@ struct uio_map;
>  struct uio_mem {
>         const char              *name;
>         phys_addr_t             addr;
> -       unsigned long           size;
> +       resource_size_t         size;
>         int                     memtype;
>         void __iomem            *internal_addr;
>         struct uio_map          *map;
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
