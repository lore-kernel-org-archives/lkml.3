Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3FFQYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:24:36 -0400
Received: from linuxdingsda.de ([87.106.20.67]:50727 "EHLO serverteil.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751638Ab3FFQYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:24:35 -0400
Message-ID: <51B0B7B2.7080400@linuxdingsda.de>
Date: Thu, 06 Jun 2013 18:24:18 +0200
From: Tobias Winter <tobias@linuxdingsda.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Increase the number of USB to serial devices we can
 support at once
References: <20130605175426.GA13461@kroah.com> <20130606150112.GA22984@redhat.com> <20130606152131.GA6935@kroah.com>
In-Reply-To: <20130606152131.GA6935@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.06.2013 17:21, Greg KH wrote:
> On Thu, Jun 06, 2013 at 11:01:12AM -0400, Dave Jones wrote:
>> On Wed, Jun 05, 2013 at 10:54:26AM -0700, Greg KH wrote:
>>  > These patches make the USB to serial core have the ability to support up
>>  > to 3000 devices at once now.  
>>
>> I'm curious how this works. What systems have 3000 usb ports ?
Surely no one thought that a system could have 255 devices of that sort
~15 years ago. Isn't the idea always to support more that what is possible?
>> Or are there some kind of multiplexer devices out there ?
>> (If so, I'd like a link, I could use one of those).
> 
> You don't need a multiplexer, you can have a bunch of different USB root
> hubs in PCI slots, with USB hubs plugged into them, and lots of
> multi-port USB devices connected to them.  Tobias has such a system with
> 272 single-port USB to serial devices connected, so it's not impossible
> to create.
Correct. Since you can only have 127 devices on a single USB root-hub,
the trick is to spread the devices over many root-hubs. Most mainboards
already come with 3-5 root-hubs on-board and you of course can expand
that via pci/pcie cards, but be warned, for reasons beyond my
imagination, the XHCI specification lets the root-hub vendor decice on
how many devices it can support, so you could end up having XHCI
root-hubs that support lets say 20 devices.

> In thinking about it some more, I'll change that number to 500 for now,
> as it's a static array within the tty layer, and then work on making
> that dynamic so we don't have any limitations other than the number of
> minor numbers for a single major.
I also thought about it and I'd say 512 devices is about as high as I
would go in any real-world application, otherwise the fallout of a
broken system is slowly getting to big, depending on what you do over
the serial ports. Also 512 is a nice number. ;)

Tobias

