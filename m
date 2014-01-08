Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbaAHTzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:55:09 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:51043 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752717AbaAHTzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:55:07 -0500
Date: Wed, 8 Jan 2014 20:54:48 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Doug Anderson <dianders@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] watchdog: s3c2410_wdt: Only register for cpufreq on ARM_S3C24XX_CPUFREQ
Message-ID: <20140108195448.GA30865@spo001.leaseweb.com>
References: <1385420137-32725-1-git-send-email-dianders@chromium.org> <1385422603-22684-1-git-send-email-dianders@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385422603-22684-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

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
> ---
> Changes in v2:
> - Use the updated config name.

Patch added to linux-watchdog-next.

Kind regards,
Wim.

