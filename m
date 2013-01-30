Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab3A3TbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:31:12 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:61345 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab3A3TbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:31:09 -0500
Message-ID: <1359574265.2789.52.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH] ptp: PTP_1588_CLOCK_PCH depends on x86
From: Ben Hutchings <bhutchings@solarflare.com>
To: Richard Cochran <richardcochran@gmail.com>
CC: Jeff Mahoney <jeffm@suse.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Wed, 30 Jan 2013 19:31:05 +0000
In-Reply-To: <20130130190207.GB6283@netboy.at.omicron.at>
References: <510958D5.7060206@suse.com>
	 <20130130190207.GB6283@netboy.at.omicron.at>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19598.005
X-TM-AS-Result: No--29.898500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-30 at 20:02 +0100, Richard Cochran wrote:
> On Wed, Jan 30, 2013 at 12:31:01PM -0500, Jeff Mahoney wrote:
> > The EG20T PCH is only compatible with Intel Atom processors so it
> > should depend on x86.
> 
> Yes, there is something wrong with PTP_1588_CLOCK_PCH. The last
> several times I did 'make oldconfig' for various configs, it asked me
> whether to enable this 'new' option. That is really annoying,
> especially with non-atom and non-x86 builds.
> 
> Ben, you removed the PCH_GBE dependency in 18d359ce. Are you sure that
> was the right thing to do?

The clock is a separate device and the PHC driver doesn't depend on the
net driver.  However, since the clock is a PCI device the driver does
need a dependency on PCI (which was previously an indirect dependency).

> > Cc: Richard Cochran <richardcochran@gmail.com>
> > Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> > ---
> >  drivers/ptp/Kconfig |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- a/drivers/ptp/Kconfig
> > +++ b/drivers/ptp/Kconfig
> > @@ -72,6 +72,7 @@ config DP83640_PHY
> >  
> >  config PTP_1588_CLOCK_PCH
> >       tristate "Intel PCH EG20T as PTP clock"
> > +     depends on X86
> >       select PTP_1588_CLOCK
> >       help
> >         This driver adds support for using the PCH EG20T as a PTP

I agree that the driver is only useful on X86, but some people like to
build-test as many drivers as possible with a single configuration.  The
only build dependency for this seems to be PCI.

(Putting on my distribution hat for a moment: it is useful to know that
a driver is practically architecture-specific even though it can be
built elsewhere.  Perhaps there is a use for a BUILD_TEST or BUILD_ALL
config symbol, so this could be:
	depends on X86 || (BUILD_TEST && PCI)
)

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

