Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab3KZS6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:58:38 -0500
Received: from mail.active-venture.com ([67.228.131.205]:54745 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab3KZS6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:58:34 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <5294EF58.7040905@roeck-us.net>
Date: Tue, 26 Nov 2013 10:58:32 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Wim Van Sebroeck <wim@iguana.be>
CC: Fabio Porcedda <fabio.porcedda@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] watchdog: core: Make dt "timeout-sec" property work
 on drivers w/out min/max
References: <1385490173-7511-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1385490173-7511-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 10:22 AM, Doug Anderson wrote:
> It is valid for a watchdog driver to have 0 for a "min" and "max"
> timeout if the driver doesn't need the core to enforce the concepts of
> min and max.  The s3c2410_wdt driver is one such driver.  Specifically
> it can be hard for that driver to come up with a static "max" on all
> platforms without a lot more information since the input clock on
> S3C2410 and S3C2440 can change with DVFS.
>
> As written, watchdog_init_timeout() will not ever read "timeout-sec"
> on these drivers since watchdog_timeout_invalid() will _never_ return
> true.  Change to not consider a timeout_parm of 0 as valid even if
> min/max aren't specified by the driver.  Also handle the case when
> there is no min/max and no "timeout-sec" property.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Makes sense to me.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Guenter


