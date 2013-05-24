Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab3EXDUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 23:20:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60417 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759901Ab3EXDUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 23:20:32 -0400
MIME-Version: 1.0
In-Reply-To: <519ECEF1.9060804@huawei.com>
References: <519ECEF1.9060804@huawei.com>
From: Santosh Y <santoshsy@gmail.com>
Date: Fri, 24 May 2013 08:50:10 +0530
Message-ID: <CALMYJDua65PKyC4R+RdX8TxX8JFw3LX4h8dxxcExyiUboMwCvg@mail.gmail.com>
Subject: Re: [PATCH] scsi: megaraid: check kzalloc
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: megaraidlinux@lsi.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kashyap.desai@lsi.com, aradford@gmail.com,
        Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 7:52 AM, Libo Chen <clbchenlibo.chen@huawei.com> wrote:
>
> we should check kzalloc, avoid to hit oops
>
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/scsi/megaraid.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 846f475..195b095 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -4162,6 +4162,10 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
>
>         sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
>         scmd->device = sdev;
                              ^^^^^^
I guess assigning after the NULL check of 'sdev' is more appropriate.

> +       if (!scmd->device) {
> +               scsi_free_command(GFP_KERNEL, scmd);
> +               return -ENOMEM;
> +       }
>
>         memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
>         scmd->cmnd = adapter->int_cdb;
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
~Santosh
