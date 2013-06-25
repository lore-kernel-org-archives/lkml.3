Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab3FYL0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:26:19 -0400
Received: from zougloub.eu ([188.165.233.99]:45708 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab3FYL0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:26:18 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2013 07:26:18 EDT
Date: Tue, 25 Jun 2013 07:20:08 -0400
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: xhci_hcd: Signal/Timeout while waiting for evaluate context command
 then Assuming host is dying, halting host
Message-ID: <20130625072008.350e44e1@Vantage.pnp.gw>
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.18; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am seeing that with an acquisition board:

[27044.406737] usb 4-4.4: usb_probe_device
[27044.406739] usb 4-4.4: configuration #1 chosen from 1 choice
[27044.406803] usb 4-4.4: Successful Endpoint Configure command
[27044.418946] usb 4-4.4: Successful evaluate context command
[27044.421725] usb 4-4.4: Successful evaluate context command
[27044.425133] usb 4-4.4: adding 4-4.4:1.0 (config #1, interface 0)
[27098.096802] usb 4-4.4: Successful evaluate context command
[27098.096993] usb 4-4.4: Successful evaluate context command
[27098.100436] usb 4-4.4: Successful evaluate context command
[27307.822372] xhci_hcd 0000:00:14.0: Signal while waiting for evaluate context command
[27307.822381] usb 4-4.4: Could not disable xHCI U2 timeout, bus schedule bandwidth may be impacted.
[27307.822493] xhci_hcd 0000:00:14.0: Signal while waiting for evaluate context command
[27307.822500] usb 4-4.4: Could not enable U1 link state, xHCI error -62.
[27878.845220] xhci_hcd 0000:00:14.0: Timeout while waiting for evaluate context command
[27878.845230] usb 4-4.4: Could not disable xHCI U2 timeout, bus schedule bandwidth may be impacted.
[27883.840337] xhci_hcd 0000:00:14.0: Timeout while waiting for evaluate context command
[27883.840348] usb 4-4.4: Could not enable U1 link state, xHCI error -62.
[27888.955329] xhci_hcd 0000:00:14.0: xHCI host not responding to stop endpoint command.
[27888.955336] xhci_hcd 0000:00:14.0: Assuming host is dying, halting host.
[27888.955396] xhci_hcd 0000:00:14.0: HC died; cleaning up
[27888.955419] hub 3-0:1.0: state 0 ports 4 chg 0000 evt 0000
[27888.955426] usb 3-4: USB disconnect, device number 2
[27888.955428] usb 3-4: unregistering device
[27888.955430] usb 3-4: unregistering interface 3-4:1.0
[27888.955559] usb 3-4: usb_disable_device nuking all URBs
[27888.955701] xhci_hcd 0000:00:14.0: Slot 2 endpoint 2 not removed from BW list!
[27888.955715] hub 4-0:1.0: state 0 ports 4 chg 0000 evt 0000
[27888.955719] usb 4-4: USB disconnect, device number 8
[27888.955722] usb 4-4.4: USB disconnect, device number 15
[27888.955723] usb 4-4.4: unregistering device
[27888.955726] usb 4-4.4: unregistering interface 4-4.4:1.0
[27888.955763] usb 4-4.4: Failed to set U1 timeout to 0x0,error code -19
[27888.955767] usb 4-4.4: Set SEL for device-initiated U1 failed.
[27888.955769] usb 4-4.4: Set SEL for device-initiated U2 failed.
[27888.955785] usb 4-4.4: Failed to set U1 timeout to 0x0,error code -19
[27888.955788] usb 4-4.4: Set SEL for device-initiated U1 failed.
[27888.955790] usb 4-4.4: Set SEL for device-initiated U2 failed.
[27888.955794] usb 4-4.4: usb_disable_device nuking all URBs
[27888.955891] usb 4-4: unregistering device
[27888.955893] usb 4-4: unregistering interface 4-4:1.0
[27888.955925] usb 4-4: Failed to set U1 timeout to 0x0,error code -19
[27888.955929] usb 4-4: Set SEL for device-initiated U1 failed.
[27888.955931] usb 4-4: Set SEL for device-initiated U2 failed.
[27888.955996] usb 4-4: Failed to set U1 timeout to 0x0,error code -19
[27888.956000] usb 4-4: Set SEL for device-initiated U1 failed.
[27888.956004] usb 4-4: Set SEL for device-initiated U2 failed.
[27888.956007] usb 4-4: usb_disable_device nuking all URBs

Today this was running linux 3.10-rc6 but I've seen that before.

This is very similar to a report I found here:
http://ubuntuforums.org/showthread.php?t=2149484

Has anybody seen that?

In my case I'm using libusb to talk with a board.

Note: this is running on an Intel Sandy Bridge USB3.0 port...
So far I have seen many issues with non-Intel USB3.0 controllers
and that same board.

Thanks,

-- 
cJ
