Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101AbaLPMJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 07:09:15 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:49862 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaLPMJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 07:09:13 -0500
Date: Tue, 16 Dec 2014 13:09:11 +0100
From: Johan Hovold <johan@kernel.org>
To: "D. Hugh Redelmeier" <hugh@mimosa.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: problem with ELAN touchscreen
Message-ID: <20141216120911.GK6778@localhost>
References: <alpine.LRH.2.02.1403041904350.32070@redclaw.mimosa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1403041904350.32070@redclaw.mimosa.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 11:27:02PM -0500, D. Hugh Redelmeier wrote:
> I have a Lenovo Yoga 2 pro with an ELAN touchscreen.
> I am running Fedora 20 with Fedora's 3.13.5-200.fc20.x86_64 kernel.
> 
> During initialization, there is a lot of delay and noise detecting the
> touchscreen.
> 
> I'm not the first to report this problem but I don't know what can or
> should be done.  But there doesn't seem to be a solution so far.
> Can we figure one out?

I just stumbled across this message from March.

The problem with your touchscreen should have been fixed in v3.18 by commits:

	2a159389bf5d ("USB: core: add device-qualifier quirk")
	0b750b3baa2d ("HID: usbhid: add always-poll quirk")

and

	d749947561af ("USB: quirks: enable device-qualifier quirk for yet another Elan touchscreen")
	1af39588f84c ("HID: usbhid: enable always-poll quirk for Elan Touchscreen 016f")

They have also been backported to at least the v3.17 (.3+) stable kernels.

Have you tried any of these kernels?

