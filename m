Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3HWJ26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:28:58 -0400
Received: from smtp2-1.goneo.de ([212.90.139.83]:43665 "EHLO smtp2-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab3HWJ25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:28:57 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.859
From: Lars Poeschel <poeschel@lemonage.de>
To: "Rymarkiewicz, WaldemarX" <waldemarx.rymarkiewicz@intel.com>
Subject: Re: [linux-nfc] [PATCH RFC] nfc: add a driver for pn532 connected on uart
Date: Fri, 23 Aug 2013 11:28:47 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>,
        "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
        "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-nfc@lists.01.org" <linux-nfc@ml01.01.org>
References: <1377181699-1668-1-git-send-email-larsi@wh2.tu-dresden.de> <A4DEEF93D8D14A418311321B77DB71E9C9D773@IRSMSX104.ger.corp.intel.com>
In-Reply-To: <A4DEEF93D8D14A418311321B77DB71E9C9D773@IRSMSX104.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308231128.47731.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 August 2013 at 07:23:00, Rymarkiewicz, WaldemarX wrote:
> Hi  Lars,
> 
> >This adds a driver for the nxp pn532 nfc chip.
> >It is not meant for merging. Instead it is meant to show that some
> >progress has been made and what the current state is and to help
> >testing.
> >Although I can do some basic things with this driver I expect it to
> >contain lots of bugs. Be aware!
> >This driver is heavily based on the pn533 driver and duplicates much
> >code. This has do be factored out some time.
> 
> I'm not sure if this is expected approach adding new drivers. You
> duplicates most of pn533 code which is not good.

Yes, I know that and I explicitly mentioned that. I had to get this chip 
working somehow and I had to begin somewhere. The pn533 driver is really 
very hard to understand with it's massive use of nested callbacks, 
workqueues and usb urbs. So I took the approach to try to understand what 
happens while modifying and would then later factor out what both drivers 
have in common. The other way is understanding the code first and then 
decide what would be needed for both chips, factor that out and then write 
the pn532 uart specific stuff. And this uart stuff is a pain itself in 
linux. This way seemed much harder to me, especially as I have no pn533 
device to test which things will break.

> Also, note that pn533 and pn532  are pretty the same chips (with small
> differences) and it would be quite natural to support both with one
> driver. Pn533 already reads chip version on init, so at this point you
> already know with which chip you are dealing with.
> 
> I suggest to separate transport layer from the core in pn533 and add
> support for uart and usb separately. This is exactly what I've planned
> while changing pn533 to support acr122 device.

Yes, I agree with you this should be done. I'll expect it to be challenging 
but based on my previous work this could be doable. I'll look into that in 
my next free timeslot. I'll not be able to do that in the next two months. 
Sorry.

Thank you for your comments,
Lars
