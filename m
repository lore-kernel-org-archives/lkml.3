Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbaAGUdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 15:33:15 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53061 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753365AbaAGUdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 15:33:09 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, mjg59@srcf.ucam.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH v6][RESEND] platform: x86: New BayTrail IOSF-SB MBI driver
Date: Tue, 07 Jan 2014 21:46:57 +0100
Message-ID: <4364833.i22acYTaeM@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140107184805.GA28135@linux.intel.com>
References: <1388427149-25456-1-git-send-email-david.e.box@linux.intel.com> <52CC4427.20405@infradead.org> <20140107184805.GA28135@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 07, 2014 10:48:05 AM David E. Box wrote:
> On Tue, Jan 07, 2014 at 10:15:03AM -0800, Randy Dunlap wrote:
> > On 01/07/14 10:03, David E. Box wrote:
> > > From: "David E. Box" <david.e.box@linux.intel.com>
> > > 
> > > diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> > > index b51a746..6e199a5 100644
> > > --- a/drivers/platform/x86/Kconfig
> > > +++ b/drivers/platform/x86/Kconfig
> > > @@ -819,4 +819,14 @@ config PVPANIC
> > >  	  a paravirtualized device provided by QEMU; it lets a virtual machine
> > >  	  (guest) communicate panic events to the host.
> > >  
> > > +config INTEL_BAYTRAIL_MBI
> > > +	tristate
> > 
> > Is this kconfig option displayed when you run menuconfig/nconfig/xconfig/gconfig etc.?
> > Doesn't it need a prompt string?
> > How did you enable it and test it?
> > 
> 
> It is not displayed on purpose. The driver isn't exposed to user space.
> It was tested by adding the option to .config, both as module and built-in.
> 
> > > +	depends on PCI
> > > +	---help---
> > > +	  Needed on Baytrail platforms for access to the IOSF Sideband Mailbox
> > > +	  Interface. This is a requirement for systems that need to configure
> > > +	  the PUNIT for power management features such as RAPL. Register
> > > +	  addresses and r/w opcodes are defined in
> > 
> > Think of users reading this.  At least change "r/w" to read/write.
> > What is IOSF?  does it matter here?
> > PUNIT?  RAPL?
> > 
> 
> If you don't know what the IOSF Sideband is you probably shouldn't be enabling
> this feature.

What about generic x86 distro kernels?  They won't know in advance whether or
not they will need this feature.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
