Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbaDHDyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 23:54:50 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:51329 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbaDHDys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 23:54:48 -0400
MIME-Version: 1.0
In-Reply-To: <1396563423-30893-15-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
	<1396563423-30893-15-git-send-email-robherring2@gmail.com>
Date: Tue, 8 Apr 2014 07:54:48 +0400
Message-ID: <CAMo8Bf+2TeKoW76FJY6=GgB05UFW11fX1MuwqyLEMQbcNoL8Mg@mail.gmail.com>
Subject: Re: [PATCH 14/20] of/fdt: use libfdt accessors for header data
From: Max Filippov <jcmvbkbc@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Fri, Apr 4, 2014 at 2:16 AM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <robh@kernel.org>
>
> With libfdt support, we can take advantage of helper accessors in libfdt
> for accessing the FDT header data. This makes the code more readable and
> makes the FDT blob structure more opaque to the kernel. This also
> prepares for removing struct boot_param_header completely.
>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  drivers/of/fdt.c       | 27 ++++++++++++---------------
>  include/linux/of_fdt.h |  8 ++++----
>  2 files changed, 16 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index ee8853c..dc5f233 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
[...]
> @@ -902,9 +900,8 @@ void __init unflatten_and_copy_device_tree(void)
>                 return;
>         }
>
> -       size = __be32_to_cpu(initial_boot_params->totalsize);
> -       dt = early_init_dt_alloc_memory_arch(size,
> -               __alignof__(struct boot_param_header));
> +       size = fdt_totalsize(initial_boot_params);
> +       dt = early_init_dt_alloc_memory_arch(size, FDT_V17_SIZE);

This change triggers BUG_ON(align & (align - 1)) in the alloc_bootmem_bdata()
on xtensa.

-- 
Thanks.
-- Max
