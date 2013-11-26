Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab3KZA2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:28:08 -0500
Received: from trinity.fluff.org ([89.16.178.74]:36879 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab3KZA2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:28:05 -0500
X-Greylist: delayed 1167 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Nov 2013 19:28:05 EST
Date: Tue, 26 Nov 2013 00:08:31 +0000
From: Ben Dooks <ben@trinity.fluff.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: s3c2410_wdt: Only register for cpufreq on
 CPU_FREQ_S3C24XX
Message-ID: <20131126000831.GW12108@trinity.fluff.org>
References: <1385420137-32725-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385420137-32725-1-git-send-email-dianders@chromium.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 02:55:37PM -0800, Doug Anderson wrote:
> On modern SoCs the watchdog timer is parented on a clock that doesn't
> change every time we have a cpufreq change.  That means we don't need
> to constantly adjust the watchdog timer, so avoid registering for and
> dealing with cpufreq transitions unless we've actually got
> CPU_FREQ_S3C24XX defined.

The S3C2410 to at-least S3C2440 there is only one PLL/clock-divider
set so changing any part of that can change frequency supplied to
the watchdog.
