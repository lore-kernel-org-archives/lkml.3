Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3IZPk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:40:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3IZPk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:40:57 -0400
Date: Thu, 26 Sep 2013 08:40:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: Re: [char-misc-next 1/7] mei: fix function names in debug prints
Message-ID: <20130926154056.GA15788@kroah.com>
References: <1379364288-16374-1-git-send-email-tomas.winkler@intel.com>
 <1379364288-16374-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379364288-16374-2-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 11:44:42PM +0300, Tomas Winkler wrote:
> From: Alexander Usyskin <alexander.usyskin@intel.com>
> 
> Fix calling function names in debug prints.
> 
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/interrupt.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
> index d27804e..be42c70 100644
> --- a/drivers/misc/mei/interrupt.c
> +++ b/drivers/misc/mei/interrupt.c
> @@ -343,14 +343,14 @@ int mei_irq_read_handler(struct mei_device *dev,
>  
>  	/* decide where to read the message too */
>  	if (!mei_hdr->host_addr) {
> -		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_bus_message.\n");
> +		dev_dbg(&dev->pdev->dev, "call mei_hbm_dispatch.\n");
>  		mei_hbm_dispatch(dev, mei_hdr);
> -		dev_dbg(&dev->pdev->dev, "end mei_irq_thread_read_bus_message.\n");
> +		dev_dbg(&dev->pdev->dev, "end mei_hbm_dispatch.\n");

Stuff like this can just be deleted, use the in-kernel tracing
functionality if you really care about this type of thing.

I'll take this for now, but in the future, just remove these lines
please.

thanks,

greg k-h
