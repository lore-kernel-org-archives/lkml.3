Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaJAKBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 06:01:47 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:50820 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaJAKBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 06:01:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
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
Date: Wed, 01 Oct 2014 12:01:34 +0200
Message-ID: <5364565.aEcZqpzdLW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141001091309.GY1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <2780318.hxubhI9Rvq@wuerfel> <20141001091309.GY1786@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5BzYj3zvIf9A9S2ElqI3MsZE6CdxEZT7nN0cS8jrHpP
 iiRbZAm2F4TrVM8l6od3Enr0VSQHYXbeNEZI8kb/vl56YsXFGN
 i2RvzUJm8vhI58GFCmqe0pJ16e9u1HT+Ts6rmHNuyvICVAaGre
 vxJm9ao+uy5l0RS71VIOWipXn4aDqYIjNNusBLAlizfVxH+Wlk
 Ny4jMlQkO19lM3zblugoqIr+KbGmXgy+YneYqBildjGlxbP7Cv
 DWKz/SoC1ppVFhEzr6JV1a3LgseQaXMFkbyk3Auzd72Wtneenk
 h/dRUy2n1OniUgQAa3fg0u89z+9Y+Idlk/zQ4rNx58etEcVmzG
 3GCOv0Cww2aoUN51Vj+4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 12:13:09 Mika Westerberg wrote:
> 
> > Regarding the MODULE_DEVICE_TABLE, I suspect the above won't work the
> > way you are hoping for, because once you get to dozens or hundreds of
> > drivers doing this, each device will show up with the same string,
> > so udev will try to load all the modules that list "PRP0001". That
> > doesn't look right. With the code from patch 3, you can probably drop
> > the acpi MODULE_DEVICE_TABLE() entirely and get the correct behavior.
> 
> It actually works like this now:
> 
>  # cd /sys/bus/platform/devices/PRP0001\:00/
>  DRIVER=leds-gpio
>  MODALIAS=of:Nprp0001TacpiCgpio-leds
> 
>  # cat modalias 
>  of:Nprp0001TacpiCgpio-leds
> 
> In other words the modalias changes to be of:Nprp0001Tacpi, e.g
> name=prp0001, type=acpi and then list of compatible values.
> 
> Udev then loads only module that matches the modalias so it should not
> load everything listing PRP0001 in their MODULE_DEVICE_TABLE().

I'm not completely following yet. I can see how this works now, but
how is this better than just using the existing modalias for OF?

	Arnd
