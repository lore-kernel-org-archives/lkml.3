Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaENIz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 04:55:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:17772 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbaENIzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 04:55:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1050,1389772800"; 
   d="scan'208";a="538787448"
From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] pwm: lpss: remove dependency on clk framework
Thread-Topic: [PATCH] pwm: lpss: remove dependency on clk framework
Thread-Index: AQHPa2HlssGmNDZgIEys6Mqka80XEps/rNfA//+WU4CAAIbk0A==
Date: Wed, 14 May 2014 08:54:51 +0000
Message-ID: <604BF5F4C5D71041942BC7E84ED659EA0B004E18@PGSMSX108.gar.corp.intel.com>
References: <1399624521-26175-1-git-send-email-heikki.krogerus@linux.intel.com>
 <604BF5F4C5D71041942BC7E84ED659EA0B004D2D@PGSMSX108.gar.corp.intel.com>
 <20140514083929.GA12238@xps8300>
In-Reply-To: <20140514083929.GA12238@xps8300>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Hi,
> 
> On Wed, May 14, 2014 at 07:00:59AM +0000, Chew, Chiau Ee wrote:
> > Heikki,
> > For ACPI mode, the clock rate information for PWM is being setup in the
> acpi_lpss.c layer.
> > Thus, only PCI mode depends on the driver_data to pass in the clock rate
> information.
> 
> The goal with this patch is actually to free acpi_lpss.c from delivering the clock
> for this driver.
> 
> The LPSS PWM does not get it's clock from the LPSS 100Mhz source clock,
> which means we have to have the rate of it's clock hard-coded.
> Since it's already hard coded also in this driver for PCI mode in any case, it
> makes no sense to also have it there.
> 
> So this patch will allow us to cleanup acpi_lpss.c. We can now remove the
> confusing "shared clock" structure where the hard coded rates are held. This
> device is the only one that would need it.
> 

Oh ya...you are right. Sorry about that. I have mixed up the context with other I/O components.

Reviewed-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>

> 
> Thanks,
> 
> --
> heikki
