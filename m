Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934256Ab3CZNVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:21:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43036 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933848Ab3CZNVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:21:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: acpi: Used PTR_RET function
Date: Tue, 26 Mar 2013 14:28:34 +0100
Message-ID: <1860843.rMdcvsu2GA@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1363077171-30141-1-git-send-email-gheorghiuandru@gmail.com>
References: <1363077171-30141-1-git-send-email-gheorghiuandru@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 12, 2013 10:32:51 AM Alexandru Gheorghiu wrote:
> Used PTR_RET function instead of explicit checking with IS_ERR.
> 
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>

Applied to linux-pm.git/linux-next.

Thanks,
Rafael


> ---
>  drivers/acpi/acpi_pad.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
> index 31de104..27bb6a9 100644
> --- a/drivers/acpi/acpi_pad.c
> +++ b/drivers/acpi/acpi_pad.c
> @@ -236,7 +236,7 @@ static int create_power_saving_task(void)
>  	ps_tsks[ps_tsk_num] = kthread_run(power_saving_thread,
>  		(void *)(unsigned long)ps_tsk_num,
>  		"acpi_pad/%d", ps_tsk_num);
> -	rc = IS_ERR(ps_tsks[ps_tsk_num]) ? PTR_ERR(ps_tsks[ps_tsk_num]) : 0;
> +	rc = PTR_RET(ps_tsks[ps_tsk_num]);
>  	if (!rc)
>  		ps_tsk_num++;
>  	else
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
