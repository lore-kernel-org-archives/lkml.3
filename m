Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaAUCPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 21:15:23 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:40374 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaAUCPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 21:15:17 -0500
MIME-Version: 1.0
Date: Tue, 21 Jan 2014 03:15:15 +0100
Message-ID: <CAMeQTsZhBV=OtuktfS4Da5Sq+76J_oNsXd8AjeTJCqoPGxC3GA@mail.gmail.com>
Subject: Backlight driver for MacBook Air 6,1 and 6,2
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, mjg59@srcf.ucam.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew and CCs

I've put together (rather quickly) a driver for directly handling the backlight
driver chip (LM8550) on the 2013 MacBook Air. It is needed to work around a bug
(likely in firmware) that occurs after suspend/resume. See:

https://bugs.freedesktop.org/show_bug.cgi?id=67454

This seems to fall outside of what the i915 driver should handle and thus need a
separate driver. It's available at: https://github.com/patjak/mba6x_bl

The MacBook Air provides ACPI backlight methods but they also break after
suspend. I'm planning to mainline this and have a few questions.

1) I'm accessing the LP8550 on the SMBUS through ACPI methods. Should I access
the SMBUS directly instead or is this ok? I probably need to look at locking
around SMBUS accesses.

2) Is DMI the proper way of probing? Currently I'm just checking if the chip is
there and that it returns the proper contents in an identifier byte.

3) I assume the backlight type should be BACKLIGHT_PLATFORM (currently
BACKLIGHT_FIRMWARE) but do I also need to blacklist the ACPI backlight on these
devices? How do I get the proper precedence over other backlight devices?

Is there still time to get this into 3.14-rc1?

Thanks
Patrik
