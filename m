Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab3KTVEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:04:16 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:60253 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab3KTVEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:04:14 -0500
MIME-Version: 1.0
In-Reply-To: <1384978295-18292-1-git-send-email-msw@linux.com>
References: <1384978295-18292-1-git-send-email-msw@linux.com>
Date: Wed, 20 Nov 2013 13:04:14 -0800
Message-ID: <CA+aC4ktbsP4zQSP6Urn=25-F4CHWBXSKStis--K-N7wASj4O0A@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH] xen/gnttab: leave lazy MMU mode in the case
 of a m2p override failure
From: Anthony Liguori <anthony@codemonkey.ws>
To: Matt Wilson <msw@linux.com>
Cc: xen-devel@lists.xenproject.org, Matt Wilson <msw@amazon.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>,
        Anthony Liguori <aliguori@amazon.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 12:11 PM, Matt Wilson <msw@linux.com> wrote:
> From: Matt Wilson <msw@amazon.com>
>
> Commit f62805f1 introduced a bug where lazy MMU mode isn't exited if a
> m2p_add/remove_override call fails.
>
> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: Anthony Liguori <aliguori@amazon.com>
> Cc: xen-devel@lists.xenproject.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Matt Wilson <msw@amazon.com>

Reviewed-by: Anthony Liguori <aliguori@amazon.com>

Regards,

Anthony Liguori

> ---
>  drivers/xen/grant-table.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 62ccf54..0283871 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -930,9 +930,10 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>                 ret = m2p_add_override(mfn, pages[i], kmap_ops ?
>                                        &kmap_ops[i] : NULL);
>                 if (ret)
> -                       return ret;
> +                       goto out;
>         }
>
> + out:
>         if (lazy)
>                 arch_leave_lazy_mmu_mode();
>
> @@ -969,9 +970,10 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
>                 ret = m2p_remove_override(pages[i], kmap_ops ?
>                                        &kmap_ops[i] : NULL);
>                 if (ret)
> -                       return ret;
> +                       goto out;
>         }
>
> + out:
>         if (lazy)
>                 arch_leave_lazy_mmu_mode();
>
> --
> 1.7.9.5
>
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
