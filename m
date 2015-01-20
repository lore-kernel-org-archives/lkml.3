Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbbATO6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:58:37 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:52569 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbbATO6f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:58:35 -0500
MIME-Version: 1.0
In-Reply-To: <1421762788.29486.28.camel@linux-0dmf.site>
References: <CABVT_gf-rx0ymvtCrCotkO5=qoDifG1yAMg8U_aTgXEN=x6gvg@mail.gmail.com>
 <1421751814.29486.13.camel@linux-0dmf.site> <CABVT_gcqjp1V6vnOOSewYYeR2PmngAQhuR+fud=bDU6FJ8Bnqw@mail.gmail.com>
 <1421762788.29486.28.camel@linux-0dmf.site>
From: Kirill Elagin <kirelagin@gmail.com>
Date: Tue, 20 Jan 2015 18:58:13 +0400
Message-ID: <CABVT_gdCvbK8mUQMjDmiAmc_6kbBUMf4XFeAZ=zzjOYS+7oCGg@mail.gmail.com>
Subject: Re: USB autosuspend causing trouble with bluetooth
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 5:06 PM, Oliver Neukum <oneukum@suse.de> wrote:
> On Tue, 2015-01-20 at 16:18 +0400, Kirill Elagin wrote:
>> I use a Logitech wireless keyboard (with a Unifying receiver) and it
>> keeps working fine even with `auto`.
>>
>> That is, everything is OK if the receiver is plugged before
>> `power/control` is switched to `auto`.
>
> Wait. There is no power/control file for the receiver before
> you plug it in. We are having a very big misunderstanding here.

Sorry for not being clear. I was referring to `power/control` of the
USB-device itself except for the cases when I was talking about
hot-plugging issues — in those cases I was referring to the
`power/control` of the root hub.

I might be using terminology in a wrong way. By `power/control` of a
root hub I mean `/sys/bus/usb/devices/usb<bus_number>/power/control`
and by `power/control` of a device I mean
`/sys/bus/usb/devices/<bus_number>-<port_number>/power/control`.

>> But if I first set it to `auto`, then plug the receiver in, it is not
>> detected (nothing in dmesg). Kernel
>> detects it as soon as I `echo on` to the relevant `power/control`.
>
> Are you on power/control for the device or the port?
> If you are using the port's control file you might be switching
> on Port Power Off. Then of course the port will not process
> hotplugs. Please clarify!

In this particular case I was talking about the `power/control` of the root hub.

`laptop-mode-tools` by default writes `auto` to `power/control` of
_all_ the USB devices, root hubs included (even when on AC). Is it
really expected that kernel might completely power off the physical
USB port? Sounds weird.

Here is an even more strange thing. First I set all the USB power
management to the defaults (that is, `auto` for all the usb devices
including root hubs). Again, the keyboard keeps working and as soon as
I unplug the receiver kernel says the device was disconnected. Now if
I plug the receiver back nothing happens. _But_ if I plug a flash
drive in the save physical port it gets detected. So, I tried a number
of other usb devices and it totally looks like USB2.0 ones are
properly hot-plugged while USB1.1 devices are not. Does this sound to
you like a bug in my laptop's hardware?
