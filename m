Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab3DOVIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:08:41 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35000 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab3DOVIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:08:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130415080720.GB1994@udknight>
References: <20130415080720.GB1994@udknight>
Date: Mon, 15 Apr 2013 14:08:40 -0700
X-Google-Sender-Auth: CiXpf4AM-S6ZO40OtiE4yoiOgXI
Message-ID: <CAE9FiQU7N29OzXC84yyrfRo-Y8BpWmbVmOb2r=wByK_P-cF-0g@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86:aperture_64: code pattern clean
From: Yinghai Lu <yinghai@kernel.org>
To: Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 1:07 AM, Wang YanQing <udknight@gmail.com> wrote:
>
> This patch don't change code function,
> it just do prepare for import the
> memblock_alloc_in_range to do the code pattern
> which looks like below in one function:
>
> memblock_find_in_range()
> follow by
> memblock_reserve()
>
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  arch/x86/kernel/aperture_64.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> index d5fd66f..1523e75 100644
> --- a/arch/x86/kernel/aperture_64.c
> +++ b/arch/x86/kernel/aperture_64.c
> @@ -85,9 +85,9 @@ static u32 __init allocate_aperture(void)
>          * memory. Unfortunately we cannot move it up because that would
>          * make the IOMMU useless.
>          */
> -       addr = memblock_find_in_range(GART_MIN_ADDR, GART_MAX_ADDR,
> +       addr = memblock_find_in_range(GART_MIN_ADDR, GART_MAX_ADDR - aper_size,

this change is wrong.

>                                       aper_size, aper_size);
> -       if (!addr || addr + aper_size > GART_MAX_ADDR) {
> +       if (!addr) {

could just drop not needed checking of
    addr + aper_size > GART_MAX_ADDR


Thanks

Yinghai
