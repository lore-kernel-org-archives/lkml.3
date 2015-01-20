Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbbATS1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:27:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbATS1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:27:39 -0500
Message-ID: <1421775689.1112.4.camel@linux-0dmf.site>
Subject: Re: USB autosuspend causing trouble with bluetooth
From: Oliver Neukum <oneukum@suse.de>
To: Kirill Elagin <kirelagin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <CABVT_gdCvbK8mUQMjDmiAmc_6kbBUMf4XFeAZ=zzjOYS+7oCGg@mail.gmail.com>
References: <CABVT_gf-rx0ymvtCrCotkO5=qoDifG1yAMg8U_aTgXEN=x6gvg@mail.gmail.com>
	 <1421751814.29486.13.camel@linux-0dmf.site>
	 <CABVT_gcqjp1V6vnOOSewYYeR2PmngAQhuR+fud=bDU6FJ8Bnqw@mail.gmail.com>
	 <1421762788.29486.28.camel@linux-0dmf.site>
	 <CABVT_gdCvbK8mUQMjDmiAmc_6kbBUMf4XFeAZ=zzjOYS+7oCGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jan 2015 18:41:29 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.10.4 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 18:58 +0400, Kirill Elagin wrote:
> On Tue, Jan 20, 2015 at 5:06 PM, Oliver Neukum <oneukum@suse.de> wrote:
> > On Tue, 2015-01-20 at 16:18 +0400, Kirill Elagin wrote:
> >> I use a Logitech wireless keyboard (with a Unifying receiver) and it
> >> keeps working fine even with `auto`.
> >>
> >> That is, everything is OK if the receiver is plugged before
> >> `power/control` is switched to `auto`.
> >
> > Wait. There is no power/control file for the receiver before
> > you plug it in. We are having a very big misunderstanding here.
> 
> Sorry for not being clear. I was referring to `power/control` of the
> USB-device itself except for the cases when I was talking about
> hot-plugging issues — in those cases I was referring to the
> `power/control` of the root hub.

Please check whether you are not accidentally touching the ports
linux-0dmf:/sys/bus/usb/devices/usb1/1-0:1.0/usb1-port1
At paths like this you find control files for ports, not the
root hub as a device.

> In this particular case I was talking about the `power/control` of the root hub.

OK, so autosuspend does work if you enable it for the device but
not the hub?

> `laptop-mode-tools` by default writes `auto` to `power/control` of
> _all_ the USB devices, root hubs included (even when on AC). Is it
> really expected that kernel might completely power off the physical
> USB port? Sounds weird.

It can. It is a recent feature if ACPI supports that on a machine.

> Here is an even more strange thing. First I set all the USB power
> management to the defaults (that is, `auto` for all the usb devices
> including root hubs). Again, the keyboard keeps working and as soon as
> I unplug the receiver kernel says the device was disconnected. Now if
> I plug the receiver back nothing happens. _But_ if I plug a flash
> drive in the save physical port it gets detected. So, I tried a number
> of other usb devices and it totally looks like USB2.0 ones are
> properly hot-plugged while USB1.1 devices are not. Does this sound to
> you like a bug in my laptop's hardware?

Could be, but could also be software.
Please double check where exactly an "on" is needed.

	Regards
		Oliver


