Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbaF3HzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 03:55:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbaF3HzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 03:55:00 -0400
Date: Mon, 30 Jun 2014 09:54:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel@vger.kernel.org, bonbons@linux-vserver.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/hid/hid-picolcd_debugfs.c: remove unnecessary
 NULL test before debugfs_remove
In-Reply-To: <1403962503-8507-1-git-send-email-fabf@skynet.be>
Message-ID: <alpine.LNX.2.00.1406300954510.28307@pobox.suse.cz>
References: <1403962503-8507-1-git-send-email-fabf@skynet.be>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2014, Fabian Frederick wrote:

> Fix checkpatch warning:
> WARNING: debugfs_remove(NULL) is safe this check is probably not required
> 
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/hid/hid-picolcd_debugfs.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/hid/hid-picolcd_debugfs.c b/drivers/hid/hid-picolcd_debugfs.c
> index 024cdf3..3c13af6 100644
> --- a/drivers/hid/hid-picolcd_debugfs.c
> +++ b/drivers/hid/hid-picolcd_debugfs.c
> @@ -883,16 +883,13 @@ void picolcd_exit_devfs(struct picolcd_data *data)
>  
>  	dent = data->debug_reset;
>  	data->debug_reset = NULL;
> -	if (dent)
> -		debugfs_remove(dent);
> +	debugfs_remove(dent);
>  	dent = data->debug_eeprom;
>  	data->debug_eeprom = NULL;
> -	if (dent)
> -		debugfs_remove(dent);
> +	debugfs_remove(dent);
>  	dent = data->debug_flash;
>  	data->debug_flash = NULL;
> -	if (dent)
> -		debugfs_remove(dent);
> +	debugfs_remove(dent);
>  	mutex_destroy(&data->mutex_flash);
>  }

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
