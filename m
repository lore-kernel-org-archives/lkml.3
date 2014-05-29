Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852AbaE2Tjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:39:33 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35118 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781AbaE2Tjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:39:31 -0400
Message-ID: <53878CFC.2090506@kernel.dk>
Date: Thu, 29 May 2014 13:39:40 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org
Subject: Re: block: remove dead code in scsi_ioctl:blk_verify_command
References: <20140529191130.GA10405@redhat.com>
In-Reply-To: <20140529191130.GA10405@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 01:11 PM, Dave Jones wrote:
> filter gets assigned the address of blk_default_cmd_filter on
> entry to this function, so the !filter condition can never be true.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 26487972ac54..9c28a5b38042 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -205,10 +205,6 @@ int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm)
>  	if (capable(CAP_SYS_RAWIO))
>  		return 0;
>  
> -	/* if there's no filter set, assume we're filtering everything out */
> -	if (!filter)
> -		return -EPERM;
> -
>  	/* Anybody who can open the device can do a read-safe command */
>  	if (test_bit(cmd[0], filter->read_ok))
>  		return 0;

Thanks Dave, applied.

-- 
Jens Axboe

