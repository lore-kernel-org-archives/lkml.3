Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaJ0RCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:02:37 -0400
Received: from gloria.sntech.de ([95.129.55.99]:52302 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbaJ0RCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:02:34 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: balbi@ti.com
Cc: Johan Hovold <johan@kernel.org>, Romain Perier <romain.perier@gmail.com>,
        devicetree@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org, robh@kernel.org,
        mark.rutland@arm.com, linux-pm@vger.kernel.org, linux@roeck-us.net,
        lee.jones@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v1 01/10] of: Rename "poweroff-source" property to "system-power-controller"
Date: Mon, 27 Oct 2014 18:05:35 +0100
Message-ID: <108805117.sS9iL5zouT@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20141027164741.GJ14253@saruman>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com> <20141027164103.GD2006@localhost> <20141027164741.GJ14253@saruman>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 27. Oktober 2014, 11:47:41 schrieb Felipe Balbi:
> On Mon, Oct 27, 2014 at 05:41:03PM +0100, Johan Hovold wrote:
> > On Mon, Oct 27, 2014 at 11:38:40AM -0500, Felipe Balbi wrote:
> > > On Mon, Oct 27, 2014 at 04:26:46PM +0000, Romain Perier wrote:
> > > > As discussed on the mailing list, it makes more sense to rename this
> > > > property to "system-power-controller". Problem being that the word
> > > > "source" usually tends to be used for inputs and that is out of
> > > > control of the OS. The poweroff capability is an output which simply
> > > > turns the system-power off. Also, this property might be used by
> > > > drivers which power-off the system and power back on subsequent RTC
> > > > alarms. This seems to suggest to remove "poweroff" from the property
> > > > name and to choose "system-power-controller" as the more generic
> > > > name. This patchs adds the required renaming changes and defines an
> > > > helper function which is compatible with both properties, the old one
> > > > prefixed by a vendor name and the new one without any prefix.
> > > 
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

There have never been any users of the poweroff-source. The act8846 in the 
radxarock would have been the first, but I held off with the dts patch as the 
naming issue came up at the same time.

So I guess if Romain keeps the renaming together there shouldn't be any other 
bad bisection points?
