Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3EGKIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:08:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36256 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab3EGKIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:08:34 -0400
MIME-Version: 1.0
In-Reply-To: <5188905A.4020703@zytor.com>
References: <5188905A.4020703@zytor.com>
Date: Tue, 7 May 2013 10:10:36 +0200
Message-ID: <CAN+gG=F3ZpTFj99azqrw0Sq4WNhP3HkKptDEc82myqCq-9Z6JA@mail.gmail.com>
Subject: Re: Lenovo Yoga 13 touchpad regression
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 7:25 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Hello,
>
> The touchpad on Lenovo Yoga 13 seems to have broken some time between 3.4
> and the current kernel.  The dmesg is full of spewage:
>
> [  256.246481] atkbd serio0: Use 'setkeycodes e03e <keycode>' to make it
> known.
> [  256.251473] atkbd serio0: Unknown key released (translated set 2, code
> 0xbe on isa0060/serio0
>
> ... about once per second; I am wondering if the touchpad is spewing output
> onto the keyboard channel or if there is something else wrong.
>
> I have tried i8042.nomux and i8042.noloop to no effect.
>
> Unless someone has a better idea I'll try to do a bisect.

On top of Kevin's answer:

I already saw that with Yoga 13 laptops.
The touchpad went into this mode, and Linux was not able to recognize
it anymore.
What "solves" the pb was to stop the machine, then go to the bios (or
UEFI), then the touchpad was back alive when the guy rebooted under
Linux. I bet the bios managed to set the touchpad in the right mode
where Linux can then handle it correctly.

This is not an ideal solution, but at least this may help restoring
your touchpad to a functional state while the correct driver is being
developed.

Anyway, if you are able to do a real bisect (instead of my dirty
trick), that would be great because it would help fixing the problem.

Cheers,
Benjamin
