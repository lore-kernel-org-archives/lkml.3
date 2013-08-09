Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030829Ab3HIT3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:29:16 -0400
Received: from hydra.rus.uni-stuttgart.de ([129.69.1.55]:49473 "EHLO
	hydra.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030224Ab3HIT3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:29:15 -0400
Message-ID: <52054306.20500@rus.uni-stuttgart.de>
Date: Fri, 09 Aug 2013 21:29:10 +0200
From: Thomas Richter <richter@rus.uni-stuttgart.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux@brodo.de, linux-kernel@vger.kernel.org
Subject: Re: [HANG] Trouble with NEC-based USB adapter in PCMCIA slot on E7110
References: <Pine.LNX.4.44L0.1308091345060.1405-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308091345060.1405-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.08.2013 19:46, Alan Stern wrote:
> On Fri, 9 Aug 2013, Thomas Richter wrote:
>
>> Hi Alan, hi Dominik,
>>
>> maybe you want me to help out a bit - I'm having trouble getting a
>> Delock PCMCIA to USB-2 adapter to work under linux, with strange
>> behavior in some situations. The trouble is that while I can *read* via
>> fast (usb 2.0) transfers from the port, an ehci-triggered write just
>> locks up (it does not Oops, though) and I'm pretty much stuck narrowing
>> down the problem.
>
> The best way to start will be to enable CONFIG_USB_DEBUG in your kernel
> and post the dmesg log.  Also post a usbmon trace showing what happens
> when you try to write something.

Will try and report back, thanks. I've bisected it down in the meantime 
to a change from 2.6.31.6 to 2.6.32.6. Interestingly, this is very much 
the same time when the udev userland changed. It works with 2.6.31.6 old 
udev, but not with 2.6.36.2, new udev.

Probably the handover from full speed to USB 2.0 got broken?

Note that this laptop has now both uhci (legacy) and ohci (as by the 
pcmcia card, as companion of the ehci) chips, which probably adds to the 
problem.

Greetings,
	Thomas
