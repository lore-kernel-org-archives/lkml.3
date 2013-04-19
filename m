Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030763Ab3DSOoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:44:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:12085 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030615Ab3DSOon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:44:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,509,1363158000"; 
   d="scan'208";a="321733789"
Message-ID: <1366382678.7932.104.camel@smile>
Subject: Re: [PATCH] platform: fall-back to driver name check if there is no
 id found
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Hein Tibosch <hein_tibosch@yahoo.es>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 19 Apr 2013 17:44:38 +0300
In-Reply-To: <CAMPhdO-JikYPS8v5icF69QRCsvspSfBSUvTfUwYyuhUOg4LNOQ@mail.gmail.com>
References: <51713A25.308@yahoo.es>
	 <CAMPhdO-JikYPS8v5icF69QRCsvspSfBSUvTfUwYyuhUOg4LNOQ@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 21:20 +0800, Eric Miao wrote: 
> On Fri, Apr 19, 2013 at 8:35 PM, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
> > Hi Andy, Mika,
> >
> > On 8 Feb 2013, Andy Shevchenko wrote:
> >
> >> Some of the platform devices rely on the name of their driver to match with. In
> >> the current implementation, if platform id table is needed, they have to add
> >> the name to the platform id table which sounds alogical. The patch adjustes the
> >> logic of the id table matching to make sure we will fall-back to match by the
> >> driver name. This will make it similar to the DT or ACPI cases.
> >>
> >> Signed-off-by: Andy Shevchenko <andriy.shevchenko@xxxxxxxxxxxxxxx>
> >> Reported-by: Mika Westerberg <mika.westerberg@xxxxxxxxxxxxxxx>
> >> Cc: Eric Miao <eric.miao@xxxxxxxxxxx>
> >> Cc: Greg Kroah-Hartman <gregkh@xxxxxxx>
> >> ---
> >>  drivers/base/platform.c |    4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> >> index c0b8df3..452ba4b 100644
> >> --- a/drivers/base/platform.c
> >> +++ b/drivers/base/platform.c
> >> @@ -732,8 +732,8 @@ static int platform_match(struct device *dev, struct device_driver *drv)
> >>               return 1;
> >>
> >>       /* Then try to match against the id table */
> >> -     if (pdrv->id_table)
> >> -             return platform_match_id(pdrv->id_table, pdev) != NULL;
> >> +     if (pdrv->id_table && platform_match_id(pdrv->id_table, pdev))
> >> +             return 1;
> >>
> >>       /* fall-back to driver name match */
> >>       return (strcmp(pdev->name, drv->name) == 0);
> >
> > When I upgraded an avr32 system from 3.8 to a recent next release, I found it was
> > broken: DMA was not available because the dw_dma driver did not get probed anymore.
> >
> > The dw_dma driver does have a id_table, but the boards in arch/avr32 are still expecting
> > driver identification by name.
> 
> I think this is a different philosophy here. I'm actually fine with either. The
> questions are really:
> 
> 1. will it be a bit inconsistent if the driver is using id_table,
> while the device
> is still using a legacy way?

Legacy way may be considered as a fall-back.

> 2. instead of introducing a different logic in the platform driver core code,
> is it possible this could be fixed at the board level?

It might be fixed in the driver, though I think that is ugly approach,
by adding name of the driver into its id_table.

P.S. There are actually a few drivers in current mainline that uses
mentioned approach, but with this patch it will be not needed anymore.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
