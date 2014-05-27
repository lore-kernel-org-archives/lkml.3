Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaE0CJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 22:09:53 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:59380 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaE0CJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 22:09:51 -0400
Date: Mon, 26 May 2014 19:09:48 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: Re: [PATCH] Input: atmel_mxt_ts - fix build error in
 mxt_read_t9_resolution
Message-ID: <20140527020948.GD12890@core.coreip.homeip.net>
References: <1400578011-20635-1-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400578011-20635-1-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 10:26:51AM +0100, Nick Dyer wrote:
> Stephen Rothwell reports this build error:
> 
> drivers/input/touchscreen/atmel_mxt_ts.c: In function 'mxt_read_t9_resolution':
> drivers/input/touchscreen/atmel_mxt_ts.c:1043:2: warning: passing argument 1 of '__swab16s' makes pointer from integer without a cast [enabled by default]
>   le16_to_cpus(range.x);
>   ^
> 
> I believe this is a correct fix.
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index d8ea3ed..97495c7 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -1040,8 +1040,8 @@ static int mxt_read_t9_resolution(struct mxt_data *data)
>  	if (error)
>  		return error;
>  
> -	le16_to_cpus(range.x);
> -	le16_to_cpus(range.y);
> +	le16_to_cpus(&range.x);
> +	le16_to_cpus(&range.y);
>  
>  	error =  __mxt_read_reg(client,
>  				object->start_address + MXT_T9_ORIENT,
> -- 
> 1.8.3.2
> 

Thank you, I folded it into the offending patch.

-- 
Dmitry
