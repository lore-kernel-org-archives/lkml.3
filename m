Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897Ab3CMPpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:45:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932910Ab3CMPpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:45:52 -0400
Date: Wed, 13 Mar 2013 16:45:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Frank Peters <frank.peters@comcast.net>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB Mouse Disconnect Kernel-3.7/3.8
In-Reply-To: <20130311142651.12cc0311887f69db13913986@comcast.net>
Message-ID: <alpine.LRH.2.00.1303131644570.27467@twin.jikos.cz>
References: <20130311142651.12cc0311887f69db13913986@comcast.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Mar 2013, Frank Peters wrote:

> When I boot my x64 Linux system to the console a continuous series
> of "USB disconnect/reconnect" messages appears in the kernel log.
> The disconnect/reconnect messages concern the USB mouse:
> 
> usb 1-1.3: USB disconnect, device number N
> usb 1-1.3: new low-speed USB device number N+1 using ehci-pci
> input: Microsoft  Microsoft Basic Optical Mouse v2.0  as /devices/pci0000:00/0000:00:1a.0 usb1/1-1/1-1.3/1-1.3:1.0/input/input5
> hid-generic 0003:045E:00CB.0006: input: USB HID v1.11 Mouse [Microsoft  Microsoft Basic Optical Mouse v2.0 ] on usb-0000:00:1a.0-1.3/input0
> ....
> 
> These "USB disconnect/reconnect" messages will repeat roughly every 40 seconds
> with the device number "N" increasing to "N+1" each time.
> 
> The interesting thing about this behavior is that I can stop the messages,
> and presumably the disconnects, by starting the General Purpose Mouse (gpm)
> server:
> 
> gpm -m /dev/input/mice -t imps2
> 
> If I then terminate the gpm server, the USB disconnect/reconnect messages
> will start to occur once again.
> 
> The USB disconnects also stop when I start the graphical X server.
> 
> It would seem that if nothing is "grabbing" the USB mouse (i.e. gpm or X)
> then the kernel somehow automatically disconnects it.
> 
> My system has the USB built in to the kernel (no modules).
> 
> The motherboard I use is Intel DP55KG which has the P55 Express
> chipset to control the USB.
> 
> I've seen this behavior on the current kernel-3.8.x and also
> on the previous kernel-3.7.  I have not tested anything earlier.
> 
> Please CC to frank.peters@comcast.net as I am not subscribed to
> the list.

[ adding linux-usb@ to CC ]

Do you have USB autosuspend enabled on that device?

-- 
Jiri Kosina
SUSE Labs

