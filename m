Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbaEOOxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:53:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:49178 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaEOOxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:53:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1059,1389772800"; 
   d="scan'208";a="512206388"
Message-ID: <1400165610.3703.41.camel@smile.fi.intel.com>
Subject: Re: [PATCHv2 0/4] ACPI / LPSS: Solution for two issues seen on Asus
 T100
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mike Turquette <mturquette@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 17:53:30 +0300
In-Reply-To: <5374D0A8.2090407@linux.intel.com>
References: <1400161226-24067-1-git-send-email-heikki.krogerus@linux.intel.com>
	 <5374D0A8.2090407@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-15 at 22:35 +0800, Li, Aubrey wrote:
> On 2014/5/15 21:40, Heikki Krogerus wrote:
> > Changes since v1:
> > - now using do_div() in clk_fd_recalc_rate() as suggested by Andy
> > - NULL checks for clk_name allocation in acpi_lpss.c
> > 
> > This combines two patch sets for LPSS that I had already send for
> > review separately. They conflicted with each other.
> > 
> > The first two patches will fix a problem were the context of the
> > private LPSS registers is lost when entering D3. The last two will add
> > support for the M/N dividers on LPSS by adding a new basic clock type
> > for fractional dividers. The UART driver needs support for it in order
> > to get clock rates that suit the requested baud rates.
> 
> The major issue in my mind is, this proposal makes a couple between I2C
> designware, HSUART, or probably DMA driver as well with LPSS driver.

acpi_lpss driver creates platform devices for each found and enumerated
device. If there no acpi_lpss enabled the drivers work as supposed
without it. I didn't see any contradiction here.

> That is, currently without LPSS driver, I2C/HSUART won't work properly.
> So we at least need to describe this dependency in Kconfig.
> 
> Thanks,
> -Aubrey
> > 
> > 
> > Heikki Krogerus (4):
> >   ACPI / PM: Export rest of the subsys functions
> >   ACPI / LPSS: custom power domain for LPSS
> >   clk: new basic clk type for fractional divider
> >   ACPI / LPSS: support for fractional divider clock
> > 
> >  drivers/acpi/acpi_lpss.c             | 204 ++++++++++++++++++++++++++++++-----
> >  drivers/acpi/device_pm.c             |   2 +
> >  drivers/clk/Makefile                 |   1 +
> >  drivers/clk/clk-fractional-divider.c | 135 +++++++++++++++++++++++
> >  include/linux/acpi.h                 |   4 +
> >  include/linux/clk-provider.h         |  31 ++++++
> >  6 files changed, 349 insertions(+), 28 deletions(-)
> >  create mode 100644 drivers/clk/clk-fractional-divider.c
> > 
> 


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

