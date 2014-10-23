Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335AbaJWAUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 20:20:08 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:48426 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbaJWAUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 20:20:06 -0400
MIME-Version: 1.0
In-Reply-To: <1414022989-23035-1-git-send-email-gregory.0xf0@gmail.com>
References: <1414022989-23035-1-git-send-email-gregory.0xf0@gmail.com>
From: Gregory Fong <gregory.0xf0@gmail.com>
Date: Wed, 22 Oct 2014 17:19:33 -0700
Message-ID: <CADtm3G7UwHW34vP_067d7cZZ74bBGqtdHGZQjvO-0-gs-5YnRg@mail.gmail.com>
Subject: Re: [PATCH] mm: cma: Use %pa to avoid truncating the physical address
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replying to change to use the real linux-mm list on CC (sorry for the noise!)

On Wed, Oct 22, 2014 at 5:09 PM, Gregory Fong <gregory.0xf0@gmail.com> wrote:
> From: Kevin Cernekee <cernekee@gmail.com>
>
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> [gregory.0xf0@gmail.com: rebased from 3.14 and updated commit message]
> Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>
> ---
>  mm/cma.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index 963bc4a..154efb0 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -288,8 +288,8 @@ int __init cma_declare_contiguous(phys_addr_t base,
>         if (ret)
>                 goto err;
>
> -       pr_info("Reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
> -               (unsigned long)base);
> +       pr_info("Reserved %ld MiB at %pa\n", (unsigned long)size / SZ_1M,
> +               &base);
>         return 0;
>
>  err:
> --
> 1.9.1
>
