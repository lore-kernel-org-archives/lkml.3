Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935460Ab3DPCrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 22:47:40 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:49454 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935183Ab3DPCrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 22:47:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130416014411.GA14671@udknight>
References: <20130416014411.GA14671@udknight>
Date: Mon, 15 Apr 2013 19:47:38 -0700
X-Google-Sender-Auth: 5n5Fn7KtEO_snbFlacNDy5x8wfs
Message-ID: <CAE9FiQUtvgB6zO9uqDQeC8K1kdH5uCwXkagAYUEEoF+Z+QHTdw@mail.gmail.com>
Subject: Re: [PATCH]drivers:acpi: Fix wrong parameter passed to memblock_reserve
From: Yinghai Lu <yinghai@kernel.org>
To: Wang YanQing <udknight@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Renninger <trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 6:44 PM, Wang YanQing <udknight@gmail.com> wrote:
>
> The parameter of memblock_reserve is start address,
> and size, not address range.
>
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  drivers/acpi/osl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 586e7e9..bcb7a3b 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -641,7 +641,7 @@ void __init acpi_initrd_override(void *data, size_t size)
>          * Both memblock_reserve and e820_add_region (via arch_reserve_mem_area)
>          * works fine.
>          */
> -       memblock_reserve(acpi_tables_addr, acpi_tables_addr + all_tables_size);
> +       memblock_reserve(acpi_tables_addr, all_tables_size);
>         arch_reserve_mem_area(acpi_tables_addr, all_tables_size);

Acked-by: Yinghai Lu <yinghai@kernel.org>

And it should go to stable for v3.8
