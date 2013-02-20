Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935952Ab3BTGNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:13:49 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:51742 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666Ab3BTGNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:13:46 -0500
Subject: Re: Fwd: mmc card probe not getting called
From: anish kumar <anish198519851985@gmail.com>
To: chetan cr123 <chetancr123@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAJ8diHSUhqgKugY3Yvnst_cPxdXHAXPWe-itGJjQOiztu-obhw@mail.gmail.com>
References: <CAJ8diHTq6ayQjciiu_9fXyHYTk4DorT=5uw=759zHo7B81-e4w@mail.gmail.com>
	 <CAJ8diHT5Ze3bsPGO7yLqPHu6niuDC_gtjJB=gKGoUXOfvoHtyw@mail.gmail.com>
	 <1361289343.16206.35.camel@anish-Inspiron-N5050>
	 <CAJ8diHSUhqgKugY3Yvnst_cPxdXHAXPWe-itGJjQOiztu-obhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Feb 2013 11:43:11 +0530
Message-ID: <1361340791.16206.38.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 11:25 +0530, chetan cr123 wrote:
Avoiding top posting.
> Hi Anish,
> 
> Thanks for your reply,
> 
> I was doing device registration for device by giving same name as
> driver name, This i used to do in platform driver registration,
> 
> But i dont know how to do for mmc device registration,
> 
> And i also want to know which part of the code(file name) is doing the
> string compare with the driver and device names and calling the probe
> function. can u please point me to that part of code. from many days i
> was searching from which part of code where string compare is done and
> calls the probe function.
> 
> 
> Kindly point me out to that part of code.
look at drivers/base/dd.c
static int really_probe(struct device *dev, struct device_driver *drv)
{
//snip
        if (dev->bus->probe) {
                ret = dev->bus->probe(dev);
                if (ret)
                        goto probe_failed;
        } else if (drv->probe) {
                ret = drv->probe(dev);
                if (ret)
                        goto probe_failed;
        }
Tip:Whenever you want to see how some function is being called use
dump_stack().This will give you the call chain leading up to your
function call which you are interested in.
> 
> 
> 
> On Tue, Feb 19, 2013 at 9:25 PM, anish kumar
> <anish198519851985@gmail.com> wrote:
> > On Tue, 2013-02-19 at 12:16 +0530, chetan cr123 wrote:
> >> HI All,
> >>
> >> I am working on Sd Card/Block driver
> >>
> >> I am registering it as both
> >>
> >> 1. register_blkdev()-------------  BLOCK Regsiter
> >> 2. mmc_register_driver ------  MMC regsiter
> >>
> >> and filling the mmc_driver structure.
> >>
> >> I am not able to see the probe of MMC, But i see the return value of
> >> mmc_register function returning success.
> > I am not an expert on MMC driver but AFAIK it is no different in terms
> > of following device/driver model.
> > Probe of a function is only called when device name matches with driver
> > name and when it happens driver calls your probe.
> >
> > So in your case even though you have registered the driver, looks like
> > you are missing the device registration part.Do that and see the magic.
> > If this is SOC then that is done in the board file i.e.
> > arch/arm/plat-xyz/....
> >
> >>
> >> Kindly let me know how i make the probe of mmc getting called
> >>
> >> Thanks
> >>
> >>
> >> Chetan
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >
> >


