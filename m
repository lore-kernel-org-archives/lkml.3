Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbbAGQQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:16:44 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:41260 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbbAGQQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:16:43 -0500
Date: Wed, 7 Jan 2015 08:16:38 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] hwmon: ina2xx: allow to change the averaging rate at
 run-time
Message-ID: <20150107161638.GA9012@roeck-us.net>
References: <1420634769-11246-1-git-send-email-bgolaszewski@baylibre.com>
 <54AD3325.6030301@roeck-us.net>
 <CAMpxmJUgXyML4o3ya6ofogjf8KMrdPV-Y6SD=ZfUCjt=xLfGiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMpxmJUgXyML4o3ya6ofogjf8KMrdPV-Y6SD=ZfUCjt=xLfGiA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.50F5A422.0293,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 04:41:35PM +0100, Bartosz Golaszewski wrote:
> 2015-01-07 14:22 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> > I think I know what to do here. Can you look into the ina209 driver ?
> > It uses update_interval and calculates the number of samples to use from it.
> > The ina226 datasheet suggests that we can do the same, combined with the
> > conversion time configuration. We would have to use the default conversion
> > time of 1.1ms for that to make sense, but that is what it is today,
> > so it would be ok. This way we are in line with the ABI and can still
> > configure the number of averages.
> >
> 
> Just to make sure I understood you correctly: I should add
> update_interval attribute instead of avg_rate, accept the desired
> interval (as time) instead of the number of averages and - already
> having the conversion time hardcoded to 1.1 ms - calculate the
> averaging rate? Isn't this an overkill for what we're trying to
> implement? I know it's for the sake of staying uniform with already
> existing interface of ina209 but on the other hand these devices
> aren't quite the same.
> 
INA219 uses the same mechanism and timing as used by INA209. This way
it is easily possible to extend the driver to support the attribute
for every chip. But overall this uses the existing ABI (update_interval
is part of the hwmon ABI) instead of creating a new driver specific
attribute. Yes, that is quite important.

The additional "overhead" is just to use different numbers and a
different attribute name, so I don't really understand your concern.

Guenter
