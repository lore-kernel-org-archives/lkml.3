Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab3FFWAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 18:00:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3FFWAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 18:00:51 -0400
Date: Thu, 6 Jun 2013 14:57:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Laura Lawniczak <laura.lawniczak@googlemail.com>
Cc: devel@driverdev.osuosl.org, Kurt Kanzenbach <shifty91@gmail.com>,
        linux-kernel@i4.cs.fau.de, Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        linux-kernel@vger.kernel.org, Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>
Subject: Re: [PATCH 1/1] keucr: restored lost line
Message-ID: <20130606215721.GA24059@kroah.com>
References: <20130606201631.GB14773@kroah.com>
 <1370551851-13456-1-git-send-email-laura.lawniczak@googlemail.com>
 <1370551851-13456-2-git-send-email-laura.lawniczak@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370551851-13456-2-git-send-email-laura.lawniczak@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 10:50:51PM +0200, Laura Lawniczak wrote:
> This line was unfortunately removed during patch process. This caused an
> "unused variable" warning and may cause other unintended effects.
> So here it is again.
> 
> Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>
> ---
>  drivers/staging/keucr/transport.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/keucr/transport.c b/drivers/staging/keucr/transport.c
> index 1f9ea58..c47a035 100644
> --- a/drivers/staging/keucr/transport.c
> +++ b/drivers/staging/keucr/transport.c
> @@ -131,6 +131,7 @@ static void usb_stor_print_cmd(struct us_data *us, struct scsi_cmnd *srb)
>  		break;
>  	}
>  	bn = 0;
> +	blen = 0;

Really?  If it's unused, why do you want to set it to something?  Any
why is bn set to 0 at the end of the function as well?

Shouldn't both of these lines be removed, and the variable itself
removed too?

thanks,

greg k-h
