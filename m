Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaJ0RFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:05:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58829 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaJ0RFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:05:47 -0400
Date: Mon, 27 Oct 2014 18:02:37 +0100
From: Johan Hovold <johan@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Johan Hovold <johan@kernel.org>, Romain Perier <romain.perier@gmail.com>,
        heiko@sntech.de, devicetree@vger.kernel.org, broonie@kernel.org,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, robh@kernel.org, mark.rutland@arm.com,
        linux-pm@vger.kernel.org, linux@roeck-us.net, lee.jones@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v1 01/10] of: Rename "poweroff-source" property to
 "system-power-controller"
Message-ID: <20141027170237.GG2006@localhost>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
 <20141027163840.GA14253@saruman>
 <20141027164103.GD2006@localhost>
 <20141027164741.GJ14253@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027164741.GJ14253@saruman>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 11:47:41AM -0500, Felipe Balbi wrote:
> On Mon, Oct 27, 2014 at 05:41:03PM +0100, Johan Hovold wrote:
> > On Mon, Oct 27, 2014 at 11:38:40AM -0500, Felipe Balbi wrote:
> > > On Mon, Oct 27, 2014 at 04:26:46PM +0000, Romain Perier wrote:
> > > > As discussed on the mailing list, it makes more sense to rename this property
> > > > to "system-power-controller". Problem being that the word "source" usually tends
> > > > to be used for inputs and that is out of control of the OS. The poweroff
> > > > capability is an output which simply turns the system-power off. Also, this
> > > > property might be used by drivers which power-off the system and power back on
> > > > subsequent RTC alarms. This seems to suggest to remove "poweroff" from the
> > > > property name and to choose "system-power-controller" as the more generic name.
> > > > This patchs adds the required renaming changes and defines an helper function
> > > > which is compatible with both properties, the old one prefixed by a vendor name
> > > > and the new one without any prefix.
> > 
> > > I think you still need to support poweroff-source since it has been
> > > released on a stable kernel. Perhaps add a warning message telling users
> > > it's deprecated and asking them to switch over to
> > > system-power-controller ? Still, simply removing it isn't very nice.
> > 
> > No, Romain sent a patch that replaced "<vendor>,system-power-controller"
> > with "poweroff-source". It's now in Mark's tree (for v3.19), and this
> > series "reverts" to the old name minus the vendor-prefix.
> 
> oh, so poweroff-source isn't in Linus' tree yet ? (/me goes grep)
> 
> Then it should be fine. My bad.
> 
> Many of the other comments are still valid because even though
> poweroff-source isn't in mainline yet, this series still creates
> bisection points which are broken. The best solution would be to drop
> all those patches from Mark's tree. Read, not revert, drop.

I agree.

Johan
