Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaJGJcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:32:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:58338 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbaJGJcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:32:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,669,1406617200"; 
   d="scan'208";a="601660060"
Date: Tue, 7 Oct 2014 12:32:03 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 05/13] misc: at25: Make use of device property API
Message-ID: <20141007093203.GL1583@lahna.fi.intel.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
 <1443736.WYtVLjNfzc@vostro.rjw.lan>
 <CAMuHMdXHRbbjf8WJHwtZEgdctmVSMzjOKXfd9a1YcHundBG4-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXHRbbjf8WJHwtZEgdctmVSMzjOKXfd9a1YcHundBG4-Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 11:10:23AM +0200, Geert Uytterhoeven wrote:
> On Tue, Oct 7, 2014 at 2:14 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > @@ -301,35 +301,33 @@ static ssize_t at25_mem_write(struct memory_accessor *mem, const char *buf,
> >
> >  /*-------------------------------------------------------------------------*/
> >
> > -static int at25_np_to_chip(struct device *dev,
> > -                          struct device_node *np,
> > -                          struct spi_eeprom *chip)
> > +static int at25_fw_to_chip(struct device *dev, struct spi_eeprom *chip)
> >  {
> >         u32 val;
> >
> >         memset(chip, 0, sizeof(*chip));
> > -       strncpy(chip->name, np->name, sizeof(chip->name));
> > +       strncpy(chip->name, "at25", sizeof(chip->name));
> 
> So this changes chip->name from "eeprom" (or whatever name the DTS
> writer used; "eeprom" is the ePAPR-compliant name) to "at25"?

Yes.

Is there something depending on that name?

> Note:The example in Documentation/devicetree/bindings/misc/at25.txt
> uses "at25", not "eeprom".

Which is the same we use here.
