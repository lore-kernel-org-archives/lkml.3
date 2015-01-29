Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbbA2G57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:57:59 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:37409 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbbA2G54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:57:56 -0500
Date: Thu, 29 Jan 2015 17:57:29 +1100 (AEDT)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] g_NCR5380: Kill compiler warning if builtin
In-Reply-To: <1420322416-13960-1-git-send-email-geert@linux-m68k.org>
Message-ID: <alpine.LNX.2.00.1501291551250.7510@nippy.intranet>
References: <1420322416-13960-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Finn Thain <fthain@telegraphics.com.au>

On Sat, 3 Jan 2015, Geert Uytterhoeven wrote:

> If CONFIG_SCSI_GENERIC_NCR5380=y:
> 
> drivers/scsi/g_NCR5380.c:727: warning: ?id_table? defined but not used
> 
> In the non-modular case, MODULE_DEVICE_TABLE() expands to nothing, and
> id_table is not referenced.
> 
> Correct the existing #ifdef to fix this.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/scsi/g_NCR5380.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index f35792f7051c0884..74ec2f5669aba5f5 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -723,7 +723,7 @@ module_param(ncr_53c400a, int, 0);
>  module_param(dtc_3181e, int, 0);
>  MODULE_LICENSE("GPL");
>  
> -#ifndef SCSI_G_NCR5380_MEM
> +#if !defined(SCSI_G_NCR5380_MEM) && defined(MODULE)
>  static struct isapnp_device_id id_table[] = {
>  	{
>  	 ISAPNP_ANY_ID, ISAPNP_ANY_ID,
> 
