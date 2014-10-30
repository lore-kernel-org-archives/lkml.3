Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606AbaJ3PQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:16:39 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:63909 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbaJ3PQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:16:37 -0400
MIME-Version: 1.0
In-Reply-To: <20141029102754.GM1304@lahna.fi.intel.com>
References: <1414153014-152246-1-git-send-email-mika.westerberg@linux.intel.com>
	<1414153014-152246-2-git-send-email-mika.westerberg@linux.intel.com>
	<CACRpkdZ=+NmhivkNyjcgjDonypnXLdSBPdHQnbm8KS17pxK9NA@mail.gmail.com>
	<20141029102754.GM1304@lahna.fi.intel.com>
Date: Thu, 30 Oct 2014 16:16:36 +0100
Message-ID: <CACRpkdbUb_cxbF=GtX=Q-zafx_7OiEHGPZuuxSfFvQ0nCtqs_g@mail.gmail.com>
Subject: Re: [PATCH 1/4] gpio / ACPI: Add knowledge about pin controllers to acpi_get_gpiod()
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 11:27 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Wed, Oct 29, 2014 at 10:41:19AM +0100, Linus Walleij wrote:

>> But I have a vague idea that there is something like a numberspace
>> concept inside ACPI as well, and that is all magic to me...
>> mixing that into this is a bit scary to me.
(...)
>         # grep SATA_GP1 pins
>         pin 76 (SATA_GP1) mode 1 ctrl0 0x00010200 ctrl1 0x04c00000
>
>         # cat gpio-ranges
>         GPIO ranges handled:
>         0: INT33FF:00 GPIOS [456 - 463] PINS [0 - 7]
>         8: INT33FF:00 GPIOS [464 - 471] PINS [15 - 22]
>         16: INT33FF:00 GPIOS [472 - 479] PINS [30 - 37]
>         24: INT33FF:00 GPIOS [480 - 487] PINS [45 - 52]
>         32: INT33FF:00 GPIOS [488 - 495] PINS [60 - 67]
>         40: INT33FF:00 GPIOS [496 - 503] PINS [75 - 82]
>         48: INT33FF:00 GPIOS [504 - 511] PINS [90 - 97]
>
> In other words GPIO number for pin 76 is 496 (in Linux global number
> space) and 41 in the GPIO driver local number space.
>
> In order to translate the ACPI GPIO number 76 to the right GPIO number
> we iterate over each range in the GPIO driver and look for the match.
> Note that it actually uses the local number (41) here:

OK what I was mainly worrying about was that it would go and
use the Linux GPIO numbers in any way. As long as the mechanism
relies on the local pin controller or GPIO chip offsets I'm happy.

Yours,
Linus Walleij
