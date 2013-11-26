Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab3KZSPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:15:06 -0500
Received: from mail.active-venture.com ([67.228.131.205]:53145 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830Ab3KZSPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:15:00 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <5294E51E.60907@roeck-us.net>
Date: Tue, 26 Nov 2013 10:14:54 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Wim Van Sebroeck <wim@iguana.be>
CC: Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] watchdog: s3c2410_wdt: Only register for cpufreq on
 ARM_S3C24XX_CPUFREQ
References: <1385420137-32725-1-git-send-email-dianders@chromium.org> <1385422603-22684-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1385422603-22684-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 03:36 PM, Doug Anderson wrote:
> On modern SoCs the watchdog timer is parented on a clock that doesn't
> change every time we have a cpufreq change.  That means we don't need
> to constantly adjust the watchdog timer, so avoid registering for and
> dealing with cpufreq transitions unless we've actually got
> CONFIG_ARM_S3C24XX_CPUFREQ defined.
>
> Note that this is more than just an optimization.  The s3c2410
> watchdog driver actually pats the watchdog on every CPU frequency
> change.  On modern systems these happen many times per second (even in
> a system where "nothing" is happening).  That effectively makes any
> userspace watchdog program useless (the watchdog is constantly patted
> by the kernel).  If we need ARM_S3C24XX_CPUFREQ defined on a
> multiplatform kernel we'll need to make sure that kernel supports
> common clock and change this to user common clock framework.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

