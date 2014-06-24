Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaFXOum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:50:42 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61513 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbaFXOuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:50:40 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 24 Jun 2014 16:50:03 +0200
From: Johan Hovold <johan@kernel.org>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Johan Hovold <johan@kernel.org>, Greg KH <greg@kroah.com>,
        Janne Kanniainen <janne.kanniainen@gmail.com>, jkosina@suse.cz,
        cooloney@gmail.com, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v10] leds: USB: HID: Add support for MSI GT683R led panels
Message-ID: <20140624145003.GA6607@localhost>
References: <20140623161723.GA20421@kroah.com>
 <1403543808-8228-1-git-send-email-janne.kanniainen@gmail.com>
 <20140623182324.GA30831@kroah.com>
 <20140623182432.GB30831@kroah.com>
 <20140623193134.GA15945@localhost>
 <20140623194059.GA19615@kroah.com>
 <20140623195212.GB15945@localhost>
 <20140623202448.GB29035@kroah.com>
 <20140623204430.GC15945@localhost>
 <871tuewizw.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <871tuewizw.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 03:10:43PM +0200, Bjørn Mork wrote:
> Johan Hovold <johan@kernel.org> writes:
> 
> > This is a non-standard attribute of this particular laptop. It has three
> > individual LEDs that can be enabled separately (using standard LED class
> > attributes), but they will all three be in the same "mode" (which here
> > apparently means that they can be fully on, vary with the volume(?!), or
> > pulse synchronously when enabled).
> >
> > If we were to implement this mode attribute as a class attribute,
> > changing the mode of of one LED would also change the mode of the other
> > two devices (LEDs).
> 
> Document this behaviour and it becomes a feature.

Yeah, you're right. That is probably the best way to handle this.

Janne, could you send two separate patches on top of v9 that fixes the
use-before-initialisation (reported by Oliver) and moves the led_mode
attribute from the parent HID device to the led-class devices (thereby
fixing the race reported by Greg)?

As the "led_"-prefix will then be redundant, you should probably rename
the attribute as "msi_mode" or similar (just "mode" might be too
generic).

Remember to update the ABI documentation as well, including mentioning
the fact that changing the mode of one LED will update the mode of its
two sibling devices as well (as suggested by Bjørn).

Thanks,
Johan
