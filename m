Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbaBTXzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:55:31 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61027 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753445AbaBTXz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:55:28 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Russ Anderson <rja@sgi.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, minyard@acm.org,
        lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Date: Fri, 21 Feb 2014 01:10:21 +0100
Message-ID: <1473995.mOCKVf8skD@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140220201458.GA7099@sgi.com>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com> <20140220201458.GA7099@sgi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 20, 2014 02:14:58 PM Russ Anderson wrote:
> On Tue, Feb 18, 2014 at 11:28:29AM -0500, Matthew Garrett wrote:
> > The ACPI IPMI driver implements IPMI operation region support for the ACPI
> > core. Systems that declare ACPI operation regions may reference them at any
> > time, including during kernel initialisation. These accesses will fail
> > unless the ACPI IPMI driver is present, and undesirable system behaviour
> > may result. Set the default to Y in order to encourage distributions and
> > users to configure kernels to avoid awkward surprises.
> 
> No, please do not build the ipmi_si driver into the kernel.
> Not all systems want, or need, the ipmi_si driver.  
> 
> The distro that added this change created all sorts of support
> problems.

Which distro was that?

Do you have any pointers to specific bug reports related to that?

Rafael


> Problems include kipmi0 spinning at 100% of cpu
> (creating a performance hit) and long boot delays (as the
> kernel tries to talk to a BMC that will never respond).
> It has been a big mess.
> 
> Nacked-by: Russ Anderson <rja@sgi.com>
> 
> 
> > Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> > ---
> > Actually, I guess we also want this on CONFIG_IPMI_HANDLER for least
> > surprise
> > 
> >  drivers/acpi/Kconfig      | 2 +-
> >  drivers/char/ipmi/Kconfig | 2 ++
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> > index 4770de5..0e6aab9 100644
> > --- a/drivers/acpi/Kconfig
> > +++ b/drivers/acpi/Kconfig
> > @@ -162,7 +162,7 @@ config ACPI_PROCESSOR
> >  config ACPI_IPMI
> >  	tristate "IPMI"
> >  	depends on IPMI_SI
> > -	default n
> > +	default y
> >  	help
> >  	  This driver enables the ACPI to access the BMC controller. And it
> >  	  uses the IPMI request/response message to communicate with BMC
> > diff --git a/drivers/char/ipmi/Kconfig b/drivers/char/ipmi/Kconfig
> > index 0baa8fa..eea8464 100644
> > --- a/drivers/char/ipmi/Kconfig
> > +++ b/drivers/char/ipmi/Kconfig
> > @@ -5,6 +5,7 @@
> >  menuconfig IPMI_HANDLER
> >         tristate 'IPMI top-level message handler'
> >         depends on HAS_IOMEM
> > +       default y if ACPI
> >         help
> >           This enables the central IPMI message handler, required for IPMI
> >  	 to work.
> > @@ -45,6 +46,7 @@ config IPMI_DEVICE_INTERFACE
> >  
> >  config IPMI_SI
> >         tristate 'IPMI System Interface handler'
> > +       default y if ACPI
> >         help
> >           Provides a driver for System Interfaces (KCS, SMIC, BT).
> >  	 Currently, only KCS and SMIC are supported.  If
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
