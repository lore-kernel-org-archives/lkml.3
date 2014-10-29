Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340AbaJ2ObY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:31:24 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52748 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932834AbaJ2ObW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:31:22 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Darren Hart <dvhart@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / GPIO: Pass index to acpi_get_gpiod_by_index() when using properties
Date: Wed, 29 Oct 2014 15:51:59 +0100
Message-ID: <11524706.oiA2Jzq65k@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1738599.RytCx391OM@vostro.rjw.lan>
References: <1414494927-204923-1-git-send-email-mika.westerberg@linux.intel.com> <20141029085429.GJ1304@lahna.fi.intel.com> <1738599.RytCx391OM@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 29, 2014 03:42:23 PM Rafael J. Wysocki wrote:
> On Wednesday, October 29, 2014 10:54:29 AM Mika Westerberg wrote:
> > On Wed, Oct 29, 2014 at 04:41:47PM +0900, Alexandre Courbot wrote:
> > > On 10/29/2014 06:59 AM, Rafael J. Wysocki wrote:
> > > >On Tuesday, October 28, 2014 01:15:27 PM Mika Westerberg wrote:
> > > >>acpi_dev_add_driver_gpios() makes it possible to set up mapping between
> > > >>properties and ACPI GpioIo resources in a driver, so we can take index
> > > >>parameter in acpi_find_gpio() into use with _DSD device properties now.
> > > >>
> > > >>This index can be used to select a GPIO from a property with multiple
> > > >>GPIOs:
> > > >>
> > > >>   Package () {
> > > >>   	"data-gpios",
> > > >>   	Package () {
> > > >>   		\_SB.GPIO, 0, 0, 0,
> > > >>   		\_SB.GPIO, 1, 0, 0,
> > > >>   		\_SB.GPIO, 2, 0, 1,
> > > >>   	}
> > > >>   }
> > > >>
> > > >>In order to retrieve the last GPIO from a driver we can simply do:
> > > >>
> > > >>   desc = devm_gpiod_get_index(dev, "data", 2);
> > > >>
> > > >>and so on.
> > > >>
> > > >>Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > >
> > > >Cool. :-)
> > > >
> > > >Any objections anyone?
> > > 
> > > Looks good to me!
> > > 
> > > Acked-by: Alexandre Courbot <acourbot@nvidia.com>
> > 
> > Thanks!
> > 
> > > Since this looks like a bug fix, shouldn't this be squashed into the
> > > relevant patch of the device-properties set?
> > 
> > I agree.
> 
> Well, except that the set is in my linux-next branch now and I very much
> prefer to do fixes on top of it.
> 
> Besides, I'm not sure if that even matters for the current series.

Never mind.  I need to rebase the series anyway because of a bug in the
second patch, so I'll fold the $subject one into patch [5/12].

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
