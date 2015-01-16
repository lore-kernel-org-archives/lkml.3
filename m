Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbbAPJsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 04:48:38 -0500
Received: from mx-guillaumet.finsecur.com ([91.217.234.131]:50748 "EHLO
	guillaumet.finsecur.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbbAPJsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 04:48:35 -0500
X-Greylist: delayed 1693 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2015 04:48:34 EST
Date: Fri, 16 Jan 2015 10:20:14 +0100
From: Sylvain Rochet <sylvain.rochet@finsecur.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20150116092014.GA27945@gradator.net>
References: <1421399151-26800-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1421399151-26800-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 172.16.8.13
X-SA-Exim-Mail-From: sylvain.rochet@finsecur.com
Subject: Re: [PATCH] clockevents: don't suspend/resume if unused
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on guillaumet.finsecur.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexandre,


On Fri, Jan 16, 2015 at 10:05:51AM +0100, Alexandre Belloni wrote:
> There is no point in calling suspend/resume for unused
> clockevents as they are already stopped and disabled.
> 
> Furthermore, it can take some time to wait for some IPs to stop counting.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Reported-by: Sylvain Rochet <sylvain.rochet@finsecur.com>

Indeed, this is way better from what I did.


> +		if (dev->suspend && dev->mode != CLOCK_EVT_MODE_UNUSED)

I wonder if we should use > CLOCK_EVT_MODE_SHUTDOWN
(or CLOCK_EVT_MODE_UNUSED || CLOCK_EVT_MODE_SHUTDOWN) instead of 
!CLOCK_EVT_MODE_UNUSED.


Sylvain
