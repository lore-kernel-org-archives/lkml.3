Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaJAL7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:59:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:28293 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaJAL7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:59:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,632,1406617200"; 
   d="scan'208";a="599261547"
Date: Wed, 1 Oct 2014 14:59:01 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 10/15] leds: leds-gpio: Add ACPI probing support
Message-ID: <20141001115901.GD1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <2780318.hxubhI9Rvq@wuerfel>
 <20141001091309.GY1786@lahna.fi.intel.com>
 <5364565.aEcZqpzdLW@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5364565.aEcZqpzdLW@wuerfel>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 12:01:34PM +0200, Arnd Bergmann wrote:
> On Wednesday 01 October 2014 12:13:09 Mika Westerberg wrote:
> > 
> > > Regarding the MODULE_DEVICE_TABLE, I suspect the above won't work the
> > > way you are hoping for, because once you get to dozens or hundreds of
> > > drivers doing this, each device will show up with the same string,
> > > so udev will try to load all the modules that list "PRP0001". That
> > > doesn't look right. With the code from patch 3, you can probably drop
> > > the acpi MODULE_DEVICE_TABLE() entirely and get the correct behavior.
> > 
> > It actually works like this now:
> > 
> >  # cd /sys/bus/platform/devices/PRP0001\:00/
> >  DRIVER=leds-gpio
> >  MODALIAS=of:Nprp0001TacpiCgpio-leds
> > 
> >  # cat modalias 
> >  of:Nprp0001TacpiCgpio-leds
> > 
> > In other words the modalias changes to be of:Nprp0001Tacpi, e.g
> > name=prp0001, type=acpi and then list of compatible values.
> > 
> > Udev then loads only module that matches the modalias so it should not
> > load everything listing PRP0001 in their MODULE_DEVICE_TABLE().
> 
> I'm not completely following yet. I can see how this works now, but
> how is this better than just using the existing modalias for OF?

You mean using just what of_device_get_modalias() would create? In that
case, what do we put to name and type fields?
