Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbaDVLuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:50:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:5721 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545AbaDVLuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:50:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,903,1389772800"; 
   d="scan'208";a="524806243"
Date: Tue, 22 Apr 2014 14:57:17 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Chew Chiau Ee <chiau.ee.chew@intel.com>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] spi/pxa2xx-pci: Pass host clock rate info from PCI
 glue layer
Message-ID: <20140422115716.GP30677@intel.com>
References: <1397751967-20250-1-git-send-email-chiau.ee.chew@intel.com>
 <1397751967-20250-3-git-send-email-chiau.ee.chew@intel.com>
 <20140418163054.GH12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418163054.GH12304@sirena.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 05:30:54PM +0100, Mark Brown wrote:
> On Fri, Apr 18, 2014 at 12:26:07AM +0800, Chew Chiau Ee wrote:
> > From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> > 
> > Intel BayTrail PCI mode LPSS devices inclusive of SPI do not rely
> > on common clock framework. Thus, this patch allows the PCI mode
> > SPI host to pass the supported clock rate info to the core layer
> > which eventually used for speed calculation.
> 
> As you mention we already have a clock API for passing around
> information about clocks, it would be much better to fix the fact that
> this isn't enabled on x86 than to add custom code to deal with clocks
> (even simple things like this) - this is far from the only place where
> it causes issues.

We actually have clock API enabled on x86 if CONFIG_X86_INTEL_LPSS is
selected.

In this case the question is more like, where do we create clocks for PCI
enumerated devices? Surely we don't want to have board files to do this.

In ACPI mode, we do it in drivers/acpi/acpi_lpss.c but not sure where we
could do that in PCI code.
