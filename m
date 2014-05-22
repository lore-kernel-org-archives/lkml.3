Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaEVPLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:11:35 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:32886 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaEVPLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:11:02 -0400
Date: Thu, 22 May 2014 08:10:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Flavio Leitner <fbl@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Flavio Leitner <fbl@sysclose.org>
Subject: Re: [PATCH] i8k: increase fan limit to 3
Message-ID: <20140522151048.GB1001@roeck-us.net>
References: <1400725168-21358-1-git-send-email-fbl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400725168-21358-1-git-send-email-fbl@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 11:19:28PM -0300, Flavio Leitner wrote:
> From: Flavio Leitner <fbl@sysclose.org>
> 
> It is possible to increase left fan speed on a
> DELL Precision 490n system up to 3.
> 
>     value    fan rpm
>       1      35460
>       2      64740
>       3      78510
> 
> Signed-off-by: Flavio Leitner <fbl@sysclose.org>
> ---
>  drivers/char/i8k.c       | 4 ++--
>  include/uapi/linux/i8k.h | 3 ++-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index d915707..99180f0 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -519,7 +519,7 @@ static ssize_t i8k_hwmon_show_pwm(struct device *dev,
>  	status = i8k_get_fan_status(index);
>  	if (status < 0)
>  		return -EIO;
> -	return sprintf(buf, "%d\n", clamp_val(status * 128, 0, 255));
> +	return sprintf(buf, "%d\n", clamp_val(status * 128, 0, 384));

pwm value range is limited to (0, 255), so we'll have to find another
solution. I think we'll have to define a per-system data structure
which holds the fan speed range and the fan multiplier, and attach it
to the dmi data. Currently, .driver_data is used directly to override
the fan multiplier; it will have to point to a configuration data
structure with both fan multiplier and maximum fan speed value.
Unless someone has a better idea, of course.

Guenter
