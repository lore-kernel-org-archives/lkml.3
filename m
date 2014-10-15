Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaJOPM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:12:56 -0400
Received: from twosheds.infradead.org ([90.155.92.209]:45248 "EHLO
	twosheds.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaJOPMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:12:53 -0400
Message-ID: <db4038336b5e165b8b61eda064b10eeb.squirrel@twosheds.infradead.org>
In-Reply-To: <20141015134209.GD20034@leverpostej>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
    <1413378271.2762.77.camel@infradead.org>
    <20141015131551.GC20034@leverpostej>
    <1413379736.2762.79.camel@infradead.org>
    <20141015134209.GD20034@leverpostej>
Date: Wed, 15 Oct 2014 14:08:09 -0000
Subject: Re: [PATCH v4 00/13] Add ACPI _DSD and unified device properties
 support
From: "David Woodhouse" <dwmw2@infradead.org>
To: "Mark Rutland" <mark.rutland@arm.com>
Cc: "David Woodhouse" <dwmw2@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Mika Westerberg" <mika.westerberg@linux.intel.com>,
        "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
        "Aaron Lu" <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Alexandre Courbot" <gnurou@gmail.com>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Bryan Wu" <cooloney@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Darren Hart" <dvhart@linux.intel.com>
User-Agent: SquirrelMail/1.4.22-14.fc20
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by twosheds.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> We have been checking for all DT platforms, and that's a bug for DT.
> Copying that bug to ACPI is inexcusable given we know it's a bug to do
> so.

We'll, perhaps it should be named 'used-by-firmware' and actually it's
just as valid under ACPI as it is on RTAS systems. All it does is stop the
OS from using the port.

> I understand that. However, where a binding doesn't make sense (as in
> this case), it shouldn't be enabled for ACPI as it provides a larger
> surface area for misuse, for no benefit.

These are *optional* properties. They were optional precisely *because*
they only make sense in some cases. I don't know that it makes sense to
take them away. The benefit we get is *consistency*. For example if
someone *does* use the property in question as 'used-by-firmware' and
expects the OS not to touch it, we don't want that to change behaviour
between ACPI and fdt boots.

-- 
dwmw2

