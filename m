Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbaHVISY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:18:24 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:36954 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaHVISV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:18:21 -0400
Date: Fri, 22 Aug 2014 10:18:19 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Hawkes <hawkes@google.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [GIT PULL] HID
Message-ID: <20140822081819.GA297@x4>
References: <alpine.LNX.2.00.1408211146110.23162@pobox.suse.cz>
 <20140822074030.GA297@x4>
 <alpine.LNX.2.00.1408220257050.23162@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1408220257050.23162@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.08.22 at 03:00 -0500, Jiri Kosina wrote:
> On Fri, 22 Aug 2014, Markus Trippelsdorf wrote:
> 
> > >       HID: logitech: perform bounds checking on device_id early enough
> > 
> > The commit above (ad3e14d7c5268c2e) causes the bounds checking to always
> > fail on my monolithic kernel (without modules):
> > 
> > ...
> > [    2.922617] usb 4-2: new full-speed USB device number 2 using ohci-pci
> > [    2.996587] udevd[98]: starting eudev version 1.0
> > [    3.071203] random: nonblocking pool is initialized
> > [    3.108360] logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.1-2/input2
> > [    3.163208] input: Logitech Unifying Device. Wireless PID:4026 as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.2/0003:046D:C52B.0003/0003:046D:C52B.0004/input/input2
> > [    3.163511] logitech-djdevice 0003:046D:C52B.0004: input,hidraw1: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:4026] on usb-0000:00:12.1-2:1
> > [    3.164121] logitech-djreceiver 0003:046D:C52B.0003: logi_dj_raw_event: invalid device index:0
> > [    3.289261] usb 3-1: new low-speed USB device number 2 using ohci-pci
> > [    3.457606] input: HID 046a:0011 as /devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.0/0003:046A:0011.0005/input/input3
> > [    3.457794] hid-generic 0003:046A:0011.0005: input,hidraw2: USB HID v1.10 Keyboard [HID 046a:0011] on usb-0000:00:12.0-1/input0
> > [    3.712886] Switched to clocksource tsc
> 
> Thanks a lot for a timely report.
> 
> I am travelling till next week and don't unfortunately have the hardware 
> here with me to test momentarily, so please take this with a lot of grains 
> of salt (maybe Benjamin would be able to look into this before I'd be able 
> to on monday ... ?).
> 
> Does the shot-in-the-dark patch below put things back in shape for you?

Thanks a lot for the timely patch. It indeed fixes the issue for me.

-- 
Markus
