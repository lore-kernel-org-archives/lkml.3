Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbaEOWQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:16:37 -0400
Received: from p3plsmtpa09-02.prod.phx3.secureserver.net ([173.201.193.231]:58584
	"EHLO p3plsmtpa09-02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbaEOWQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:16:36 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2014 18:16:36 EDT
Date: Thu, 15 May 2014 15:08:44 -0700
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: Re: bq24190: What's the correct API to turn boost mode (OTG) on
 for the battery charger ?
Message-ID: <20140515220844.GA10762@animalcreek.com>
References: <2044381.o3QyvTfyIx@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2044381.o3QyvTfyIx@avalon>
Organization: Animal Creek Technologies, Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 10:29:26PM +0200, Laurent Pinchart wrote:
> Hello,

[Adding Anton Vorontsov to CC list.]

Hi Laurent.

> I'm trying to enable battery charging on an OMAP4 board based on a twl6030 
> PMIC with external bq24190 battery charger and bq27510 fuel gauge.
> 
> The system has an OTG USB port that can be used to charge the battery, and 
> that can also be used in host mode. In that case the bq24190 needs to be 
> switched to boost mode to provide the +5V power supply from the battery.
> 
> The bq24190 has a charge configuration register field that supports charge 
> disabled, charge enabled and OTG (boost mode). The field is set by the bq24190 
> driver in response to setting the charge type : POWER_SUPPLY_CHARGE_TYPE_NONE 
> will disable charing, and POWER_SUPPLY_CHARGE_TYPE_TRICKLE and 
> POWER_SUPPLY_CHARGE_TYPE_FAST will enable it. However, OTG boost mode is not 
> supported.


> 
> The driver exposes most register fields as sysfs attributes (which doesn't 
> sound very safe to me, but that's another story). I can thus enable OTG boost 
> mode directly from userspace through the driver-specific API, but that just 
> bypasses the power supply API. I'm thus not very fond of that solution.

No, its not a good solution.  As indicated in the commit log, the sysfs
entries are there because there are just so many fields that don't map
well to the existing interface.

Maybe we should add support for a DT entry to enable exporting those
fields(disabled by default)?

> Possibly due to my really basic (not to say nonexistent) knowledge of the 
> power supply subsystem I haven't found an API to expose this feature. I was 
> wondering if someone had given a though regarding how to implement this 
> properly.

What if we just added something like POWER_SUPPLY_CHARGE_TYPE_BOOST?

Mark
--
