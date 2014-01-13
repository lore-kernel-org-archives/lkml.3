Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaAMVKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 16:10:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaAMVKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 16:10:18 -0500
Date: Mon, 13 Jan 2014 13:10:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Borg <cyborg101010@gmail.com>
Cc: dan.carpenter@oracle.com, abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AlarmDev: Changing is_wakeup() to be a function to pass
 checkpatch
Message-ID: <20140113211055.GB17131@kroah.com>
References: <1389643836-6170-1-git-send-email-cyborg101010@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389643836-6170-1-git-send-email-cyborg101010@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 08:10:36PM +0000, Joe Borg wrote:
> Signed-off-by Joe Borg <cyborg101010@gmail.com>
> ---
>  drivers/staging/android/alarm-dev.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
> index 647694f..87f2a02 100644
> --- a/drivers/staging/android/alarm-dev.c
> +++ b/drivers/staging/android/alarm-dev.c
> @@ -66,13 +66,15 @@ static struct devalarm alarms[ANDROID_ALARM_TYPE_COUNT];
>   *
>   * Return: 1 if this is a wakeup alarm, otherwise 0
>   */
> -static int is_wakeup(enum android_alarm_type type)
> +static int is_wakeup(enum andriod_alarm_type type)

Always build test your patches, this one wasn't.

>  {
> -	return (type == ANDROID_ALARM_RTC_WAKEUP ||
> -		type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP);
> +	if (type == ANDROID_ALARM_RTC_WAKEUP ||
> +	    type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP)
> +		return 1;
> +	else
> +		return 0;

Why are you making this change?  There is no logic change here at all.

>  }
>  
> -

Why remove this line?

Again, you are going to need changelog comments for any patch, please
redo them properly if you wish us to accept your patches.

thanks,

greg k-h
