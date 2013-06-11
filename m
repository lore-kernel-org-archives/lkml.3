Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab3FKRKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:10:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:26258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749Ab3FKRJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:09:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,846,1363158000"; 
   d="scan'208";a="327804188"
Date: Tue, 11 Jun 2013 10:11:19 -0700
From: Bin Gao <bin.gao@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: i2c: introduce i2c helper i2c_find_client_by_name()
Message-ID: <20130611171119.GA35135@bingao-desk1.fm.intel.com>
References: <20130606183346.GA13259@bingao-desk1.fm.intel.com>
 <CAHp75VcYgpUVpOnKOzkYoZXbEPO_0QG7=WUXza55wpOyRwcKCA@mail.gmail.com>
 <20130606212620.GA13620@bingao-desk1.fm.intel.com>
 <CAHp75VcGUtWyPHrvYDW59-4g8F2m58-Us3CrbJ2bnYJdxnd1Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcGUtWyPHrvYDW59-4g8F2m58-Us3CrbJ2bnYJdxnd1Sg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 10:53:35PM +0300, Andy Shevchenko wrote:
> Please, try to avoid top posting in the future emails.
> 
> On Fri, Jun 7, 2013 at 12:26 AM, Bin Gao <bin.gao@linux.intel.com> wrote:
> > With v4l2, the camera sensor i2c devices are taken over by v4l2 master
> > driver, i.e. ISP driver, and are not expected to be accessed from
> > user sapce by ioctl. So ISP driver has to register them by itself to
> > get all related information for further communication. Please check
> > v4l2_i2c_new_subdev_board() in drivers/media/video/v4l2-common.c for details.
> 
> Yes, this is legacy approach for non-DT/non-ACPI5 platforms.

So what's the new approach for DT/ACPI5 platforms?

> 
> > The platform code can definitely disallow calling i2c_register_board_info()
> > to register them but keep the i2c devices list and then let ISP driver register
> > them. But, problems come when a single kernel is going to run on two platforms
> > - one platform has ACPI5 and the other has SFI.
> 
> You have to forget about SFI. Your ISP subdevices use plain platform
> data anyway.

Why have to forget about SFI which is supported by upstream kernel?

> In ACPI 5 case v4l2 framework must be extended to cover that case.

To extend v4l2 framework is one of the options, but this helper is also one
option.

> > The dynamic unregister and then
> > register based on this new helper will not have dependency on firmware interface -
> > the same platform code will work for all platforms.
> 
> It's not a care of the ISP driver. I think you have to talk to Sakari
> about your issues.

We have to do it in the ISP driver if we want one binary kernel
supporting multiple platforms.

> > On Thu, Jun 06, 2013 at 11:32:06PM +0300, Andy Shevchenko wrote:
> >> On Thu, Jun 6, 2013 at 9:33 PM, Bin Gao <bin.gao@linux.intel.com> wrote:
> >> > There is a requirement to get the i2c_client pointer dynamically without
> >> > knowing the bus and slave address. But we do know the client name,
> >> > i.e. the name in the i2c_board_info. This patch is to fit this requirement.
> >> >
> >> > A good example is that an ISP(Imaging Signal Processor) driver needs
> >> > register i2c camera sensor devices via v4l2, so it has to unregister
> >> > all i2c clients that were previously registered by calling
> >> > i2c_register_board_info(), and then re-register. For this case we
> >> > can use this helper to get i2c_client by passing the client name.
> >>
> >> Why ISP driver would like to register sensor drivers in the first place?
> >> That seems the task of platform code, or DT, or ACPI5
> >>
> >> Why do you need to re-register them at run time?
> 
> --
> With Best Regards,
> Andy Shevchenko
