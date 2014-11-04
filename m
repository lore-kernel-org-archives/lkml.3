Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaKDPFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:05:20 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:48826 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaKDPFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:05:16 -0500
MIME-Version: 1.0
In-Reply-To: <20141104143801.GM1618@lahna.fi.intel.com>
References: <13750506.S2yVlRRDa2@vostro.rjw.lan> <5019278.RtDq7RlWqt@vostro.rjw.lan>
 <20141104141826.36F8AC408F6@trevor.secretlab.ca> <20141104143801.GM1618@lahna.fi.intel.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Tue, 4 Nov 2014 15:04:54 +0000
X-Google-Sender-Auth: Yp_6V5t2lTPHKe72BumFhaIANtE
Message-ID: <CACxGe6u5ppSjHc-Wa7K_NWQ9YEZ_V3ys9fdsECss_bPabUTN+g@mail.gmail.com>
Subject: Re: [PATCH v6 04/12] misc: at25: Make use of device property API
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <darren.hart@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 2:38 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Tue, Nov 04, 2014 at 02:18:26PM +0000, Grant Likely wrote:
>> > -   strncpy(chip->name, np->name, sizeof(chip->name));
>> > +   strncpy(chip->name, "at25", sizeof(chip->name));
>>
>> This line changes behaviour of the driver. It's possibly not a problem,
>> but it should be commented on and whether any due diligance has been
>> done to make sure it there isn't anything that depends on it.
>
> I found only one user for "atmel,at25" in any of the DT sample files.
>
> arch/arm/boot/dts/phy3250.dts:
>
>         eeprom: at25@0 {
>                 ...
>                 at25,byte-len = <0x8000>;
>                 at25,addr-mode = <2>;
>                 at25,page-size = <64>;
>
>                 compatible = "atmel,at25";
>                 reg = <0>;
>                 spi-max-frequency = <5000000>;
>         };
>
> I think np->name is "at25" in this case? The binding file
> Documentation/devicetree/bindings/misc/at25.txt also has the same name.
>
> Are you OK, if we add something like below to the changelog?
>
>  In addition we hard-code the name of the chip to be "at25" for the
>  reason that there is no common mechanism to fetch name of the firmware
>  node. The only existing user (arch/arm/boot/dts/phy3250.dts) uses the
>  same name so it should continue to work.

Yes. If somebody complains, then we can reinstate the previous
behaviour, but assume it isn't necessary for now.

g.
