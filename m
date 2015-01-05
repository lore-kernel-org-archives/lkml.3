Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbbAEWv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:51:57 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54203 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbbAEWvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:51:55 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+u4WWBEcPZQbgp2RvBU33y
Date: Mon, 5 Jan 2015 14:48:02 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Dave Gerlach <d-gerlach@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, Benoit Cousson <bcousson@baylibre.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Suman Anna <s-anna@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 3/3] remoteproc: wkup_m3: Add wkup_m3 remote proc driver
Message-ID: <20150105224802.GM4081@atomide.com>
References: <1420228319-41085-1-git-send-email-d-gerlach@ti.com>
 <1420228319-41085-4-git-send-email-d-gerlach@ti.com>
 <20150102200424.GD4920@saruman>
 <54AAEFA6.3080603@ti.com>
 <20150105202032.GQ19336@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105202032.GQ19336@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [150105 12:23]:
> On Mon, Jan 05, 2015 at 02:10:14PM -0600, Dave Gerlach wrote:
> > >> +static int wkup_m3_rpm_suspend(struct device *dev)
> > >> +{
> > >> +	return -EBUSY;
> > >> +}
> > > 
> > > looks like this is just coping with omap_device bogosity, no ?
> > >
> > 
> > Yes, without this omap_device shuts down ther wkup_m3 during suspend, which of
> > course prevents the wkup_m3 from finishing suspend process or waking SoC back
> > up. Haven't found a better solution for the problem than this.
> 
> Tony, any better for this ? Do we keep this small hack or find a better
> way ?

Looks OK to me for now, later on we may want to have a flag for
HWMOD_NEVER_IDLE or something similar for wkup_m3_hwmod. But let's
not add more dependencies to this series.

Regards,

Tony
