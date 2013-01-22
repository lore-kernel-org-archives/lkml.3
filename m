Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3AVRWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:22:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab3AVRWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:22:47 -0500
Date: Tue, 22 Jan 2013 18:22:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Brad Tilley <brad@16s.us>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: PROBLEM: 3.8.0-rc4 keyboard failure at boot
In-Reply-To: <20130122134658.GA27683@16s.us>
Message-ID: <alpine.LNX.2.00.1301221821160.20374@pobox.suse.cz>
References: <20130121213604.GA31225@16s.us> <20130122001346.GD16638@core.coreip.homeip.net> <alpine.LNX.2.00.1301221122380.20374@pobox.suse.cz> <20130122121947.GB27072@16s.us> <alpine.LNX.2.00.1301221341550.20374@pobox.suse.cz>
 <20130122134658.GA27683@16s.us>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013, Brad Tilley wrote:

> See attached. Two dmesgs from the same machine. One from 3.7.3, the 
> other from 3.8-rc4 (with a ps2 keyboard). USB keyboards on this machine 
> never work with 3.8, but always works with 3.7.
> 
> I used an old ps2 keyboard to enter the dm-crypt password. After that, 
> the boot process continues and the USB keyboard and mouse become active 
> and begin to work. However, USB keyboards do not work when the user is 
> prompted to enter the dm-crypt decryption password early in the boot 
> process. That's the primary issue.

Are you sure that HID modules are loaded at the time you are being asked 
for the dmcrypt password?

In the provided dmesg, I can see

[   17.106371] usb 2-1.2: New USB device found, idVendor=413c, idProduct=2106
[   17.106376] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   17.106380] usb 2-1.2: Product: Dell QuietKey Keyboard
[   17.106382] usb 2-1.2: Manufacturer: Dell
[   17.115713] input: Dell Dell QuietKey Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input11
[   17.115968] hid-generic 0003:413C:2106.0002: input,hidraw1: USB HID v1.10 Keyboard [Dell Dell QuietKey Keyboard] onusb-0000:00:1d.0-1.2/input0

i.e. the keyboard gets properly autodeteted, but I have no idea whether 
this was before or after dm-crypt password prompt.

-- 
Jiri Kosina
SUSE Labs
