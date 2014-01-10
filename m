Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaAJAMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 19:12:19 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:51172 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaAJAMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:12:17 -0500
MIME-Version: 1.0
In-Reply-To: <20140103155217.GG7132@katana>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
	<1382326010-4554-3-git-send-email-bleung@chromium.org>
	<20131021065804.GX3521@intel.com>
	<CANLzEksGqD30Cefh3r2urH-ToxWzkxAnTJZiY07yX2Py58FQPw@mail.gmail.com>
	<20131114180538.GK11022@katana>
	<CANLzEksP1nRfBaQ3-sSouOYL4C+oLKiE75eHfFdEzLmrQKn3dQ@mail.gmail.com>
	<20131126130959.GI7427@katana>
	<20140103155217.GG7132@katana>
Date: Thu, 9 Jan 2014 16:12:14 -0800
X-Google-Sender-Auth: 9O6FTYqPJ8WGUJKaDBGaQ3aOj_w
Message-ID: <CANLzEkvgYQtkEyOMNpPcS9BeYzX3zJn7hvtsyhFzbDpViS8-2Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] i2c-designware-pci: Index Haswell ULT bus names from 0
From: Benson Leung <bleung@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, khali@linux-fr.org,
        andriy.shevchenko@linux.intel.com, jacmet@sunsite.dk,
        linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Duncan Laurie <dlaurie@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Thank you for the advice. Sorry for the delay in my response.
(sorry for the duplicated message. I neglected to set plain text in my
email editor).

On Fri, Jan 3, 2014 at 7:52 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> > I am not sure I get the problem. If you use i2c_register_board_info() to
> > register the known devices on the designware busses the dynamically
> > assigned numbers are guaranteed to be enumarated higer than the static
> > ones. Check drivers/i2c/i2c-boardinfo.c.
>
> Ping. Was this helpful or do you still have the issue?

Our devices and our platforms have some other requirements which
turned me away from using i2c_register_board_info.

i2c_register_board_info looks to create predeclarations for a specific
i2c bus... However, right now, the chromeos_laptop driver is
structured to do explicit declaration (using i2c_new_probed_device)
*after* the busses have come up.

Specifically, we have a class of atmel_mxt i2c touchpad/touchscreen
devices that may appear at different addresses depending on whether
the touch device is in bootloader mode or operational mode.

For that reason, the chromeos_laptop driver uses i2c_new_probed_device
with a list of possible addresses when dealing with the atmel touch
device.

You can see the driver here :
drivers/platform/chrome/chromeos_laptop.c

Is there some way of getting the "probe" behavior while using
i2c_register_board_info?



-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
