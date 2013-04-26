Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3DZO7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:59:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53652 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3DZO7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:59:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: artem.bityutskiy@linux.intel.com
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hui Wang <jason77.wang@gmail.com>,
        Zhang Jiejing <jiejing.zhang@freescale.com>,
        linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hofemeier, Ulf" <ulf.hofemeier@intel.com>
Subject: Re: eGalax touchscreen regression
Date: Fri, 26 Apr 2013 16:59:09 +0200
Message-ID: <3076410.nE1Nu6ITeM@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-17-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1366794193.21369.11.camel@sauron.fi.intel.com>
References: <1366708088.9823.16.camel@sauron.fi.intel.com> <20130423154007.GB4104@core.coreip.homeip.net> <1366794193.21369.11.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:hAHF9j9SppNbaIJQjUt0lLR7ODEaA3fucEZv17VDKpk
 PFBn3+0BTqpqOOVvJmRkBHlPiINLY55vTwxgcmvcN058sLdrfF
 tJ1gduKclGUdklYZSSpWtSqK0nmVb1BnExnCRy97rOvrJHMJSE
 giBuhTQX+vBGEPffVrJXGyHEz7XMMQW9xPlUikEJvgeEXlBzu7
 gGM1DuR66hhco2v4NSvR+OhZh24H0TJ59etcWoSACrAv0FRgdA
 VEUcKk7Z4/gT8dnU7becyZUWRoBFttsXHsUH6JYzGLbhEOOn/O
 6TqqmdhOxu3W6BQZlrrBVo7lYn6pHoURdtPy6eMJS44V+Ha8td
 P/96Tcen/Ew3Ni0QKVEo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 April 2013 12:03:13 Artem Bityutskiy wrote:
> On Tue, 2013-04-23 at 08:40 -0700, Dmitry Torokhov wrote:
> > > the eGalax driver now requires OF. For us this is a regression because
> > > we do not have OF: https://bugs.tizen.org/jira/browse/TIVI-740
> > 
> > I see. In this case we need to come up with a platform data to pass
> > wakeup gpio in case platform does not support OF. irq_to_gpio() is not
> > supported on many platforms, causing compilation errors.
> > 
> > Is the platform that you are trying to use the touchscreen upstream?
> 
> OK, so this is about just a monitor with a touchscreen (Giantec high-res
> capacitive 11.6” LCD monitor). The touchscreen is connected to a
> commodity hardware via USB.
> 
> So yes, the platform _is_ upstream  Namely, we use just a SandyBridge
> PC.

So you use a usb-to-i2c interface?

You have to figure out how the wakeup line is connected to the eGalax
device and provide an alternative implementation for egalax_wake_up_device
that can be used in your case then.

	Arnd
