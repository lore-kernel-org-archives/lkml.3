Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaBNCvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 21:51:20 -0500
Received: from mail.active-venture.com ([67.228.131.205]:62895 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaBNCvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 21:51:19 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52FD84A6.9000400@roeck-us.net>
Date: Thu, 13 Feb 2014 18:51:18 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Jean Delvare <jdelvare@suse.de>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (ntc_thermistor): Avoid overflow
References: <1392331174-12271-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1392331174-12271-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 02:39 PM, Doug Anderson wrote:
> The ntc thermistor code was doing math whose temporary result might
> have overflowed 32-bits.  We need some casts in there to make it safe.
>
> In one example I found:
> - pullup_uV: 1800000
> - result of iio_read_channel_raw: 3226
> - 1800000 * 3226 => 0x15a1cbc80
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Nice catch. Applied.

Thanks,
Guenter


