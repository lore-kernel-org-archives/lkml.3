Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3A3IIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:08:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:36788 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3A3IIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:08:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,566,1355126400"; 
   d="scan'208";a="280238941"
Message-ID: <1359533274.31148.52.camel@smile>
Subject: Re: [PATCH] dw_dmac: adjust slave_id accordingly to request line
 base
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Date: Wed, 30 Jan 2013 10:07:54 +0200
In-Reply-To: <CAOh2x==Ng1=iHOj-55mUTWCwpaJpRXjiQyfxz-a48ALDOW3aiA@mail.gmail.com>
References: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x==psH4fYmr_MxwO8vjYb=sWk=V7Vs8fs_-6U00gmiko_w@mail.gmail.com>
	 <20130129052247.GH2239@intel.com>
	 <CAOh2x=nTJ1iz9aoR8VrkE5A+iaLMMbvFeebGPsO8KWRpDLw7=A@mail.gmail.com>
	 <1359531176.31148.46.camel@smile>
	 <CAOh2x==Ng1=iHOj-55mUTWCwpaJpRXjiQyfxz-a48ALDOW3aiA@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-30 at 13:31 +0530, Viresh Kumar wrote: 
> On Wed, Jan 30, 2013 at 1:02 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > We get a device from the ACPI CSRT table. During enumeration we don't
> > know what kind of the device it is. From the enumeration point of view
> > each device enumerated from CSRT is a platform device (see
> > drivers/acpi/csrt.c for the details).
> >
> > That's why we have to pass this info somehow to the DMAC driver. And
> > like Mika already mentioned we have no other generic way except
> > IORESOURCE_DMA. If you have something better in mind, please share. We
> > could adopt our code then.
> 
> You don't need this in DT case too? 

I think no. It seems the DT has a proper backlink from the slave device
to the dmac ("dma-names" property if I understood it correctly).

> Or only for ACPI case?

ACPI 5 case only until now.
We would like to initiate the proposal to the ACPI specification
team/whoever to have this part designed better in next versions.

> I think "Yes" is the answer of both the questions. If so, then you
> can keep it this way or add another variable in platform data.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
