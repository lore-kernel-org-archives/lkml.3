Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab3IQIbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 04:31:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:36496 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab3IQIbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 04:31:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,921,1371106800"; 
   d="scan'208";a="404506040"
Date: Tue, 17 Sep 2013 11:37:12 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 2/2] gpio / ACPI: add support for GPIO operation regions
Message-ID: <20130917083712.GS7393@intel.com>
References: <1379085280-2211-1-git-send-email-mika.westerberg@linux.intel.com>
 <1379085280-2211-2-git-send-email-mika.westerberg@linux.intel.com>
 <1AE640813FDE7649BE1B193DEA596E880246367A@SHSMSX101.ccr.corp.intel.com>
 <20130915065151.GK7393@intel.com>
 <1AE640813FDE7649BE1B193DEA596E88024639E4@SHSMSX101.ccr.corp.intel.com>
 <1AE640813FDE7649BE1B193DEA596E8802463A46@SHSMSX101.ccr.corp.intel.com>
 <20130916081048.GM7393@intel.com>
 <1AE640813FDE7649BE1B193DEA596E8802463D85@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E8802463D85@SHSMSX101.ccr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 11:35:56PM +0000, Zheng, Lv wrote:
> > From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> > Sent: Monday, September 16, 2013 4:11 PM
> > 
> > On Mon, Sep 16, 2013 at 01:21:53AM +0000, Zheng, Lv wrote:
> > > > A pseudo device may be created to access the GPIO operation region fields provided by one GPIO device.
> > > > The pseudo device may have other functions to access other GPIO operation region fields provided by other GPIO devices, or even worse
> > to
> > > > access other ACPI provided value-adds.
> > > > So hierarchically the pseudo device only requires CPU, thus should not be under the GPIO device, which means the GPIO operation
> > regions
> > > > have nothing to do with the GPIO devices' ACPI handle.
> > >
> > > Sorry for the wording.
> > > It's better to say the GPIO operation region users haven't strict
> > > relationship to the GPIO operation region providers.
> > > As the installation is to provide GPIO operation regions to the users, it
> > > shouldn't relate to the providers' ACPI handle.
> > 
> > If I understand you correctly you mean that there might be multiple users
> > (different devices) for the same GPIO operation region, right?
> 
> No, this is not what I meant.
> Can one vendor device uses two or more GPIO pins from different GPIO ports?

Yes.

> > That shouldn't be a problem as far as I can tell.
> > 
> > What comes to the hierarchy you refer, I'm not sure if that is a problem
> > either (unless I'm missing something). The GPIO can be used anywhere in the
> > ASL, it doesn't have to be descendant of the GPIO device. You only need to
> > do something like this:
> > 
> > 	// Assert the GPIO
> > 	Store(1, \_SB.PCI0.SHD3)
> > 
> > In other words, use the fully qualified name.
> 
> Yes, which means this line of code can be everywhere in the namespace.
> It is not required to be under one particular GPIO device as long as there is an operation region defined in that scope.
> 
> The problem is the installation, the first parameter for
> acpi_install_address_space_handler() is a namespace node, the function
> will call _REG for all OperationRegions below the scope whose top most
> node is the specified node.
> The nodes out of this scope are not affected.  So if an OperationRegion
> is defined out of this scope, problem happens.

I suppose for that operation region another GPIO device should be
introduced then, no?

So if we don't have a GPIO driver for the given operation region, what can
we do? We don't want the ASL code to erroneusly think that there is an
operation region available when it is not.
