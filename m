Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaEOQMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:12:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:23662 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbaEOQMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:12:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1060,1389772800"; 
   d="scan'208";a="541045533"
Date: Thu, 15 May 2014 19:11:48 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mike Turquette <mturquette@linaro.org>,
        Jin Yao <yao.jin@linux.intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/4] ACPI / LPSS: Solution for two issues seen on Asus
 T100
Message-ID: <20140515161148.GM1674@lahna.fi.intel.com>
References: <1400161226-24067-1-git-send-email-heikki.krogerus@linux.intel.com>
 <5374D0A8.2090407@linux.intel.com>
 <1400165610.3703.41.camel@smile.fi.intel.com>
 <5374E472.9030001@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5374E472.9030001@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 11:59:46PM +0800, Li, Aubrey wrote:
> On 2014/5/15 22:53, Andy Shevchenko wrote:
> > On Thu, 2014-05-15 at 22:35 +0800, Li, Aubrey wrote:
> >> On 2014/5/15 21:40, Heikki Krogerus wrote:
> >>> Changes since v1:
> >>> - now using do_div() in clk_fd_recalc_rate() as suggested by Andy
> >>> - NULL checks for clk_name allocation in acpi_lpss.c
> >>>
> >>> This combines two patch sets for LPSS that I had already send for
> >>> review separately. They conflicted with each other.
> >>>
> >>> The first two patches will fix a problem were the context of the
> >>> private LPSS registers is lost when entering D3. The last two will add
> >>> support for the M/N dividers on LPSS by adding a new basic clock type
> >>> for fractional dividers. The UART driver needs support for it in order
> >>> to get clock rates that suit the requested baud rates.
> >>
> >> The major issue in my mind is, this proposal makes a couple between I2C
> >> designware, HSUART, or probably DMA driver as well with LPSS driver.
> > 
> > acpi_lpss driver creates platform devices for each found and enumerated
> > device.
> 
> > If there no acpi_lpss enabled the drivers work as supposed without it.
> 
> This is not true.

The drivers work fine on non-LPSS platform. If you make them depend on
acpi_lpss, you break that.
