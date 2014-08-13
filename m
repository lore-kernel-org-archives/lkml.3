Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaHMHIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:08:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:50779 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaHMHIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:08:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,855,1400050800"; 
   d="scan'208";a="557848754"
Date: Wed, 13 Aug 2014 10:07:59 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, torvalds@linux-foundation.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: Make I2C core able to be module when I2C_ACPI is
 selected.
Message-ID: <20140813070759.GB1657@lahna.fi.intel.com>
References: <1407740455-21269-1-git-send-email-tianyu.lan@intel.com>
 <20140812095321.GU1657@lahna.fi.intel.com>
 <20140813020250.GA2853@katana>
 <53EAD278.2010003@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53EAD278.2010003@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 10:50:32AM +0800, Lan Tianyu wrote:
> On 2014年08月13日 10:03, Wolfram Sang wrote:
> > On Tue, Aug 12, 2014 at 12:53:21PM +0300, Mika Westerberg wrote:
> >> On Mon, Aug 11, 2014 at 03:00:55PM +0800, Lan Tianyu wrote:
> >>> Commit da3c6647(I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI
> >>> config) adds a new kernel config I2C_ACPI and make I2C core built in
> >>> when the config is selected. This is wrong because distributions
> >>> etc generally compile I2C as a module and the commit broken that.
> >>> This patch is to make I2C core able to be a module when I2C_ACPI is
> >>> selected. Original issue the commit da3c6647 tried to avoid will
> >>> be fixed in ACPICA and it's rarely triggered during unloading module. 
> >>>
> >>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> >>
> >> I wonder if we can do
> >>
> >> 	depends on I2C=y
> >>
> >> here? If I understand it right, then we only build the ACPI_I2C if I2C
> >> is compiled into the kernel. That way the problem da3c6647 tried to
> >> solve doens't re-appear.
> >>
> >> We can later on relax this once ACPICA has been fixed. Thoughts?
> > 
> > I had the same idea yet my travel to Chicago interrupted thinking about
> > it further. Once I get rid of my jetlag, I'll have a closer look. Unless
> > you already came up with the perfect solution until then, of course ;)
> >
> 
> Hi Mika & Wolfram:
> 	I have one concern about "depends on I2C=y". If distribution config
> file selects I2C core as a module, the original code can enumerate I2C
> slave devices from ACPI table. But now I2C_ACPI depends on I2C core
> built in, the I2C module can't enumerate devices from ACPI table. This
> maybe a regression for distribution?

True, but only the I2C OpRegion parts needs to have I2C=y. Does it make
sense to name ACPI_I2C to ACPI_I2C_OPREGION (or something like that)
and only enable it when I2C=y? Then we would have ACPI I2C enumeration
still in place.
