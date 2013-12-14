Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3LNSul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 13:50:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56990 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3LNSuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 13:50:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: mach-moxart: add MOXA ART SoC platform files
Date: Sat, 14 Dec 2013 19:50:09 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Guenter Roeck <linux@roeck-us.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
References: <1386945188-8316-1-git-send-email-jonas.jensen@gmail.com> <52AC7E41.7050201@roeck-us.net> <CACmBeS3Xse5KkFqkM5Ye+qaaxpVCjyeGz7Oc9sr0PN+pZ9sztQ@mail.gmail.com>
In-Reply-To: <CACmBeS3Xse5KkFqkM5Ye+qaaxpVCjyeGz7Oc9sr0PN+pZ9sztQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312141950.09447.arnd@arndb.de>
X-Provags-ID: V02:K0:SgnWjTB809BedXaojBXVVPbhKo1hjYZr9UcQjorjgAT
 2jjhmvgxPDxpiWu7FRhhywlboubvUATokHOa9E00n2iY677zSX
 YWKvdEpSbp9pTtNtmBFDXKMYDz5HcB9W9244wSH3ht3XLN3fu+
 48LK6swQ97rKXR0ReeJfD9NPT6IkjL4pCekbyb5t3znd3t0UBk
 RDZLnpJQBDezx79i7l9BHHVaBR5TMeTwgT/INKlPyo57Iu+oqA
 na4pc3B+qOVXE9ao5UyHtyPxKbLx6o6H0oyEAliE4fmrYpOgT1
 mlTOV14oN8xSSNT93bOGbuFfh1uOkwjly/EBDS6dOQAdP7LngS
 Ohikf/pZEzOj4UjAXKXs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 December 2013, Jonas Jensen wrote:
> >
> > Conceptually it might be cleaner to write a separate driver, for example
> > in drivers/power/restart, than plugging the functionality into
> > the watchdog driver, at least if you don't want it in architecture
> > or platform code. The xgene restart driver is a good example.
> >
> 
> Moving it to a new power/restart driver seems reasonable to me, I'm
> really just looking for a home for it, I would have preferred a
> hardware with reset in a separate register though.
> 
> I now plan to remove it for v5 and submit a separate driver.

I still think it's better to leave it in the watchdog driver: This
driver attaches to the watchdog device, and adding a separate driver
for reset means we have to trick the core Linux code into attaching
two drivers to one device in some way, or the device tree has to fake
a second device that doesn't exist in hardware but is only needed
because of Linux implementation details.

	Arnd
