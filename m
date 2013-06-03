Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3FCKSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:18:04 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:48361 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081Ab3FCKSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:18:00 -0400
Date: Mon, 3 Jun 2013 11:17:56 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, matt.fleming@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi, pstore: Cocci spatch "memdup.spatch"
Message-ID: <20130603101756.GH2004@console-pimps.org>
References: <1370079602.29224.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370079602.29224.8.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Jun, at 11:40:02AM, Thomas Meyer wrote:
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -79,10 +79,9 @@ static int efi_pstore_read_func(struct e
>  			   &entry->var.DataSize, entry->var.Data);
>  	size = entry->var.DataSize;
>  
> -	*cb_data->buf = kmalloc(size, GFP_KERNEL);
> +	*cb_data->buf = kmemdup(entry->var.Data, size, GFP_KERNEL);
>  	if (*cb_data->buf == NULL)
>  		return -ENOMEM;
> -	memcpy(*cb_data->buf, entry->var.Data, size);
>  	return size;
>  }

Who wants to pick this one up? Tony?

-- 
Matt Fleming, Intel Open Source Technology Center
