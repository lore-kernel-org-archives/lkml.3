Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbaEOWfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:35:33 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:47073 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbaEOWfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:35:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Mark A. Greer" <mgreer@animalcreek.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: Re: bq24190: What's the correct API to turn boost mode (OTG) on for the battery charger ?
Date: Fri, 16 May 2014 00:35:34 +0200
Message-ID: <1782446.TpztL69o3V@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140515220844.GA10762@animalcreek.com>
References: <2044381.o3QyvTfyIx@avalon> <20140515220844.GA10762@animalcreek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thank you for the quick reply.

On Thursday 15 May 2014 15:08:44 Mark A. Greer wrote:
> On Thu, May 15, 2014 at 10:29:26PM +0200, Laurent Pinchart wrote:
> > Hello,
> 
> [Adding Anton Vorontsov to CC list.]
> 
> Hi Laurent.
> 
> > I'm trying to enable battery charging on an OMAP4 board based on a twl6030
> > PMIC with external bq24190 battery charger and bq27510 fuel gauge.
> > 
> > The system has an OTG USB port that can be used to charge the battery, and
> > that can also be used in host mode. In that case the bq24190 needs to be
> > switched to boost mode to provide the +5V power supply from the battery.
> > 
> > The bq24190 has a charge configuration register field that supports charge
> > disabled, charge enabled and OTG (boost mode). The field is set by the
> > bq24190 driver in response to setting the charge type :
> > POWER_SUPPLY_CHARGE_TYPE_NONE will disable charing, and
> > POWER_SUPPLY_CHARGE_TYPE_TRICKLE and
> > POWER_SUPPLY_CHARGE_TYPE_FAST will enable it. However, OTG boost mode is
> > not supported.
> > 
> > 
> > The driver exposes most register fields as sysfs attributes (which doesn't
> > sound very safe to me, but that's another story). I can thus enable OTG
> > boost mode directly from userspace through the driver-specific API, but
> > that just bypasses the power supply API. I'm thus not very fond of that
> > solution.
>
> No, its not a good solution.  As indicated in the commit log, the sysfs
> entries are there because there are just so many fields that don't map
> well to the existing interface.
> 
> Maybe we should add support for a DT entry to enable exporting those
> fields(disabled by default)?
> 
> > Possibly due to my really basic (not to say nonexistent) knowledge of the
> > power supply subsystem I haven't found an API to expose this feature. I
> > was wondering if someone had given a though regarding how to implement
> > this properly.
> 
> What if we just added something like POWER_SUPPLY_CHARGE_TYPE_BOOST?

That was actually my first thought, and I assumed it would be rejected as 
boost mode is not a charge type but a discharge type :-) This being said, I 
don't have enough experience with battery chargers to decide whether this is a 
good solution. If you believe it is, I'll trust you on that.

On a side note, is there any reference userspace implementation of a battery 
manager ? The vendor BSP I've received with the board hardcodes calls to the 
bq24190 in the MUSB driver to switch between OTG and trickle charge modes 
based on USB cable connection/disconnection events. That's pretty ugly, and I 
assume this should be handled in userspace - or is there a standard kernel 
infrastructure for that ? 

-- 
Regards,

Laurent Pinchart

