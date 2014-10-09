Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaJIRdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:33:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35282 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903AbaJIRd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:33:27 -0400
Date: Thu, 9 Oct 2014 18:32:46 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Frans Klaver <frans.klaver@xsens.com>, Sebastian Reichel <sre@kernel.org>,
        =?utf-8?B?UmVuw6k=?= Moll <linux@r-moll.nl>,
        Tjerk Hofmeijer <tjerk.hofmeijer@xsens.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] power: reset: document LTC2952 poweroff support
Message-ID: <20141009173246.GB466@leverpostej>
References: <1412866242-6474-1-git-send-email-frans.klaver@xsens.com>
 <1412866242-6474-3-git-send-email-frans.klaver@xsens.com>
 <20141009150756.GC18384@leverpostej>
 <20141009160935.GF31987@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141009160935.GF31987@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 05:09:36PM +0100, Guenter Roeck wrote:
> On Thu, Oct 09, 2014 at 04:07:56PM +0100, Mark Rutland wrote:
> > Hi,
> > 
> > On Thu, Oct 09, 2014 at 03:50:42PM +0100, Frans Klaver wrote:
> > > From: René Moll <linux@r-moll.nl>
> > > 
> > > Signed-off-by: René Moll <linux@r-moll.nl>
> > > Signed-off-by: Tjerk Hofmeijer <tjerk.hofmeijer@xsens.com>
> > > Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> > > ---
> > >  .../bindings/power/reset/ltc2952-poweroff.txt      | 31 ++++++++++++++++++++++
> > >  1 file changed, 31 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt b/Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt
> > > new file mode 100644
> > > index 0000000..c3f3d9e
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/power/reset/ltc2952-poweroff.txt
> > > @@ -0,0 +1,31 @@
> > > +Binding for the LTC2952 PowerPath controller
> > > +
> > > +This chip is used to externally trigger a system shut down. Once the trigger
> > > +has been sent, the chips watchdog has to be reset to gracefully shut down.
> > 
> > s/chips/chip's/
> > 
> > > If +the Linux systems decides to shut down, it powers off the platform
> > > via the +poweroff signal.
> > 
> > This sentence can go; the binding should describe the hardware rather
> > than the Linux behaviour.
> > 
> Maybe find an operating system independent wording and describe what the
> implementation should do. Or is that out of scope as well ?

Something like "The platform can be powered off via the poweroff signal"
would be OK. So long as it's not a description of Linux internals that's
fine. 

Ideally the binding wouldn't state how the OS should use the device
either. So if bindings can be worded w.r.t. possible uses of a device
rather than specific users, that would be preferable unless the entire
point of the binding is to specify a very specific use.

Thanks,
Mark.
