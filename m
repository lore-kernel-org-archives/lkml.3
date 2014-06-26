Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaFZWfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 18:35:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaFZWf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 18:35:26 -0400
Date: Fri, 27 Jun 2014 00:35:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Himangi Saraogi <himangi774@gmail.com>
cc: Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] HID: roccat: Drop cast
In-Reply-To: <20140626172852.GA2878@himangi-Dell>
Message-ID: <alpine.LNX.2.00.1406270035140.21386@pobox.suse.cz>
References: <20140626172852.GA2878@himangi-Dell>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014, Himangi Saraogi wrote:

> This patch removes the cast on data of type void* as it is not needed.
> The following Coccinelle semantic patch was used for making the change:
> 
> @r@
> expression x;
> void* e;
> type T;
> identifier f;
> @@
> 
> (
>   *((T *)e)
> |
>   ((T *)x)[...]
> |
>   ((T *)x)->f
> |
> - (T *)
>   e
> )
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
>  drivers/hid/hid-roccat-lua.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-roccat-lua.c b/drivers/hid/hid-roccat-lua.c
> index 6adc0fa..65e2e76 100644
> --- a/drivers/hid/hid-roccat-lua.c
> +++ b/drivers/hid/hid-roccat-lua.c
> @@ -61,7 +61,7 @@ static ssize_t lua_sysfs_write(struct file *fp, struct kobject *kobj,
>  		return -EINVAL;
>  
>  	mutex_lock(&lua->lua_lock);
> -	retval = roccat_common2_send(usb_dev, command, (void *)buf, real_size);
> +	retval = roccat_common2_send(usb_dev, command, buf, real_size);
>  	mutex_unlock(&lua->lua_lock);

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
