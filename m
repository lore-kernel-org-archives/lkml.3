Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaKYOpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:45:33 -0500
Received: from schorsch-tech.de ([88.198.48.118]:54245 "EHLO schorsch-tech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbaKYOpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:45:32 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Nov 2014 09:45:32 EST
Message-ID: <34ec4bedbde2ede76f23b31e337bb37f.squirrel@wm.schorsch-tech.de>
Date: Tue, 25 Nov 2014 15:39:28 +0100
Subject: Comedi device layered on top of FT232RL
From: georg@schorsch-tech.de
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.23 [SVN]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi LKML,
right now i try to understand if the following thing is possible:

I have an embedded device with an FT232RL interface which gets
handled by ftdi_ser.ko. I can with userspace tools talk to it over
/dev/ttyUSB0. The device control some digital inputs/outputs and some
ADC/DACs. All is handled over a serial protocol.

I thought about following options:
1.Userspace daemon which sits on /dev/ttyUSB0
  Pro: Easy to implement
  Con: It would not be an comedi device and thus not able to use the
       comedi features

2.Kernel driver:
  Pro: It would be possible to use the comedi interface
  Con: I would duplicate much of the code used for ftdi_ser.ko.

OFC i would like to avoid code duplication but i would like to use the
features and interface from comedi.

What is the recommended way to solve such issue?

I tried to look through the comedi drivers and found the usbdux. It
uses usb urbs to talk to its hardware. I tried to find a hint in
LDD3 book but i just got hints about talking with it with urbs.
That is why i came to option 2 (but i see the cons).

The driver would just add the parsing of the stream. Convert the
comedi calls to a stream for the device. That is in fact the thing
i want to put under the hood of comedi.

Best Regards
Georg

