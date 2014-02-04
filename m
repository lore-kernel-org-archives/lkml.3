Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936011AbaBDWdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:33:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964840AbaBDWdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 17:33:13 -0500
Date: Tue, 4 Feb 2014 14:34:19 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] raw: test against runtime value of max_raw_minors
Message-ID: <20140204223419.GB2696@kroah.com>
References: <1391552592.13156.15.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391552592.13156.15.camel@x220>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 11:23:12PM +0100, Paul Bolle wrote:
> bind_get() checks the device number it is called with. It uses
> MAX_RAW_MINORS for the upper bound. But MAX_RAW_MINORS is set at compile
> time while the actual number of raw devices can be set at runtime. This
> means the test can either be too strict or too lenient. And if the test
> ends up being too lenient bind_get() might try to access memory beyond
> what was allocated for "raw_devices".
> 
> So check against the runtime value (max_raw_minors) in this function.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  drivers/char/raw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/raw.c b/drivers/char/raw.c
> index f3223aa..6e8d65e 100644
> --- a/drivers/char/raw.c
> +++ b/drivers/char/raw.c
> @@ -190,7 +190,7 @@ static int bind_get(int number, dev_t *dev)
>  	struct raw_device_data *rawdev;
>  	struct block_device *bdev;
>  
> -	if (number <= 0 || number >= MAX_RAW_MINORS)
> +	if (number <= 0 || number >= max_raw_minors)

Are you sure?  For some reason, I thought this was changed to be this
way a long time ago, can you please dig through the git archives, and
even the history.git tree, to verify that this is correct and you aren't
just making this be as it was before?

thanks,

greg k-h
