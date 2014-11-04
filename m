Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaKDOim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:38:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:21380 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbaKDOih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:38:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="scan'208";a="602005227"
Date: Tue, 4 Nov 2014 16:38:01 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <darren.hart@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>
Subject: Re: [PATCH v6 04/12] misc: at25: Make use of device property API
Message-ID: <20141104143801.GM1618@lahna.fi.intel.com>
References: <13750506.S2yVlRRDa2@vostro.rjw.lan>
 <5019278.RtDq7RlWqt@vostro.rjw.lan>
 <20141104141826.36F8AC408F6@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104141826.36F8AC408F6@trevor.secretlab.ca>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 02:18:26PM +0000, Grant Likely wrote:
> > -	strncpy(chip->name, np->name, sizeof(chip->name));
> > +	strncpy(chip->name, "at25", sizeof(chip->name));
> 
> This line changes behaviour of the driver. It's possibly not a problem,
> but it should be commented on and whether any due diligance has been
> done to make sure it there isn't anything that depends on it.

I found only one user for "atmel,at25" in any of the DT sample files.

arch/arm/boot/dts/phy3250.dts:

	eeprom: at25@0 {
		...
		at25,byte-len = <0x8000>;
		at25,addr-mode = <2>;
		at25,page-size = <64>;

		compatible = "atmel,at25";
		reg = <0>;
		spi-max-frequency = <5000000>;
	};

I think np->name is "at25" in this case? The binding file
Documentation/devicetree/bindings/misc/at25.txt also has the same name.

Are you OK, if we add something like below to the changelog?

 In addition we hard-code the name of the chip to be "at25" for the
 reason that there is no common mechanism to fetch name of the firmware
 node. The only existing user (arch/arm/boot/dts/phy3250.dts) uses the
 same name so it should continue to work.

> Otherwise:
> Acked-by: Grant Likely <grant.likely@linaro.org>

Thanks.
