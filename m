Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab3J2XTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:19:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab3J2XTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:19:46 -0400
Date: Tue, 29 Oct 2013 16:19:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 2/8] mei: hbm: validate client index is not
 exceeding allocated array size
Message-ID: <20131029231945.GB30410@kroah.com>
References: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
 <1382382343-12066-3-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382382343-12066-3-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 10:05:37PM +0300, Tomas Winkler wrote:
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/hbm.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
> index 9b3a0fb..0f5e8ca 100644
> --- a/drivers/misc/mei/hbm.c
> +++ b/drivers/misc/mei/hbm.c
> @@ -228,8 +228,6 @@ static int mei_hbm_prop_req(struct mei_device *dev)
>  	unsigned long client_num;
>  
>  
> -	client_num = dev->me_client_presentation_num;
> -
>  	next_client_index = find_next_bit(dev->me_clients_map, MEI_CLIENTS_MAX,
>  					  dev->me_client_index);
>  
> @@ -241,6 +239,10 @@ static int mei_hbm_prop_req(struct mei_device *dev)
>  		return 0;
>  	}
>  
> +	client_num = dev->me_client_presentation_num;
> +	if (WARN_ON(dev->me_clients_num <= client_num))
> +		return -EIO;

How can this happen?  Why is spitting out a huge warning in the syslog
going to help anything?  If a user can do this, then great, now you can
DoS your syslog :(

If a user can't do this, then why tell them, it's your driver's bug that
you should just fix.

greg k-h
