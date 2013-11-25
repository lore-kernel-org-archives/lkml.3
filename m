Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab3KYPSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:18:44 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56252 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab3KYPSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:18:40 -0500
Date: Mon, 25 Nov 2013 16:18:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Sebastian Reichel <sre@ring0.de>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, freemangordon@abv.bg, aaro.koskinen@iki.fi
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for
 automode
Message-ID: <20131125151838.GD21526@amd.pavel.ucw.cz>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <201311242041.47075@pali>
 <20131125140127.GA24125@amd.pavel.ucw.cz>
 <201311251510.00987@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201311251510.00987@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-11-25 15:10:00, Pali Rohár wrote:
> On Monday 25 November 2013 15:01:27 Pavel Machek wrote:
> > Where can I get dsme sources?
> > 									Pavel
> 
> dsme daemon: https://gitorious.org/community-ssu/dsme
> dsme thermal plugin: https://gitorious.org/rx51-bme-replacement/dsme-thermalobject-surface
> 
> dsme thermal plugin is responsible for checking temperature of 
> battery and send it to dsme damon. dsme daemon itself checking 
> temperature limits and do something (e.g reboot device)

Thanks for links!

AFAICT.... dsme daemon does some kind of system management, not
directly controlling charging, right? It does monitor system temperature.

Now.. Imagine phone left in car in charger (on sun). Likely
temperature will reach high values, kernel is charging, dsme will
reboot the system, but kernel will start charging again, dsme will
reboot again, ...

And it is not only high temperatures that are problem for li-ion
charging; battery should not be fast charged below 5C and should not
be charged below 0C. (Again, both are likely to happen if you leave
your phone in car).

AFAICT, we should simply disable charging below 5C or above 45C.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
