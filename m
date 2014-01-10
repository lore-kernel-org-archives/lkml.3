Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaAJH75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:59:57 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:48519 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaAJH7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:59:55 -0500
Date: Fri, 10 Jan 2014 08:59:39 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Benson Leung <bleung@chromium.org>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        andriy.shevchenko@linux.intel.com, jacmet@sunsite.dk,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Duncan Laurie <dlaurie@chromium.org>
Subject: Re: [PATCH 2/2] i2c-designware-pci: Index Haswell ULT bus names
 from 0
Message-ID: <20140110085939.3d96c7e6@endymion.delvare>
In-Reply-To: <CANLzEkvgYQtkEyOMNpPcS9BeYzX3zJn7hvtsyhFzbDpViS8-2Q@mail.gmail.com>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
	<1382326010-4554-3-git-send-email-bleung@chromium.org>
	<20131021065804.GX3521@intel.com>
	<CANLzEksGqD30Cefh3r2urH-ToxWzkxAnTJZiY07yX2Py58FQPw@mail.gmail.com>
	<20131114180538.GK11022@katana>
	<CANLzEksP1nRfBaQ3-sSouOYL4C+oLKiE75eHfFdEzLmrQKn3dQ@mail.gmail.com>
	<20131126130959.GI7427@katana>
	<20140103155217.GG7132@katana>
	<CANLzEkvgYQtkEyOMNpPcS9BeYzX3zJn7hvtsyhFzbDpViS8-2Q@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jan 2014 16:12:14 -0800, Benson Leung wrote:
> Our devices and our platforms have some other requirements which
> turned me away from using i2c_register_board_info.
> 
> i2c_register_board_info looks to create predeclarations for a specific
> i2c bus... However, right now, the chromeos_laptop driver is
> structured to do explicit declaration (using i2c_new_probed_device)
> *after* the busses have come up.
> 
> Specifically, we have a class of atmel_mxt i2c touchpad/touchscreen
> devices that may appear at different addresses depending on whether
> the touch device is in bootloader mode or operational mode.
> 
> For that reason, the chromeos_laptop driver uses i2c_new_probed_device
> with a list of possible addresses when dealing with the atmel touch
> device.
> 
> You can see the driver here :
> drivers/platform/chrome/chromeos_laptop.c
> 
> Is there some way of getting the "probe" behavior while using
> i2c_register_board_info?

No, i2c_register_board_info works only for devices which are always
present at a known address.

-- 
Jean Delvare
