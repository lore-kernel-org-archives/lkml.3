Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbaKTJSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:18:45 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:55503 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731AbaKTJSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:18:43 -0500
MIME-Version: 1.0
In-Reply-To: <546CBFAC.9040906@free.fr>
References: <546C920A.7060800@free.fr>
	<546CB0EB.9080005@suse.de>
	<546CBFAC.9040906@free.fr>
Date: Thu, 20 Nov 2014 14:48:42 +0530
X-Google-Sender-Auth: d-OTdTjUWhPlxw_Bda2LXYOiFZc
Message-ID: <CAOh2x=n9zHiyoqOJuh2PzuS1_GYCQhYWB5LPL7MW8hUPQ1yTsg@mail.gmail.com>
Subject: Re: Looking for good references for ARM driver development
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mason <mpeg.blue@free.fr>
Cc: =?ISO-8859-1?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Device Tree <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 9:35 PM, Mason <mpeg.blue@free.fr> wrote:
> Is there an exhaustive list of available buses (on the ARM platform)
> and an overview of when/where each one is appropriate?

Not sure if its mentioned that clearly anywhere. BUT bus is normally
bound by the way you need to access registers of a device.

For example, if a device's registers are accessible via SPI, then it has
to register on SPI. Similarly for I2C, USB, UART, PCI, etc..

The only special cases are Platform and AMBA. Both these are for
the devices which are directly accessible from Soc bus.

AMBA is specifically for the IPs designed by ARM. All these IPs have
their vendor/version information at a predefined offset and so the AMBA
bus core reads that value to make device/driver bindings. i.e. It doesn't
depend on matching .name string in device/driver structures.

Whereas platform is for all other devices accessible over Soc bus. Device
and drivers are matches here based on the .name string as their is no
ID to read from hardware.
