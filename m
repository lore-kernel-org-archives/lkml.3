Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaJVIdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:33:47 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:63188 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaJVIdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:33:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: GPIO bindings guidelines (Was: Re: [PATCH v5 10/12] gpio: Support for unified device properties interface)
Date: Wed, 22 Oct 2014 10:33:32 +0200
Message-ID: <4711930.7fsc2oSxcp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141022081044.GB1484@lahna.fi.intel.com>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com> <4582579.9WMrIMALsy@wuerfel> <20141022081044.GB1484@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ogxXZkeVArwdv5rtcnMgxTbEGeyU1pTN5pPKQtiZlkA
 +9OUxNwYTmWRozchyUXZVqlAM9fPayYbaqTqMw13VUO8gSCTPf
 4pLQDyypotMp1Ke10dbFVrumyMQ0B0uoHWQMfF427vihw9akN2
 FzajdI+W9CKyv2BpV3320yHKh7BYMMgLZ+kaRH3BW+QZHpbh/u
 x56HWrRdt2BkQB+Ojm/7mklTgUnAdvG2KtY95BOeRG9w7bPFxO
 7jaVmkKzKVV1ca+gN7iJfZya+Z4aufaz2sGTo1Babe2DwIAfsb
 IFNg5Xets+VE/3TRLCzLdTAnW0WHpzJ4H+l91t4XirYW4/isE+
 z069PaaupWIdEqrO2pYg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2014 11:10:44 Mika Westerberg wrote:
> 
> It expects that GPIOs returned from _CRS are in specific order. Since we
> can't change these existing ACPI tables, we must support them somehow.
> 
> This patch series handles it so that:
> 
>   1) If we can't find given property (e.g "reset-gpios" or
>      "shutdown-gpios") the index above will refer directly to the GPIO
>      resource returned from _CRS.
> 
>   2) If the property is found we ignore index and take it from the
>      property instead.
> 
> This has the drawback that we cannot support this:
> 
>         Package () { "reset-gpios", Package () { ^GPIO, 0, 0, 0, ^GPIO, 1, 0, 0}}
>                                                                  ^^^^^^^^^^^^^^
> So the second entry in the above is not accessible using
> gpiod_get_index() and the reason is that we want to support the existing
> and new ACPI tables where _DSD is not being used.

So this is not using the DT binding but does thing slightly differently then.
In this case (supporting two incompatible bindings for DT and ACPI), I think
the only sensible driver implementation would be to know what we are asking
for and use different devm_gpiod_get_index statements based on the firmware
interface.

	Arnd
