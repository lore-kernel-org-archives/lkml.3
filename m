Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab3F3IaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 04:30:25 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:40899 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3F3IaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 04:30:15 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.177.224]
In-Reply-To: <1370034965-29565-1-git-send-email-s-anna@ti.com>
References: <1370034965-29565-1-git-send-email-s-anna@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 30 Jun 2013 11:29:53 +0300
Message-ID: <CAK=WgbazsoK_aBZV+gfvqoya7PkRAkZ4gd-L_e-V5GhN1iAq6A@mail.gmail.com>
Subject: Re: [PATCH 1/3] remoteproc: fix checkpatch errors in remoteproc code
To: Suman Anna <s-anna@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Sat, Jun 1, 2013 at 12:16 AM, Suman Anna <s-anna@ti.com> wrote:
> This patch fixes all the existing checkpatch errors and warnings
> in the remoteproc source files.
>
> Signed-off-by: Suman Anna <s-anna@ti.com>

I'm applying the last three fixes, but ignoring the first two (having
lines that slightly exceed 80 chars isn't too bad and makes the code a
bit more readable).

Thanks,
Ohad.


> ---
>  drivers/remoteproc/remoteproc_core.c     | 6 ++++--
>  drivers/remoteproc/remoteproc_debugfs.c  | 3 +--
>  drivers/remoteproc/remoteproc_internal.h | 4 ++--
>  3 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
> index 022dc63..bc078c0 100644
> --- a/drivers/remoteproc/remoteproc_core.c
> +++ b/drivers/remoteproc/remoteproc_core.c
> @@ -764,7 +764,8 @@ static void rproc_resource_cleanup(struct rproc *rproc)
>
>         /* clean up carveout allocations */
>         list_for_each_entry_safe(entry, tmp, &rproc->carveouts, node) {
> -               dma_free_coherent(dev->parent, entry->len, entry->va, entry->dma);
> +               dma_free_coherent(dev->parent, entry->len, entry->va,
> +                                                               entry->dma);
>                 list_del(&entry->node);
>                 kfree(entry);
>         }
> @@ -922,7 +923,8 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
>
>         /* count the number of notify-ids */
>         rproc->max_notifyid = -1;
> -       ret = rproc_handle_resources(rproc, tablesz, rproc_count_vrings_handler);
> +       ret = rproc_handle_resources(rproc, tablesz,
> +                                               rproc_count_vrings_handler);
>         if (ret)
>                 goto out;
>
> diff --git a/drivers/remoteproc/remoteproc_debugfs.c b/drivers/remoteproc/remoteproc_debugfs.c
> index 157a573..9d30809 100644
> --- a/drivers/remoteproc/remoteproc_debugfs.c
> +++ b/drivers/remoteproc/remoteproc_debugfs.c
> @@ -248,6 +248,5 @@ void __init rproc_init_debugfs(void)
>
>  void __exit rproc_exit_debugfs(void)
>  {
> -       if (rproc_dbg)
> -               debugfs_remove(rproc_dbg);
> +       debugfs_remove(rproc_dbg);
>  }
> diff --git a/drivers/remoteproc/remoteproc_internal.h b/drivers/remoteproc/remoteproc_internal.h
> index 157e762..2f879b0 100644
> --- a/drivers/remoteproc/remoteproc_internal.h
> +++ b/drivers/remoteproc/remoteproc_internal.h
> @@ -107,12 +107,12 @@ struct resource_table *rproc_find_rsc_table(struct rproc *rproc,
>
>  static inline
>  struct resource_table *rproc_find_loaded_rsc_table(struct rproc *rproc,
> -                                const struct firmware *fw)
> +                                                  const struct firmware *fw)
>  {
>         if (rproc->fw_ops->find_loaded_rsc_table)
>                 return rproc->fw_ops->find_loaded_rsc_table(rproc, fw);
>
> -        return NULL;
> +       return NULL;
>  }
>
>  extern const struct rproc_fw_ops rproc_elf_fw_ops;
> --
> 1.8.2
>
