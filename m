Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaAMXvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:51:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaAMXv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:51:29 -0500
Date: Mon, 13 Jan 2014 15:52:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Borg <cyborg101010@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: das1800: Fixing foo * bar should be foo
 *bar
Message-ID: <20140113235205.GA22441@kroah.com>
References: <1389655155-20071-1-git-send-email-cyborg101010@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389655155-20071-1-git-send-email-cyborg101010@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 11:19:15PM +0000, Joe Borg wrote:
> Fixed an error flagged by checkpatch.pl, 'foo * bar should be foo
> *bar' in the parameters of function munge_data().
> 
> Signed-off-by: Joe Borg <cyborg101010@gmail.com>
> ---
>  drivers/staging/comedi/drivers/das1800.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
> index 1880038..8fb87df 100644
> --- a/drivers/staging/comedi/drivers/das1800.c
> +++ b/drivers/staging/comedi/drivers/das1800.c
> @@ -462,7 +462,7 @@ static inline uint16_t munge_bipolar_sample(const struct comedi_device *dev,
>  	return sample;
>  }
>  
> -static void munge_data(struct comedi_device *dev, uint16_t * array,
> +static void munge_data(struct comedi_device *dev, uint16_t *array,
>  		       unsigned int num_elements)

Ok, after all that work, it turns out I can't even apply this patch as
someone else did it already a while ago.  You should be working off of
linux-next, or my staging.git tree, not Linus's tree, as that does not
contain all of the work we are doing on the next version of linux (hence
the -next).

So, care to try again with a different fix?

thanks,

greg k-h
