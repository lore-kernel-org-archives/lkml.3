Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaBDTKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:10:06 -0500
Received: from www.linutronix.de ([62.245.132.108]:48664 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbaBDTKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:10:04 -0500
Date: Tue, 4 Feb 2014 20:10:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Chew <AChew@nvidia.com>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "abrestic@chromium.org" <abrestic@chromium.org>,
        "dgreid@chromium.org" <dgreid@chromium.org>,
        "katierh@chromium.org" <katierh@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH v1] clocksource: tegra: Add nvidia,tegra30-timer compat
In-Reply-To: <643E69AA4436674C8F39DCC2C05F763863199852C7@HQMAIL03.nvidia.com>
Message-ID: <alpine.DEB.2.02.1402042004000.24986@ionos.tec.linutronix.de>
References: <1391203779-5676-1-git-send-email-achew@nvidia.com> <52EFC652.9000209@linaro.org> <643E69AA4436674C8F39DCC2C05F763863199852C7@HQMAIL03.nvidia.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, Andrew Chew wrote:

> > From: Daniel Lezcano [mailto:daniel.lezcano@linaro.org]
> > Sent: Monday, February 03, 2014 8:40 AM
> > To: Andrew Chew; tglx@linutronix.de; swarren@wwwdotorg.org;
> > thierry.reding@gmail.com; abrestic@chromium.org; dgreid@chromium.org;
> > katierh@chromium.org
> > Cc: linux-kernel@vger.kernel.org; linux-tegra@vger.kernel.org
> > Subject: Re: [PATCH v1] clocksource: tegra: Add nvidia,tegra30-timer compat
> > 
> > On 01/31/2014 10:29 PM, Andrew Chew wrote:
> > > There are some differences between tegra20's timer registers and
> > > tegra30's (and later).  For one thing, the watchdogs don't seem to be
> > > present in tegra20.
> > 
> > "don't seem", so it is an assumption ?
> 
> No, this is not an assumption.  It has been verified by other NVIDIA engineers
> since I proposed this change.

So why is your changelog saying "don't seem to be" ?
  
> > > Add this compatibility string in order to be able to distinguish
> > > whether the watchdogs are there or not.
> > 
> > Sorry but I don't get the connection between declaring the tegra30_timer
> > and the log. Can you elaborate please ?
> 
> I don't know what you mean by "the log".  Was that a typo?  Anyway, I

Daniel refers to the changelog.

> have a watchdog driver that I intend to follow up with, that binds
> with tegra30-timer.  I don't want this driver to be able to bind with
> tegra20-timer, because the driver won't actually work on tegra20.

So the changelog should say:

  Tegra30 and later have more timer functionality than Tegra20, but
  share the clocksource core code.

  Add a separate devicetree entry which defaults to the tegra20 code
  for now. This is preparatory work for adding new tegra30 specific
  functionality.

Thanks,

	tglx
