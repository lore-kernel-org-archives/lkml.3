Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098Ab3BMWq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 17:46:57 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:34915 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750888Ab3BMWq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 17:46:56 -0500
Date: Wed, 13 Feb 2013 23:46:47 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, fabio.porcedda@gmail.com, JM.Lin@atmel.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/8] watchdog: add the function watchdog_is_open
Message-ID: <20130213224647.GC7867@spo001.leaseweb.com>
References: <1359702386-21284-1-git-send-email-wenyou.yang@atmel.com> <1359702386-21284-2-git-send-email-wenyou.yang@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359702386-21284-2-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wenyou,

> Add the function watchdog_is_open to check whether or not
> the /dev/watchdog? is opened
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Cc: wim@iguana.be
> Cc: linux-watchdog@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/linux/watchdog.h |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
> index e40cc2b..7ea4465 100644
> --- a/include/linux/watchdog.h
> +++ b/include/linux/watchdog.h
> @@ -111,6 +111,14 @@ static inline bool watchdog_active(struct watchdog_device *wdd)
>  	return test_bit(WDOG_ACTIVE, &wdd->status);
>  }
>  
> +/* Use the following function to check whether or not
> + * the /dev/watchdog? is opened
> + */
> +static inline bool watchdog_is_open(struct watchdog_device *wddev)
> +{
> +	return test_bit(WDOG_DEV_OPEN, &wddev->status);
> +}
> +
>  /* Use the following function to set the nowayout feature */
>  static inline void watchdog_set_nowayout(struct watchdog_device *wdd, bool nowayout)
>  {

NAK, this is not good. You should use watchdog_active instead.
Reason: your device could have been opened as for instance /dev/watchdog0.

Kind regards,
Wim.
