Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab3ANRR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:17:29 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39612 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756606Ab3ANRR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:17:28 -0500
Message-ID: <1358183857.19400.13.camel@joe-AO722>
Subject: Re: [PATCH 04/18] power: ab8500_fg: Replace msleep() with
 usleep_range() for greater accuracy
From: Joe Perches <joe@perches.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Date: Mon, 14 Jan 2013 09:17:37 -0800
In-Reply-To: <1357909986-9262-5-git-send-email-lee.jones@linaro.org>
References: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
	 <1357909986-9262-5-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-11 at 13:12 +0000, Lee Jones wrote:
> Doing so provides a greater degree of accuracy when dealing with
> time-frames between 1us and 20ms. msleep() is only accurate for
> wake-ups greater than 20ms.
[]
> diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
[]
> @@ -956,7 +956,7 @@ static int ab8500_fg_load_comp_volt_to_capacity(struct ab8500_fg *di)
>  	do {
>  		vbat += ab8500_fg_bat_voltage(di);
>  		i++;
> -		msleep(5);
> +		usleep_range(5000, 5001);

If you're going to give a range that small
you might as well use usleep instead.

Otherwise, add some tolerance to allow any
other coalesced wakeup to occur.


