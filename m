Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3LGQKV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 11:10:21 -0500
Received: from dd8000.kasserver.com ([85.13.132.92]:54984 "EHLO
	dd8000.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3LGQKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 11:10:18 -0500
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Dec 2013 11:10:18 EST
Message-ID: <52A346C9.7090009@gmx.net>
Date: Sat, 07 Dec 2013 17:03:21 +0100
From: Otto Meier <gf435@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: xhci USB3 on h87 does behave buggy
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just changed MB for my Home Server from GA75N to H87-ITX.

Attached to this server I run 3 WINTV HVR 930C DVB-C usb receivers.
with the Series Seven MB everything works as it should. with the H87
MB the USB3 Stack crashed as soon as i get more then one Stream from
the DVB-C receivers.

the Error Message is:

2013-12-07T12:29:23.935232+01:00 vnas kernel: [  591.234611] xhci_hcd
0000:00:14.0: xHCI host not responding to stop endpoint command.
2013-12-07T12:29:23.935243+01:00 vnas kernel: [  591.234614] xhci_hcd
0000:00:14.0: Assuming host is dying, halting host.
2013-12-07T12:29:23.935244+01:00 vnas kernel: [  591.234662] xhci_hcd
0000:00:14.0: HC died; cleaning up
2013-12-07T12:29:23.935248+01:00 vnas kernel: [  591.234679] usb 3-3:
USB disconnect, device number 2
2013-12-07T12:29:23.935249+01:00 vnas kernel: [  591.234681] usb 3-3.1:
USB disconnect, device number 6
2013-12-07T12:29:23.935505+01:00 vnas pcscd[2715]: 48591788
ifdwrapper.c:348:IFDStatusICC() Card not transacted: 612
2013-12-07T12:29:23.935688+01:00 vnas pcscd[2715]: 00000008
eventhandler.c:303:EHStatusHandlerThread() Error communicating to:
SCR3310 Smart Card Reader [CCID Interface (21120519102521) 00 00
2013-12-07T12:29:23.936112+01:00 vnas kernel: [  591.234802] cp210x
ttyUSB1: cp210x converter now disconnected from ttyUSB1
2013-12-07T12:29:23.936116+01:00 vnas kernel: [  591.234811] cp210x
3-3.1:1.0: device disconnected
2013-12-07T12:29:23.937251+01:00 vnas kernel: [  591.236161] em2884 #0:
writing to i2c device at 0x52 failed (error=-5)
2013-12-07T12:29:23.937256+01:00 vnas kernel: [  591.236163] drxk: i2c
write error at addr 0x29
2013-12-07T12:29:23.937257+01:00 vnas kernel: [  591.236165] drxk:
write_block: i2c write error at addr 0x831ffd
2013-12-07T12:29:23.937258+01:00 vnas kernel: [  591.236168] em2884 #1:
writing to i2c device at 0x52 failed (error=-5)
2013-12-07T12:29:23.937258+01:00 vnas kernel: [  591.236169] drxk: i2c
read error at addr 0x29
2013-12-07T12:29:23.937259+01:00 vnas kernel: [  591.236201] usb 3-3.2:
USB disconnect, device number 7
2013-12-07T12:29:23.937259+01:00 vnas kernel: [  591.236307] em2884 #1:
writing to i2c device at 0xc2 failed (error=-19)
2013-12-07T12:29:23.937260+01:00 vnas kernel: [  591.236309] xc5000: I2C
read failed
2013-12-07T12:29:23.937269+01:00 vnas kernel: [  591.236310] xc5000:
waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
2013-12-07T12:29:23.937270+01:00 vnas kernel: [  591.236327] xc5000:
firmware read 12401 bytes.
2013-12-07T12:29:23.937270+01:00 vnas kernel: [  591.236327] xc5000:
firmware uploading...
2013-12-07T12:29:23.937271+01:00 vnas kernel: [  591.236330] em2884 #1:
writing to i2c device at 0xc2 failed (error=-19)
2013-12-07T12:29:23.937271+01:00 vnas kernel: [  591.236331] xc5000: I2C
write failed (len=3)
2013-12-07T12:29:23.937272+01:00 vnas kernel: [  591.236332] xc5000:
firmware upload failed...
2013-12-07T12:29:23.937272+01:00 vnas kernel: [  591.236335] em2884 #1:
writing to i2c device at 0x52 failed (error=-19)
2013-12-07T12:29:23.937273+01:00 vnas kernel: [  591.236336] drxk: i2c
read error at addr 0x29
2013-12-07T12:29:23.937273+01:00 vnas kernel: [  591.236337] drxk: Error
-19 on mpegts_stop
2013-12-07T12:29:23.937274+01:00 vnas kernel: [  591.236338] em2884 #1:
writing to i2c device at 0x52 failed (error=-19)
2013-12-07T12:29:23.937274+01:00 vnas kernel: [  591.236338] drxk: i2c
write error at addr 0x29
2013-12-07T12:29:23.937275+01:00 vnas kernel: [  591.236339] drxk: Error
-19 on setoperation_mode
2013-12-07T12:29:23.937275+01:00 vnas kernel: [  591.236340] drxk: Error
-22 on start
2013-12-07T12:29:23.937276+01:00 vnas kernel: [  591.236372] drxk: Error
-22 on get_lock_status

No USB device is working anymore this is only fixable with reboot.

With only one DVB-C receiver attached everthing is working.

if have tried kernel 3.11.10 3.12.3 3.13-rc3.

SO:

The system works fine with H75 usb3 xhci.
the System crashes with H87 usb3 xhci and more than one DVB-C receivers
streaming.

Any Idea how to fix?

Bye
 
