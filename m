Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934454Ab3CHRqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 12:46:30 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:43618 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab3CHRq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 12:46:28 -0500
Date: Fri, 8 Mar 2013 09:47:01 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jens Taprogge <jens.taprogge@taprogge.org>
Subject: Re: [PATCH 1/3] ipack: avoid double free on device->id
Message-ID: <20130308174701.GA13276@kroah.com>
References: <512DCB33.6030500@igalia.com>
 <1362730907-10047-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362730907-10047-1-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 09:21:45AM +0100, Samuel Iglesias Gonsalvez wrote:
> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> ---
>  drivers/ipack/ipack.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c
> index 7ec6b20..599d4ff 100644
> --- a/drivers/ipack/ipack.c
> +++ b/drivers/ipack/ipack.c
> @@ -24,6 +24,7 @@ static void ipack_device_release(struct device *dev)
>  {
>  	struct ipack_device *device = to_ipack_dev(dev);
>  	kfree(device->id);
> +	device->id = NULL;

How does that keep anything from being freed twice?

>  	device->release(device);

device should now be gone after this call, right?  What am I missing?

thanks,

greg k-h
