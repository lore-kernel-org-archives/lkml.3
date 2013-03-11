Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3CKSeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:34:01 -0400
Received: from qmta02.westchester.pa.mail.comcast.net ([76.96.62.24]:60863
	"EHLO qmta02.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247Ab3CKSeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:34:00 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Mar 2013 14:34:00 EDT
Date: Mon, 11 Mar 2013 14:26:51 -0400
From: Frank Peters <frank.peters@comcast.net>
To: linux-kernel@vger.kernel.org
Subject: USB Mouse Disconnect Kernel-3.7/3.8
Message-Id: <20130311142651.12cc0311887f69db13913986@comcast.net>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.16; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When I boot my x64 Linux system to the console a continuous series
of "USB disconnect/reconnect" messages appears in the kernel log.
The disconnect/reconnect messages concern the USB mouse:

usb 1-1.3: USB disconnect, device number N
usb 1-1.3: new low-speed USB device number N+1 using ehci-pci
input: Microsoft  Microsoft Basic Optical Mouse v2.0  as /devices/pci0000:00/0000:00:1a.0 usb1/1-1/1-1.3/1-1.3:1.0/input/input5
hid-generic 0003:045E:00CB.0006: input: USB HID v1.11 Mouse [Microsoft  Microsoft Basic Optical Mouse v2.0 ] on usb-0000:00:1a.0-1.3/input0
....

These "USB disconnect/reconnect" messages will repeat roughly every 40 seconds
with the device number "N" increasing to "N+1" each time.

The interesting thing about this behavior is that I can stop the messages,
and presumably the disconnects, by starting the General Purpose Mouse (gpm)
server:

gpm -m /dev/input/mice -t imps2

If I then terminate the gpm server, the USB disconnect/reconnect messages
will start to occur once again.

The USB disconnects also stop when I start the graphical X server.

It would seem that if nothing is "grabbing" the USB mouse (i.e. gpm or X)
then the kernel somehow automatically disconnects it.

My system has the USB built in to the kernel (no modules).

The motherboard I use is Intel DP55KG which has the P55 Express
chipset to control the USB.

I've seen this behavior on the current kernel-3.8.x and also
on the previous kernel-3.7.  I have not tested anything earlier.

Please CC to frank.peters@comcast.net as I am not subscribed to
the list.

Frank Peters