> My uneducated theories:
> 
> - The touchscreen is slow to initialize and talking to it before it is
>   read starts it initializing again.  This seems unlikely: the
>   USB system poked my touchscreen over 72 seconds before a good
>   outcome happened.
> 
> - the touchscreen needs the Windows enumeration method (see below).
> 
> - there is a firmware bug that could be fixed (but probably only if it
>   shows up in Windows, and I don't think that it does).
> 
> - something else
> 
> What can I do to help move this forward?
> 
> Here are the old reports.  My information is at the end.
> 
> <http://www.spinics.net/lists/linux-usb/msg94582.html>
> 
>   (2013 September)
> 
>   Sarah Sharp suggested that this might be a hardware bug and asked if
>   the device were still under warranty.
> 
>   A number of instances of this behaviour can be found by googling.
>   This suggests that any bug in the hardware is in many (all?)
>   of these touchscreens.  That's the kind of problem that
>   manufacturers resist dealing with.
> 
> <http://www.spinics.net/lists/linux-usb/msg95796.html>
> 
>   (Later in the same thread)
> 
>   Sarah suggests that the device might need to be enumberated using
>   the "Windows" scheme.  She also wondered if the problematic device
>   was actually the ELAN touchscreen (but the numbering suggests so to
>   me).
> 
>   Has anyone tried that enumeration method?
> 
>   The thread ended here.
> 
> 
> <http://www.spinics.net/lists/linux-usb/msg100342.html>
>   (2013 December)
> 
>   Apparently the same problem. ASUS N550JV-DB72T with ELAN
>   touchscreen.
> 
>   Sarah suggests that there might be electrical issues with the
>   internally connected touchscreen.  (I doubt that since there
>   are so many independant reports.)
> 
>   Alan Stern suggests intermittent hardware problems.
> 
> <https://lists.fedoraproject.org/pipermail/test/2013-October/118402.html>
>   (2013 Oct)
> 
>   Richard Ryniker reports the same problem with a Samsung Book 9 plus
>   with an ELAN touchscreen.
> 
> <http://marc.info/?l=linux-kernel&m=138299522418665&w=2>
> 
>   (2013 October)
> 
>   Kevin Fenzi-2 reports the same problem with a Lenovo Yoga 2 pro with
>   an ELAN touchscreen.
> 
>   Was first thought to be a regression.  Instead, it seemed to be
>   affected by debugging code.  My guess: timing.
> 
> <http://marc.info/?l=linux-kernel&m=139012354602664&w=2>
> 
>   (2014 January)
> 
>   In the same thread, another victim (Eric) showed up.
> 
> <http://forums.gentoo.org/viewtopic-p-7500028.html>
> 
>   (2013 November)
> 
>   andretti reports the same problem with a Samsung Ativ Book 9 plus
>   and an ELAN touchscreen.
> 
>   A suggestion was the make the xhci driver a module.  Not results
>   were reported.
> 
> <https://bbs.archlinux.org/viewtopic.php?id=172587>
> 
>   (2013 November)
> 
>   eweber reports teh same problem with a Lenovo Yoga 2 pro.
> 
> <keithcu.com/wordpress/?p=3270>
> 
>   (2013 November)
> 
>   KeithCU mentions briefly that:
> 
> 	My logfile fills up with USB (and other) error messages.
> 
> 	usb 2-7: unable to read config index 0 descriptor/start -71
> 
> <http://forums.debian.net/viewtopic.php?f=5&t=111550>
> 
>   (2014 February)
> 
>   A new Debian user hits this.  Unknown computer with ELAN touchpad.
> 
> 
> Here are selected sequences of dmesg output from one boot on my system.
> Notice that this process adds over a minute to booting time!
> 
> I think that the relevant status numbers are:
> 
> #define	EPROTO		71	/* Protocol error */
> 
> #define	ETIMEDOUT	110	/* Connection timed out */
> 
> [    4.210824] usb 2-7: unable to read config index 0 descriptor/start: -71
> [    4.210830] usb 2-7: can't read configurations, error -71
> [    4.363159] usb 2-7: new full-speed USB device number 5 using xhci_hcd
> [    6.511501] usb 2-7: unable to read config index 0 descriptor/start: -71
> [    6.511507] usb 2-7: can't read configurations, error -71
> [    6.714942] usb 2-8: new high-speed USB device number 7 using xhci_hcd
> [    6.735448] usb 2-8: New USB device found, idVendor=1bcf, idProduct=2c43
> [    6.735454] usb 2-8: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    6.735457] usb 2-8: Product: Lenovo EasyCamera
> [    6.735459] usb 2-8: Manufacturer: J37DCB2PF
> [    6.993789] usb 2-7: new full-speed USB device number 8 using xhci_hcd
> [    9.141761] usb 2-7: unable to read config index 0 descriptor/start: -71
> [    9.141767] usb 2-7: can't read configurations, error -71
> [    9.294483] usb 2-7: new full-speed USB device number 9 using xhci_hcd
> [   11.442406] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   11.442413] usb 2-7: can't read configurations, error -71
> [   11.595199] usb 2-7: new full-speed USB device number 10 using xhci_hcd
> [   13.743377] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   13.743383] usb 2-7: can't read configurations, error -71
> [   13.895921] usb 2-7: new full-speed USB device number 11 using xhci_hcd
> [   16.044138] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   16.044145] usb 2-7: can't read configurations, error -71
> [   16.044167] hub 2-0:1.0: unable to enumerate USB device on port 7
> 
> [   16.330480] usb 2-7: new full-speed USB device number 12 using xhci_hcd
> 
> [   19.500361] IPv6: ADDRCONF(NETDEV_CHANGE): wlp1s0: link becomes ready
> [   23.475726] usb 2-7: unable to read config index 0 descriptor/start: -110
> [   23.475733] usb 2-7: can't read configurations, error -110
> [   23.834556] usb 2-7: new full-speed USB device number 14 using xhci_hcd
> [   25.982084] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   25.982090] usb 2-7: can't read configurations, error -71
> [   26.148413] usb 2-7: new full-speed USB device number 15 using xhci_hcd
> [   28.296921] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   28.296927] usb 2-7: can't read configurations, error -71
> [   28.463153] usb 2-7: new full-speed USB device number 16 using xhci_hcd
> [   30.611512] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   30.611518] usb 2-7: can't read configurations, error -71
> [   30.891225] usb 2-7: new full-speed USB device number 18 using xhci_hcd
> [   33.039344] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   33.039349] usb 2-7: can't read configurations, error -71
> [   33.150245] usb 2-7: new full-speed USB device number 19 using xhci_hcd
> [   35.297560] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   35.297566] usb 2-7: can't read configurations, error -71
> [   35.463896] usb 2-7: new full-speed USB device number 20 using xhci_hcd
> [   37.611739] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   37.611745] usb 2-7: can't read configurations, error -71
> [   37.722912] usb 2-7: new full-speed USB device number 21 using xhci_hcd
> [   39.870662] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   39.870669] usb 2-7: can't read configurations, error -71
> [   39.870780] hub 2-0:1.0: unable to enumerate USB device on port 7
> [   40.128069] usb 2-7: new full-speed USB device number 22 using xhci_hcd
> [   42.275231] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   42.275236] usb 2-7: can't read configurations, error -71
> [   42.426898] usb 2-7: new full-speed USB device number 23 using xhci_hcd
> [   44.573529] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   44.573536] usb 2-7: can't read configurations, error -71
> [   44.725488] usb 2-7: new full-speed USB device number 24 using xhci_hcd
> [   46.871558] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   46.871564] usb 2-7: can't read configurations, error -71
> [   47.024161] usb 2-7: new full-speed USB device number 25 using xhci_hcd
> [   49.170691] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   49.170697] usb 2-7: can't read configurations, error -71
> [   49.170763] hub 2-0:1.0: unable to enumerate USB device on port 7
> 
> [   49.457741] usb 2-7: new full-speed USB device number 26 using xhci_hcd
> [   51.604245] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   51.604252] usb 2-7: can't read configurations, error -71
> [   51.757410] usb 2-7: new full-speed USB device number 27 using xhci_hcd
> [   63.897857] usb 2-7: unable to read config index 0 descriptor/start: -110
> [   63.897864] usb 2-7: can't read configurations, error -110
> [   64.256685] usb 2-7: new full-speed USB device number 29 using xhci_hcd
> [   66.402027] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   66.402033] usb 2-7: can't read configurations, error -71
> [   66.554451] usb 2-7: new full-speed USB device number 30 using xhci_hcd
> [   68.699773] usb 2-7: unable to read config index 0 descriptor/start: -71
> [   68.699779] usb 2-7: can't read configurations, error -71
> [   68.852189] usb 2-7: new full-speed USB device number 31 using xhci_hcd
> [   75.996377] usb 2-7: unable to read config index 0 descriptor/start: -110
> [   75.996384] usb 2-7: can't read configurations, error -110
> [   76.356077] usb 2-7: new full-speed USB device number 33 using xhci_hcd
> [   76.368398] usb 2-7: New USB device found, idVendor=04f3, idProduct=016f
> [   76.368404] usb 2-7: New USB device strings: Mfr=4, Product=14, SerialNumber=0
> [   76.368408] usb 2-7: Product: Touchscreen
> [   76.368411] usb 2-7: Manufacturer: ELAN
> [   76.369434] usb 2-7: ep 0x2 - rounding interval to 64 microframes, ep desc says 80 microframes
> [   76.397653] input: ELAN Touchscreen as /devices/pci0000:00/0000:00:14.0/usb2/2-7/2-7:1.0/input/input13
> [   76.399634] hid-multitouch 0003:04F3:016F.0002: input,hiddev0,hidraw0: USB HID v1.10 Device [ELAN Touchscreen] on usb-0000:00:14.0-7/input0

Thanks,
Johan
