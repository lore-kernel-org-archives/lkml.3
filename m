Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaJBKoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:44:32 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:56155 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaJBKoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:44:30 -0400
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
Date: Thu, 02 Oct 2014 12:44:11 +0200
Message-ID: <2433277.SBXQyCNNAQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141002095536.GI1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <6852466.Q5TXcWChqW@wuerfel> <20141002095536.GI1786@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:N6DscbaiaY4tECts+CxeL0XkXWZGudBIm7zHDQi3fbk
 W8ff4QJFI9Rd9UIcmNI7au+TU/omzVCMVRhRpSeSMcWjXO4KsF
 i8Z31psKEfRRJYAhdK4TaTJAO3I9MmnLUFpqiovKB9nH+9a9oA
 7CDRY/nE6njJB4qwrml1lrhwPIHzt9GT1NsHzxEPJla5RpfovS
 ykcgGq8GR+rmi5Zby05uEYrONYq7wAQxQZ3Qqzuet5HTww2eRw
 48NEaak5V0RzgssleQe0vGAMRBbPP7U4atOSFdgV5O07vhZOLk
 hmy1JyyOHIKe8nHdZFmLrxB/sc9e+y7TGredjdr8gRyz3Z1W4n
 qROSBRg39RLzy5M1HS2w=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 October 2014 12:55:36 Mika Westerberg wrote:
> On Wed, Oct 01, 2014 at 04:14:20PM +0200, Arnd Bergmann wrote:
> > On Wednesday 01 October 2014 17:04:41 Mika Westerberg wrote:
> > > 
> > > > On the question what to put into the name and type fields, that is
> > > > unrelated. The type is supposed to be for the 'device_type' property
> > > > in DT, which we should never rely on in a driver that supports both
> > > > APCI and DT. In Linux we only use that for "pci", "cpu" and "memory",
> > > > all of which have their own way of getting probed in ACPI.
> > > > The "name" is normally ignored in DT as well, except for backwards
> > > > compatibility with old bindings, but I would argue that you should not
> > > > just put "prp0001" in there. Either leave it empty like type, or use
> > > > the name of the device as it appears in the ACPI tables, such as "DEV0"
> > > > or "PWM".
> > > 
> > > OK, I think it makes sense to leave them empty. I remember I tried that
> > > at some point but it didn't work without N and T fields. Is there some
> > > example what to put there in case of empty?
> > > 
> > > Something like "of:N*T*Cgpio-leds" perhaps?
> > 
> > Sorry, don't know. If I read the code right, the type field in DT ends
> > up being "<NULL>" for any device that doesn't set the device_type 
> > property, but that seems a bit silly and probably isn't worth copying.
> 
> OK, I checked and udev wants to have both N and T but they can be left
> empty. If there are no objections the modalias will look like this:
> 
> [root@mnw01 ~]# cat /sys/bus/spi/devices/spi-PRP0001\:00/modalias 
> of:Nat25TCatmel,at25
> 
> In other words name is the ACPI device name (AT25) in lower case, T is
> left empty and C is the compatible property.

Yes, seems ok to me.

	Arnd
