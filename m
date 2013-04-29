Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab3D2VW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:22:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62405 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab3D2VWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:22:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
Date: Mon, 29 Apr 2013 23:22:18 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, David Brown <davidb@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>
References: <20130429162115.GA6893@kroah.com> <201304292250.47699.arnd@arndb.de> <CA+55aFzxyB375fKXW37e2JBB57VwMw6UWccRwWSGn_zUa0J7SA@mail.gmail.com>
In-Reply-To: <CA+55aFzxyB375fKXW37e2JBB57VwMw6UWccRwWSGn_zUa0J7SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304292322.18971.arnd@arndb.de>
X-Provags-ID: V02:K0:a+3fgi/rgfrQ513Dly0alMM/k4FbGkCoWBKjEfuFhNQ
 6XoXK9BEfflmusK/waOAgA0q7boatHEK9Izn+ZYS0tWK6yh5HK
 a4OQvADdMUQbUhnqtUr3BvLf4Cb32ZfyREc/SsuaYL2Kbw3ZcT
 GXT05AjFrt+i4xDjENkJgwNtr26nPP4BbaexttzrWrMV1em+Q2
 p3t8JyuPOa46D+KyrZoaxDzTGyX0maAYzem69Sww4eJeg6bXNW
 H6KcToAxoeVkFh8eZ21nT6B4WiSzMj9eHM90LDsoAkF/jgXXWy
 CYL+xzgHCPPMyo+j9XmWh0RmJVmReccF11TzIN5rwHFFHz1YPg
 v8T9cUU3qzorFTGQ45M4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 April 2013, Linus Torvalds wrote:
> On Mon, Apr 29, 2013 at 1:50 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > Fair enough. Of course the distinction here is not based on what it
> > does, but how it gets used.
> 
> Even technically, a "bus" generally has a topology. It has addresses,
> and it has a protocol.
> 
> i2c is a bus. PCI is a bus. And something like SSB is a bus. There is
> a protocol, there's device with identity on the bus, there's stuff
> going on.

Right. I was looking at it from the linux driver model perspective,
where we already call a lot of things a bus that are not at all one in
the engineering sense.

> The SBBI driver has neither addresses nor a protocol. It's literally
> just an embedded on-chip serial device as far as I can tell. There's
> nothing "bus" about it. It's just a hose.
>
> Yeah, yeah, at some point you can call "anything" a bus. I could call
> my little two-seater car a "school bus", because it has wheels, it's
> even yellow exactly like the school buses around here. And I can put a
> child in it. So my little yellow two-seater must be a bus too. It's
> all just how you define your words.
> 
> But it's a damn big reach. I didn't use to call the serial line
> connecting my computer to the modem a "bus". Even if it connected two
> devices.

It seems I looked too briefly. As you point out and David already
confirmed, there is only one device on the other side, which is indeed
a major difference to e.g. SPI, which seems rather similar otherwise
but can use chip-select pins to multiplex between different endpoints.
Certainly this hardware could do the same, but you are right that it's
not relevant because it doesn't do that in practice.

	Arnd
