Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab3BLQVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:21:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:9026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310Ab3BLQVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:21:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="290133809"
Date: Tue, 12 Feb 2013 07:56:41 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH] dw_dmac: adjust slave_id accordingly to request line
 base
Message-ID: <20130212155641.GL3789@intel.com>
References: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <CAOh2x==psH4fYmr_MxwO8vjYb=sWk=V7Vs8fs_-6U00gmiko_w@mail.gmail.com>
 <20130129052247.GH2239@intel.com>
 <CAOh2x=nTJ1iz9aoR8VrkE5A+iaLMMbvFeebGPsO8KWRpDLw7=A@mail.gmail.com>
 <1359531176.31148.46.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359531176.31148.46.camel@smile>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 09:32:56AM +0200, Andy Shevchenko wrote:
> On Tue, 2013-01-29 at 20:57 +0530, Viresh Kumar wrote: 
> > On Tue, Jan 29, 2013 at 10:52 AM, Mika Westerberg
> > <mika.westerberg@linux.intel.com> wrote:
> > > We had a discusssion about this with Andy as well. The thing is that there
> > > is no way in current resource to pass DMA request line numbers supported by
> > > the controller to the driver in a generic way. We on the other hand have to
> > > deal this somehow as we have a shared DMA controller on Lynxpoint where the
> > > offset will start from 16 (but it might be something else as well).
> > >
> > > Is there something which limits the usage of IORESOUCE_DMA to be only
> > > usable for ISA DMA channels?
> > 
> > Andy,
> > 
> > Why do we need this request_line_base? Why not program the actual value
> > directly into the slave structure (base + offset)?
> 
> Slave device exactly has knowledge about this number slave_id = (base
> +offset). However...
Btw request line needs to be programmed by client in slave_id field.
So why exactly is this required for dma driver?

--
~Vinod
> > In case it is required, add it in platform data field or can add DT
> > binding for it.
> 
> We get a device from the ACPI CSRT table. During enumeration we don't
> know what kind of the device it is. From the enumeration point of view
> each device enumerated from CSRT is a platform device (see
> drivers/acpi/csrt.c for the details).
> 
> That's why we have to pass this info somehow to the DMAC driver. And
> like Mika already mentioned we have no other generic way except
> IORESOURCE_DMA. If you have something better in mind, please share. We
> could adopt our code then.
> 
> 
> -- 
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Intel Finland Oy
