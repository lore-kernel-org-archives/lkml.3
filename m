Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaAGSts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:49:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:32566 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbaAGStg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:49:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,620,1384329600"; 
   d="scan'208";a="463051599"
Date: Tue, 7 Jan 2014 10:48:05 -0800
From: "David E. Box" <david.e.box@linux.intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: mjg59@srcf.ucam.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH v6][RESEND] platform: x86: New BayTrail IOSF-SB MBI driver
Message-ID: <20140107184805.GA28135@linux.intel.com>
References: <1388427149-25456-1-git-send-email-david.e.box@linux.intel.com>
 <1389117812-28061-1-git-send-email-david.e.box@linux.intel.com>
 <52CC4427.20405@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CC4427.20405@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 10:15:03AM -0800, Randy Dunlap wrote:
> On 01/07/14 10:03, David E. Box wrote:
> > From: "David E. Box" <david.e.box@linux.intel.com>
> > 
> > diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> > index b51a746..6e199a5 100644
> > --- a/drivers/platform/x86/Kconfig
> > +++ b/drivers/platform/x86/Kconfig
> > @@ -819,4 +819,14 @@ config PVPANIC
> >  	  a paravirtualized device provided by QEMU; it lets a virtual machine
> >  	  (guest) communicate panic events to the host.
> >  
> > +config INTEL_BAYTRAIL_MBI
> > +	tristate
> 
> Is this kconfig option displayed when you run menuconfig/nconfig/xconfig/gconfig etc.?
> Doesn't it need a prompt string?
> How did you enable it and test it?
> 

It is not displayed on purpose. The driver isn't exposed to user space.
It was tested by adding the option to .config, both as module and built-in.

> > +	depends on PCI
> > +	---help---
> > +	  Needed on Baytrail platforms for access to the IOSF Sideband Mailbox
> > +	  Interface. This is a requirement for systems that need to configure
> > +	  the PUNIT for power management features such as RAPL. Register
> > +	  addresses and r/w opcodes are defined in
> 
> Think of users reading this.  At least change "r/w" to read/write.
> What is IOSF?  does it matter here?
> PUNIT?  RAPL?
> 

If you don't know what the IOSF Sideband is you probably shouldn't be enabling
this feature. Users of this driver (of which for now there are few) will be
kernel space drivers that should have ample knowledge of the registers this
interface provides access to.

Dave
