Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3AVNvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:51:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50920 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab3AVNvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:51:12 -0500
Date: Tue, 22 Jan 2013 14:51:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Brad Tilley <brad@16s.us>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: PROBLEM: 3.8.0-rc4 keyboard failure at boot
In-Reply-To: <20130122134658.GA27683@16s.us>
Message-ID: <alpine.LNX.2.00.1301221449090.20374@pobox.suse.cz>
References: <20130121213604.GA31225@16s.us> <20130122001346.GD16638@core.coreip.homeip.net> <alpine.LNX.2.00.1301221122380.20374@pobox.suse.cz> <20130122121947.GB27072@16s.us> <alpine.LNX.2.00.1301221341550.20374@pobox.suse.cz>
 <20130122134658.GA27683@16s.us>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013, Brad Tilley wrote:

> > Could you please provide dmesg output from both working and non-working 
> > case?
> 
> See attached. Two dmesgs from the same machine. One from 3.7.3, the 
> other from 3.8-rc4 (with a ps2 keyboard). USB keyboards on this machine 
> never work with 3.8, but always works with 3.7.
> 
> I used an old ps2 keyboard to enter the dm-crypt password. After that, 
> the boot process continues and the USB keyboard and mouse become active 
> and begin to work. However, USB keyboards do not work when the user is 
> prompted to enter the dm-crypt decryption password early in the boot 
> process. That's the primary issue.

Ah, I see, that's a very important piece of information. This might be 
related to USB BIOS handoff then.

Do you happen to have "Legacy USB" option (or similar, such as "USB 
emulation" the name is not consistent between different BIOS vendors and 
versions) in your BIOS? Does toggling it change the behavior?

Adding linux-usb@ to CC.

> 
> > Also /proc/bus/input/devices content would be interesting (in case you are 
> > able to log remotely into the machine).
> 
> See attached. One from 3.7.3 the other from 3.8-rc4 (again, the 3.8 
> kernel is using a ps2 keyboard and a USB keyboard).
> 
> > Does replugging the keyboard fix the problem with 50% probability?
> 
> Replugging the keyboard does not fix the problem, nor does plugging it 
> into different USB ports or swapping USB keyboards.
> 
> > Are other USB devices (such as mice) affected by this as well?
> 
> Users are attempting to enter the dm-crypt decryption password during 
> boot so they have not noticed nor complained about mouse failure, only 
> keyboard failure.

-- 
Jiri Kosina
SUSE Labs
