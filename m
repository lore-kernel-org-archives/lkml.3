Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab3DAThY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:37:24 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57103 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763Ab3DAThX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:37:23 -0400
Date: Mon, 1 Apr 2013 12:37:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: jhovold@gmail.com, Jiri Slaby <jslaby@suse.cz>, mferrell@uplogix.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: USB: mos7840: looping issue: avoid the return value overriden by
 looping
Message-ID: <20130401193721.GA13712@kroah.com>
References: <5158F689.5040406@asianux.com>
 <20130401030555.GA21113@kroah.com>
 <5159041F.7020608@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5159041F.7020608@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 11:50:55AM +0800, Chen Gang wrote:
> 
>   inside the 'for' looping:
>     the return value 'rv' may override if not have a check in time.
> 
>   next checking, outside the 'for' looping:
>     can not find failure which generated during the 'for' looping
> 
>   so need let outside know about the failure.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  drivers/usb/serial/mos7840.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
> index a0d5ea5..13aae1e 100644
> --- a/drivers/usb/serial/mos7840.c
> +++ b/drivers/usb/serial/mos7840.c
> @@ -651,7 +651,9 @@ static void mos7840_interrupt_callback(struct urb *urb)
>  					wreg = MODEM_STATUS_REGISTER;
>  					break;
>  				}
> -				rv = mos7840_get_reg(mos7840_port, wval, wreg, &Data);
> +				if (mos7840_get_reg(mos7840_port, wval,
> +				    wreg, &Data) < 0)
> +					rv = -1;

Please use a "real" error value, or even better yet, use the error value
returned from the call here.

And please identify the driver you are modifying in the Subject: line,
like I have changed this one to.

thanks,

greg k-h
