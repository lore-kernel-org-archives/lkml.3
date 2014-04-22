Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbaDVMav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:30:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:27517 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182AbaDVMas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:30:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,903,1389772800"; 
   d="scan'208";a="524824396"
Date: Tue, 22 Apr 2014 15:37:53 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Chew Chiau Ee <chiau.ee.chew@intel.com>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] spi/pxa2xx-pci: Pass host clock rate info from PCI
 glue layer
Message-ID: <20140422123753.GQ30677@intel.com>
References: <1397751967-20250-1-git-send-email-chiau.ee.chew@intel.com>
 <1397751967-20250-3-git-send-email-chiau.ee.chew@intel.com>
 <20140418163054.GH12304@sirena.org.uk>
 <20140422115716.GP30677@intel.com>
 <20140422120948.GT12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422120948.GT12304@sirena.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 01:09:48PM +0100, Mark Brown wrote:
> On Tue, Apr 22, 2014 at 02:57:17PM +0300, Mika Westerberg wrote:
> > On Fri, Apr 18, 2014 at 05:30:54PM +0100, Mark Brown wrote:
> 
> > > As you mention we already have a clock API for passing around
> > > information about clocks, it would be much better to fix the fact that
> > > this isn't enabled on x86 than to add custom code to deal with clocks
> > > (even simple things like this) - this is far from the only place where
> > > it causes issues.
> 
> > We actually have clock API enabled on x86 if CONFIG_X86_INTEL_LPSS is
> > selected.
> 
> Why is this conditional?  It's really unhelpful for writing generic code
> handling clocks that the API isn't available as standard.  Allowing the
> user to disable it if it's not required makes sense but not making it
> available at all is just unhelpful.

IIRC, it was decided at the time that it was the "safest" option. Anyway,
distros seem to have it enabled already. Just checked my Fedora
installation and it's there.

> > In this case the question is more like, where do we create clocks for PCI
> > enumerated devices? Surely we don't want to have board files to do this.
> 
> > In ACPI mode, we do it in drivers/acpi/acpi_lpss.c but not sure where we
> > could do that in PCI code.
> 
> As far as I can tell the clock here is part of the same glue that allows
> the generic pxa2xx support to be instantiated from PCI.  I would
> therefore expect the glue to also instantiate the clock.  Or if it's a
> standard PCI clock then perhaps the PCI subsystem ought to be providing
> it.

Instantiating the clock in the PCI glue driver makes sense (as it's not a
standard PCI clock). Thanks.

Chiau Ee, do you see any problems with that solution?
