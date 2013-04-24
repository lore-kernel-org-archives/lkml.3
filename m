Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3DXF4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 01:56:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:20297 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab3DXF4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 01:56:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,540,1363158000"; 
   d="scan'208";a="300230001"
Message-ID: <1366783107.21369.0.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] input: egalax_ts: remove bogus OF dependency
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, Ulf Hofemeier <ulf.hofemeier@intel.com>,
        Hui Wang <jason77.wang@gmail.com>
Date: Wed, 24 Apr 2013 08:58:27 +0300
In-Reply-To: <20130423153754.GA4104@core.coreip.homeip.net>
References: <1366708088.9823.16.camel@sauron.fi.intel.com>
	 <1366715357-9392-1-git-send-email-artem.bityutskiy@linux.intel.com>
	 <20130423153754.GA4104@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-23 at 08:37 -0700, Dmitry Torokhov wrote:
> On Tue, Apr 23, 2013 at 02:09:17PM +0300, Artem Bityutskiy wrote:
> > There are platforms using this driver which do not have OF. However, commit
> > ae495e844a77344fdaedbb2ad97d925d096e9f0d added a Kconfig dependency on OF and
> > broke OF-less setups.
> > 
> > Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> > Cc: stable@vger.kernel.org [v3.7+]
> > ---
> >  drivers/input/touchscreen/Kconfig     |    2 +-
> >  drivers/input/touchscreen/egalax_ts.c |    2 ++
> >  2 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> > index 515cfe7..d53b0d6 100644
> > --- a/drivers/input/touchscreen/Kconfig
> > +++ b/drivers/input/touchscreen/Kconfig
> > @@ -227,7 +227,7 @@ config TOUCHSCREEN_EETI
> >  
> >  config TOUCHSCREEN_EGALAX
> >  	tristate "EETI eGalax multi-touch panel support"
> > -	depends on I2C && OF
> > +	depends on I2C
> 
> No, because egalax_wake_up_device() needs OF data and with !CONFIG_OF
> you'll end up using stubs, the wakeup will fail and the touchscreen will
> fail probe.
> 
> It wasn't tested, was it?

Not tested. But Ulf (the reporter of the issue) confirms it does not
solve the issue.

-- 
Best Regards,
Artem Bityutskiy

