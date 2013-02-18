Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab3BRR1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:27:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56927 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756647Ab3BRR1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:27:16 -0500
Date: Mon, 18 Feb 2013 19:27:00 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SYSFS "errors"
Message-ID: <20130218172700.GH2663@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130218153316.GA2663@arwen.pp.htv.fi>
 <20130218155012.GA30974@kroah.com>
 <20130218155215.GB2663@arwen.pp.htv.fi>
 <20130218171334.GA31329@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kr14OxHsRwZHHqxS"
Content-Disposition: inline
In-Reply-To: <20130218171334.GA31329@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kr14OxHsRwZHHqxS
Content-Type: multipart/mixed; boundary="K1SnTjlYS/YgcDEx"
Content-Disposition: inline


--K1SnTjlYS/YgcDEx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 18, 2013 at 09:13:34AM -0800, Greg KH wrote:
> On Mon, Feb 18, 2013 at 05:52:15PM +0200, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Mon, Feb 18, 2013 at 07:50:12AM -0800, Greg KH wrote:
> > > > If it helps in any way, I have printed below only the filenames
> > > > (without path) so I could pipe it through uniq:
> > > >=20
> > > > act_mask
> > > > audit
> > > > autosuspend_delay_ms
> > > > bind
> > >=20
> > > This one the driver core creates, I'll fix that up.
> > >=20
> > > The rest need paths to determine who to blame :)
> >=20
> > wanna see the full list ? It's 1602 lines :-p
>=20
> You must have more devices in your system than I do:
> 	$ ruby ./sysfs_test.ruby  | wc -l
> 	626
>=20
> What kernel version did you run this on?  I don't see any "bind" file in
> the list on 3.8.0-rc7+:

running on -rc6:

$ uname -r
3.8.0-rc6+

> 	$ ls -l /sys/bus/platform/drivers/pcspkr/bind
> 	--w------- 1 root root 4096 Feb 18 09:09 /sys/bus/platform/drivers/pcspk=
r/bind
> 	$ ls -l /sys/bus/serio/drivers/atkbd/unbind
> 	--w------- 1 root root 4096 Feb 18 09:09 /sys/bus/serio/drivers/atkbd/un=
bind
>=20
> So the full list might be necessary here, thanks.

yeah, I figured one thing later. Ruby is stupid, if you run it as root,
it File.readable? will return true even if there's no read permission.
So I'm running only as a normal user, full output attached

--=20
balbi

--K1SnTjlYS/YgcDEx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sysfs_errors.txt"

Input/output error - /sys/devices/cpu/power/autosuspend_delay_ms
Input/output error - /sys/devices/pnp0/00:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pnp0/00:01/power/autosuspend_delay_ms
Input/output error - /sys/devices/pnp0/00:02/power/autosuspend_delay_ms
Input/output error - /sys/devices/pnp0/00:03/power/autosuspend_delay_ms
Input/output error - /sys/devices/pnp0/00:04/rtc/rtc0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pnp0/00:04/power/autosuspend_delay_ms
Input/output error - /sys/devices/pnp0/00:05/power/autosuspend_delay_ms
Input/output error - /sys/devices/pnp0/00:06/tty/ttyS0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pnp0/00:06/power/autosuspend_delay_ms
Input/output error - /sys/devices/pnp0/00:07/power/autosuspend_delay_ms
Input/output error - /sys/devices/pnp0/power/autosuspend_delay_ms
Input/output error - /sys/devices/software/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:00.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:01.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:01.0/pci_bus/0000:01/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/drm/card0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/drm/card0/card0-DP-1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/drm/card0/card0-DP-2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/drm/card0/card0-DVI-I-1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/drm/controlD64/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/i2c-1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/i2c-2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/i2c-3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/i2c-3/3-002e/hwmon/hwmon1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/i2c-3/3-002e/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/i2c-4/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/i2c-5/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/i2c-6/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/i2c-7/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/i2c-8/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/i2c-9/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/hwmon/hwmon2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/graphics/fb0/power/autosuspend_delay_ms
No such device - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/graphics/fb0/bl_curve
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/i2c-10/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:03.0/pci_bus/0000:02/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:07.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:07.0/0000:03:00.0/usb9/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:07.0/0000:03:00.0/usb9/9-0:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:07.0/0000:03:00.0/usb9/9-0:1.0/port1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:07.0/0000:03:00.0/usb9/9-0:1.0/port2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:07.0/0000:03:00.0/usb9/9-0:1.0/port3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:07.0/0000:03:00.0/usb9/9-0:1.0/port4/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:07.0/0000:03:00.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:07.0/0000:03:00.0/usb10/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:07.0/0000:03:00.0/usb10/10-0:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:07.0/0000:03:00.0/usb10/10-0:1.0/port1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:07.0/0000:03:00.0/usb10/10-0:1.0/port2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:07.0/0000:03:00.0/usb10/10-0:1.0/port3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:07.0/0000:03:00.0/usb10/10-0:1.0/port4/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:07.0/pci_bus/0000:03/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:14.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:14.1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:14.2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.0/usb3/3-0:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.0/usb3/3-0:1.0/port1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.0/usb3/3-0:1.0/port2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.0/usb3/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.1/usb4/4-2/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.0/ep_02/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.0/ttyUSB3/tty/ttyUSB3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.0/ttyUSB3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.1/usb4/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.1/usb4/4-0:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.1/usb4/4-0:1.0/port1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.1/usb4/4-0:1.0/port2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.2/usb5/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.2/usb5/5-0:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.2/usb5/5-0:1.0/port1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.2/usb5/5-0:1.0/port2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.7/usb1/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-0:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-0:1.0/port1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-0:1.0/port2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-0:1.0/port3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-0:1.0/port4/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-0:1.0/port5/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-0:1.0/port6/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1a.7/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1b.0/input/input2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1b.0/input/input2/event2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1b.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1b.0/sound/card0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1b.0/sound/card0/controlC0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1b.0/sound/card0/hwC0D0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1b.0/sound/card0/pcmC0D0c/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1b.0/sound/card0/pcmC0D0p/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1b.0/sound/card0/pcmC0D1p/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.0/0000:00:1c.0:pcie08/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.0/0000:04:00.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.0/0000:04:00.0/usb11/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.0/0000:04:00.0/usb11/11-0:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.0/0000:04:00.0/usb11/11-0:1.0/port1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.0/0000:04:00.0/usb11/11-0:1.0/port2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.0/0000:04:00.0/usb12/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.0/0000:04:00.0/usb12/12-0:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.0/0000:04:00.0/usb12/12-0:1.0/port1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.0/0000:04:00.0/usb12/12-0:1.0/port2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.0/pci_bus/0000:04/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.5/0000:00:1c.5:pcie08/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.5/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.5/0000:05:00.0/net/eth0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.5/0000:05:00.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1c.5/pci_bus/0000:05/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.0/usb6/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.0/usb6/6-0:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.0/usb6/6-0:1.0/port1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.0/usb6/6-0:1.0/port2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-1/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1:1.0/input/input3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1:1.0/input/input3/event3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1:1.0/input/input3/mouse0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1:1.0/0003:0461:4D81.0001/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1:1.0/0003:0461:4D81.0001/hidraw/hidraw0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-2/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.0/input/input4/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.0/input/input4/event4/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.0/0003:413C:2106.0002/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.0/0003:413C:2106.0002/hidraw/hidraw1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-0:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-0:1.0/port1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/usb7/7-0:1.0/port2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.2/usb8/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.2/usb8/8-0:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.2/usb8/8-0:1.0/port1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.2/usb8/8-0:1.0/port2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1:1.0/port1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1:1.0/port2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1:1.0/port3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/ep_02/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/ep_82/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/scsi_host/host100/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/bsg/100:0:0:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/scsi_disk/100:0:0:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/block/sdc/power/autosuspend_delay_ms
No such device or address - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/block/sdc/trace/pid
No such device or address - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/block/sdc/trace/end_lba
No such device or address - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/block/sdc/trace/enable
No such device or address - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/block/sdc/trace/act_mask
No such device or address - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/block/sdc/trace/start_lba
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/scsi_generic/sg3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/scsi_device/100:0:0:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.2/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.2/2-5.1.2:1.0/ep_02/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.2/2-5.1.2:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.2/2-5.1.2:1.0/ttyUSB1/tty/ttyUSB1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.2/2-5.1.2:1.0/ttyUSB1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.2/2-5.1.2:1.1/ep_04/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.2/2-5.1.2:1.1/ep_83/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.2/2-5.1.2:1.1/ttyUSB2/tty/ttyUSB2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.2/2-5.1.2:1.1/ttyUSB2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.3/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.3/2-5.3:1.0/ep_02/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.3/2-5.3:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.3/2-5.3:1.0/ep_83/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.3/2-5.3:1.0/ttyUSB0/tty/ttyUSB0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.3/2-5.3:1.0/ttyUSB0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5:1.0/port1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5:1.0/port2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5:1.0/port3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/ep_00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-0:1.0/ep_81/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-0:1.0/port1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-0:1.0/port2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-0:1.0/port3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-0:1.0/port4/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-0:1.0/port5/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-0:1.0/port6/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1d.7/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1e.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1e.0/pci_bus/0000:06/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.0/misc/watchdog/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.0/iTCO_wdt/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.0/watchdog/watchdog0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.0/gpio_ich/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/scsi_host/host0/power/autosuspend_delay_ms
Invalid argument - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/scsi_host/host0/em_buffer
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/bsg/0:0:0:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/scsi_disk/0:0:0:0/power/autosuspend_delay_ms
Invalid argument - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/sw_activity
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda/sda1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda/sda2/power/autosuspend_delay_ms
No such device or address - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda/sda2/trace/pid
No such device or address - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda/sda2/trace/end_lba
No such device or address - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda/sda2/trace/enable
No such device or address - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda/sda2/trace/act_mask
No such device or address - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda/sda2/trace/start_lba
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda/sda5/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda/sda6/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/autosuspend_delay_ms
Operation not supported - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/unload_heads
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/scsi_generic/sg0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/scsi_device/0:0:0:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/link1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/link1/dev1.0/ata_device/dev1.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/link1/dev1.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/link1/ata_link/link1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata1/ata_port/ata1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/scsi_host/host1/power/autosuspend_delay_ms
Invalid argument - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/scsi_host/host1/em_buffer
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/bsg/1:0:0:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/scsi_disk/1:0:0:0/power/autosuspend_delay_ms
Invalid argument - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/sw_activity
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/block/sdb/sdb1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/block/sdb/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/power/autosuspend_delay_ms
Operation not supported - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/unload_heads
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/scsi_generic/sg1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/scsi_device/1:0:0:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/link2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/link2/dev2.0/ata_device/dev2.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/link2/dev2.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/link2/ata_link/link2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata2/ata_port/ata2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/scsi_host/host2/power/autosuspend_delay_ms
Invalid argument - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/scsi_host/host2/em_buffer
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0:0/bsg/2:0:0:0/power/autosuspend_delay_ms
Invalid argument - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0:0/sw_activity
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0:0/block/sr0/power/autosuspend_delay_ms
No such device or address - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0:0/block/sr0/trace/pid
No such device or address - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0:0/block/sr0/trace/end_lba
No such device or address - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0:0/block/sr0/trace/enable
No such device or address - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0:0/block/sr0/trace/act_mask
No such device or address - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0:0/block/sr0/trace/start_lba
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0:0/power/autosuspend_delay_ms
Operation not supported - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0:0/unload_heads
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0:0/scsi_generic/sg2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/2:0:0:0/scsi_device/2:0:0:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/target2:0:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata3/host2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata3/link3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata3/link3/dev3.0/ata_device/dev3.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata3/link3/dev3.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata3/link3/ata_link/link3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata3/ata_port/ata3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata4/host3/scsi_host/host3/power/autosuspend_delay_ms
Invalid argument - /sys/devices/pci0000:00/0000:00:1f.2/ata4/host3/scsi_host/host3/em_buffer
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata4/host3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata4/link4/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata4/link4/dev4.0/ata_device/dev4.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata4/link4/dev4.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata4/link4/ata_link/link4/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata4/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata4/ata_port/ata4/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata5/host4/scsi_host/host4/power/autosuspend_delay_ms
Invalid argument - /sys/devices/pci0000:00/0000:00:1f.2/ata5/host4/scsi_host/host4/em_buffer
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata5/host4/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata5/link5/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata5/link5/dev5.0/ata_device/dev5.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata5/link5/dev5.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata5/link5/ata_link/link5/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata5/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata5/ata_port/ata5/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata6/host5/scsi_host/host5/power/autosuspend_delay_ms
Invalid argument - /sys/devices/pci0000:00/0000:00:1f.2/ata6/host5/scsi_host/host5/em_buffer
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata6/host5/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata6/link6/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata6/link6/dev6.0/ata_device/dev6.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata6/link6/dev6.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata6/link6/ata_link/link6/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata6/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/ata6/ata_port/ata6/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.3/i2c-0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/0000:00:1f.3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:00/pci_bus/0000:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:00.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:00.1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:02.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:02.1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:03.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:03.1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:03.4/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:04.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:04.1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:04.2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:04.3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:05.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:05.1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:05.2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:05.3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:06.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:06.1/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:06.2/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/0000:3f:06.3/power/autosuspend_delay_ms
Input/output error - /sys/devices/pci0000:3f/pci_bus/0000:3f/power/autosuspend_delay_ms
Input/output error - /sys/devices/tracepoint/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/cpu/cpu0/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/cpu/cpu1/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/cpu/cpu2/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/cpu/cpu3/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/cpu/cpu4/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/cpu/cpu5/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/cpu/cpu6/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/cpu/cpu7/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/cpu/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/edac/mc/mc0/all_channel_counts/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/edac/mc/mc0/dimm0/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/edac/mc/mc0/dimm3/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/edac/mc/mc0/dimm6/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/edac/mc/mc0/power/autosuspend_delay_ms
No such device - /sys/devices/system/edac/mc/mc0/sdram_scrub_rate
Input/output error - /sys/devices/system/edac/mc/mc0/inject_addrmatch/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/edac/mc/mc0/csrow0/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/edac/mc/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/edac/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/node/node0/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/node/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/clocksource/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/clocksource/clocksource0/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/machinecheck/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/machinecheck/machinecheck0/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/machinecheck/machinecheck1/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/machinecheck/machinecheck2/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/machinecheck/machinecheck3/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/machinecheck/machinecheck4/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/machinecheck/machinecheck5/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/machinecheck/machinecheck6/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/machinecheck/machinecheck7/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/soft_offline_page
Input/output error - /sys/devices/system/memory/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/hard_offline_page
Input/output error - /sys/devices/system/memory/memory0/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory1/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory2/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory3/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory4/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory5/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory6/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory7/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory8/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory9/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory10/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory11/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory12/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory13/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory14/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory15/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory16/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory17/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory18/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory19/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory20/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory21/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory22/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory23/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory32/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory33/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory34/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory35/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory36/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory37/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory38/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory39/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory40/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory41/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory42/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory43/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory44/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory45/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory46/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory47/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory48/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory49/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory50/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory51/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory52/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory53/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory54/power/autosuspend_delay_ms
Input/output error - /sys/devices/system/memory/memory55/power/autosuspend_delay_ms
Input/output error - /sys/devices/uncore/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcs/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcs1/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcs2/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcs3/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcs4/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcs5/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcs6/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcs7/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcsa/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcsa1/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcsa2/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcsa3/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcsa4/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcsa5/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcsa6/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vc/vcsa7/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:1/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:2/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:3/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:4/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:5/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:6/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:7/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:8/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:9/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/7:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/7:1/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/7:2/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/7:3/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/7:4/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/7:5/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/7:6/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/7:7/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/8:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/11:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:10/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:11/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:12/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:13/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:14/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/1:15/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:0/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:1/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:2/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:3/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:4/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:5/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:6/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:7/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:8/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:9/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/8:16/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/8:32/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/default/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:10/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:11/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:12/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:13/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:14/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/43:15/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/bdi/btrfs-1/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/dmi/id/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/drm/ttm/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/mem/mem/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/mem/full/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/mem/kmsg/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/mem/null/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/mem/port/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/mem/zero/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/mem/random/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/mem/urandom/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/net/lo/power/autosuspend_delay_ms
Invalid argument - /sys/devices/virtual/net/lo/speed
Invalid argument - /sys/devices/virtual/net/lo/duplex
Input/output error - /sys/devices/virtual/net/tun0/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/ptmx/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty0/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty1/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty2/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty3/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty4/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty5/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty6/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty7/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty8/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty9/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/console/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty10/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty11/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty12/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty13/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty14/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty15/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty16/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty17/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty18/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty19/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty20/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty21/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty22/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty23/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty24/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty25/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty26/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty27/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty28/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty29/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty30/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty31/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty32/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty33/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty34/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty35/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty36/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty37/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty38/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty39/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty40/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty41/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty42/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty43/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty44/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty45/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty46/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty47/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty48/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty49/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty50/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty51/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty52/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty53/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty54/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty55/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty56/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty57/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty58/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty59/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty60/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty61/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty62/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/tty/tty63/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/wmi/8D9DDCBC-A997-11DA-B012-B622A1EF5492/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/wmi/9DBB5994-A997-11DA-B012-B622A1EF5492/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/wmi/A80593CE-A997-11DA-B012-B622A1EF5492/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/wmi/A3776CE0-1E88-11DB-A98B-0800200C9A66/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/wmi/05901221-D566-11D1-B2F0-00A0C9062910/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/misc/kvm/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/misc/tgt/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/misc/tun/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/misc/fuse/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/misc/hpet/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/misc/cpu_dma_latency/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/misc/btrfs-control/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/misc/psaux/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/misc/network_latency/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/misc/loop-control/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/misc/mcelog/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/misc/snapshot/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/misc/vga_arbiter/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/misc/microcode/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/misc/network_throughput/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/block/nbd0/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd0/trace/pid
No such device or address - /sys/devices/virtual/block/nbd0/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd0/trace/enable
No such device or address - /sys/devices/virtual/block/nbd0/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd0/trace/start_lba
Input/output error - /sys/devices/virtual/block/nbd1/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd1/trace/pid
No such device or address - /sys/devices/virtual/block/nbd1/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd1/trace/enable
No such device or address - /sys/devices/virtual/block/nbd1/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd1/trace/start_lba
Input/output error - /sys/devices/virtual/block/nbd2/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd2/trace/pid
No such device or address - /sys/devices/virtual/block/nbd2/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd2/trace/enable
No such device or address - /sys/devices/virtual/block/nbd2/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd2/trace/start_lba
Input/output error - /sys/devices/virtual/block/nbd3/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd3/trace/pid
No such device or address - /sys/devices/virtual/block/nbd3/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd3/trace/enable
No such device or address - /sys/devices/virtual/block/nbd3/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd3/trace/start_lba
Input/output error - /sys/devices/virtual/block/nbd4/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd4/trace/pid
No such device or address - /sys/devices/virtual/block/nbd4/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd4/trace/enable
No such device or address - /sys/devices/virtual/block/nbd4/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd4/trace/start_lba
Input/output error - /sys/devices/virtual/block/nbd5/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd5/trace/pid
No such device or address - /sys/devices/virtual/block/nbd5/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd5/trace/enable
No such device or address - /sys/devices/virtual/block/nbd5/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd5/trace/start_lba
Input/output error - /sys/devices/virtual/block/nbd6/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd6/trace/pid
No such device or address - /sys/devices/virtual/block/nbd6/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd6/trace/enable
No such device or address - /sys/devices/virtual/block/nbd6/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd6/trace/start_lba
Input/output error - /sys/devices/virtual/block/nbd7/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd7/trace/pid
No such device or address - /sys/devices/virtual/block/nbd7/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd7/trace/enable
No such device or address - /sys/devices/virtual/block/nbd7/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd7/trace/start_lba
Input/output error - /sys/devices/virtual/block/nbd8/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd8/trace/pid
No such device or address - /sys/devices/virtual/block/nbd8/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd8/trace/enable
No such device or address - /sys/devices/virtual/block/nbd8/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd8/trace/start_lba
Input/output error - /sys/devices/virtual/block/nbd9/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd9/trace/pid
No such device or address - /sys/devices/virtual/block/nbd9/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd9/trace/enable
No such device or address - /sys/devices/virtual/block/nbd9/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd9/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram0/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram0/trace/pid
No such device or address - /sys/devices/virtual/block/ram0/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram0/trace/enable
No such device or address - /sys/devices/virtual/block/ram0/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram0/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram1/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram1/trace/pid
No such device or address - /sys/devices/virtual/block/ram1/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram1/trace/enable
No such device or address - /sys/devices/virtual/block/ram1/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram1/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram2/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram2/trace/pid
No such device or address - /sys/devices/virtual/block/ram2/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram2/trace/enable
No such device or address - /sys/devices/virtual/block/ram2/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram2/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram3/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram3/trace/pid
No such device or address - /sys/devices/virtual/block/ram3/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram3/trace/enable
No such device or address - /sys/devices/virtual/block/ram3/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram3/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram4/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram4/trace/pid
No such device or address - /sys/devices/virtual/block/ram4/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram4/trace/enable
No such device or address - /sys/devices/virtual/block/ram4/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram4/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram5/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram5/trace/pid
No such device or address - /sys/devices/virtual/block/ram5/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram5/trace/enable
No such device or address - /sys/devices/virtual/block/ram5/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram5/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram6/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram6/trace/pid
No such device or address - /sys/devices/virtual/block/ram6/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram6/trace/enable
No such device or address - /sys/devices/virtual/block/ram6/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram6/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram7/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram7/trace/pid
No such device or address - /sys/devices/virtual/block/ram7/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram7/trace/enable
No such device or address - /sys/devices/virtual/block/ram7/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram7/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram8/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram8/trace/pid
No such device or address - /sys/devices/virtual/block/ram8/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram8/trace/enable
No such device or address - /sys/devices/virtual/block/ram8/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram8/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram9/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram9/trace/pid
No such device or address - /sys/devices/virtual/block/ram9/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram9/trace/enable
No such device or address - /sys/devices/virtual/block/ram9/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram9/trace/start_lba
Input/output error - /sys/devices/virtual/block/loop0/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/loop0/trace/pid
No such device or address - /sys/devices/virtual/block/loop0/trace/end_lba
No such device or address - /sys/devices/virtual/block/loop0/trace/enable
No such device or address - /sys/devices/virtual/block/loop0/trace/act_mask
No such device or address - /sys/devices/virtual/block/loop0/trace/start_lba
Input/output error - /sys/devices/virtual/block/loop1/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/loop1/trace/pid
No such device or address - /sys/devices/virtual/block/loop1/trace/end_lba
No such device or address - /sys/devices/virtual/block/loop1/trace/enable
No such device or address - /sys/devices/virtual/block/loop1/trace/act_mask
No such device or address - /sys/devices/virtual/block/loop1/trace/start_lba
Input/output error - /sys/devices/virtual/block/loop2/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/loop2/trace/pid
No such device or address - /sys/devices/virtual/block/loop2/trace/end_lba
No such device or address - /sys/devices/virtual/block/loop2/trace/enable
No such device or address - /sys/devices/virtual/block/loop2/trace/act_mask
No such device or address - /sys/devices/virtual/block/loop2/trace/start_lba
Input/output error - /sys/devices/virtual/block/loop3/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/loop3/trace/pid
No such device or address - /sys/devices/virtual/block/loop3/trace/end_lba
No such device or address - /sys/devices/virtual/block/loop3/trace/enable
No such device or address - /sys/devices/virtual/block/loop3/trace/act_mask
No such device or address - /sys/devices/virtual/block/loop3/trace/start_lba
Input/output error - /sys/devices/virtual/block/loop4/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/loop4/trace/pid
No such device or address - /sys/devices/virtual/block/loop4/trace/end_lba
No such device or address - /sys/devices/virtual/block/loop4/trace/enable
No such device or address - /sys/devices/virtual/block/loop4/trace/act_mask
No such device or address - /sys/devices/virtual/block/loop4/trace/start_lba
Input/output error - /sys/devices/virtual/block/loop5/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/loop5/trace/pid
No such device or address - /sys/devices/virtual/block/loop5/trace/end_lba
No such device or address - /sys/devices/virtual/block/loop5/trace/enable
No such device or address - /sys/devices/virtual/block/loop5/trace/act_mask
No such device or address - /sys/devices/virtual/block/loop5/trace/start_lba
Input/output error - /sys/devices/virtual/block/loop6/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/loop6/trace/pid
No such device or address - /sys/devices/virtual/block/loop6/trace/end_lba
No such device or address - /sys/devices/virtual/block/loop6/trace/enable
No such device or address - /sys/devices/virtual/block/loop6/trace/act_mask
No such device or address - /sys/devices/virtual/block/loop6/trace/start_lba
Input/output error - /sys/devices/virtual/block/loop7/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/loop7/trace/pid
No such device or address - /sys/devices/virtual/block/loop7/trace/end_lba
No such device or address - /sys/devices/virtual/block/loop7/trace/enable
No such device or address - /sys/devices/virtual/block/loop7/trace/act_mask
No such device or address - /sys/devices/virtual/block/loop7/trace/start_lba
Input/output error - /sys/devices/virtual/block/nbd10/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd10/trace/pid
No such device or address - /sys/devices/virtual/block/nbd10/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd10/trace/enable
No such device or address - /sys/devices/virtual/block/nbd10/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd10/trace/start_lba
Input/output error - /sys/devices/virtual/block/nbd11/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd11/trace/pid
No such device or address - /sys/devices/virtual/block/nbd11/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd11/trace/enable
No such device or address - /sys/devices/virtual/block/nbd11/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd11/trace/start_lba
Input/output error - /sys/devices/virtual/block/nbd12/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd12/trace/pid
No such device or address - /sys/devices/virtual/block/nbd12/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd12/trace/enable
No such device or address - /sys/devices/virtual/block/nbd12/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd12/trace/start_lba
Input/output error - /sys/devices/virtual/block/nbd13/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd13/trace/pid
No such device or address - /sys/devices/virtual/block/nbd13/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd13/trace/enable
No such device or address - /sys/devices/virtual/block/nbd13/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd13/trace/start_lba
Input/output error - /sys/devices/virtual/block/nbd14/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd14/trace/pid
No such device or address - /sys/devices/virtual/block/nbd14/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd14/trace/enable
No such device or address - /sys/devices/virtual/block/nbd14/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd14/trace/start_lba
Input/output error - /sys/devices/virtual/block/nbd15/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/nbd15/trace/pid
No such device or address - /sys/devices/virtual/block/nbd15/trace/end_lba
No such device or address - /sys/devices/virtual/block/nbd15/trace/enable
No such device or address - /sys/devices/virtual/block/nbd15/trace/act_mask
No such device or address - /sys/devices/virtual/block/nbd15/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram10/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram10/trace/pid
No such device or address - /sys/devices/virtual/block/ram10/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram10/trace/enable
No such device or address - /sys/devices/virtual/block/ram10/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram10/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram11/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram11/trace/pid
No such device or address - /sys/devices/virtual/block/ram11/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram11/trace/enable
No such device or address - /sys/devices/virtual/block/ram11/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram11/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram12/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram12/trace/pid
No such device or address - /sys/devices/virtual/block/ram12/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram12/trace/enable
No such device or address - /sys/devices/virtual/block/ram12/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram12/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram13/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram13/trace/pid
No such device or address - /sys/devices/virtual/block/ram13/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram13/trace/enable
No such device or address - /sys/devices/virtual/block/ram13/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram13/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram14/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram14/trace/pid
No such device or address - /sys/devices/virtual/block/ram14/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram14/trace/enable
No such device or address - /sys/devices/virtual/block/ram14/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram14/trace/start_lba
Input/output error - /sys/devices/virtual/block/ram15/power/autosuspend_delay_ms
No such device or address - /sys/devices/virtual/block/ram15/trace/pid
No such device or address - /sys/devices/virtual/block/ram15/trace/end_lba
No such device or address - /sys/devices/virtual/block/ram15/trace/enable
No such device or address - /sys/devices/virtual/block/ram15/trace/act_mask
No such device or address - /sys/devices/virtual/block/ram15/trace/start_lba
Input/output error - /sys/devices/virtual/input/mice/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/graphics/fbcon/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/sound/seq/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/sound/timer/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/thermal/cooling_device0/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/thermal/cooling_device1/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/thermal/cooling_device2/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/thermal/cooling_device3/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/thermal/cooling_device4/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/thermal/cooling_device5/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/thermal/cooling_device6/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/thermal/cooling_device7/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vtconsole/vtcon0/power/autosuspend_delay_ms
Input/output error - /sys/devices/virtual/vtconsole/vtcon1/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/reg-dummy/regulator/regulator.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/reg-dummy/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/i8042/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/i8042/serio0/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/i8042/serio1/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/alarmtimer/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/dcdbas/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/pcspkr/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/serial8250/tty/ttyS1/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/serial8250/tty/ttyS2/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/serial8250/tty/ttyS3/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/serial8250/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/microcode/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/coretemp.0/hwmon/hwmon0/power/autosuspend_delay_ms
Input/output error - /sys/devices/platform/coretemp.0/power/autosuspend_delay_ms
Input/output error - /sys/devices/breakpoint/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:01/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:02/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:03/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:04/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:05/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:06/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:07/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:08/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:09/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:10/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:11/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:12/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:13/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:14/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:15/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:16/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:17/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:18/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:19/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:0a/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:0b/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:0c/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:0d/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:0e/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:0f/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:1a/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:1b/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:1c/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:1d/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:1e/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXCPU:1f/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:01/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:02/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:03/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:04/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:05/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:06/PNP0401:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:06/PNP0501:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:06/PNP0800:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:06/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:06/PNP0B00:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:06/PNP0C01:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:06/PNP0C04:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:06/PNP0000:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:06/PNP0100:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:06/PNP0200:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:07/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:08/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:09/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:0a/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:0b/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:0c/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C14:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0/event0/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:01/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:02/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:03/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:04/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:05/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:06/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:07/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0103:00/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXSYBUS:01/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/event1/power/autosuspend_delay_ms
Input/output error - /sys/devices/LNXSYSTM:00/LNXPWRBN:00/power/autosuspend_delay_ms

--K1SnTjlYS/YgcDEx--

--kr14OxHsRwZHHqxS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRImRkAAoJEIaOsuA1yqRENF8QAIawMeKoty+ZzQMikpvYG3NI
WwloTV33t+Wj9zwNBb5nLMy+/mt8zxliXI/FZtCA6Zz4+3UiVuqCa+SHfKZBaGHO
ZJ8YFLBK4VXKLWIZRW/P+BvMq6/YZKhGPFPkqxmAfLL+PPairUikzn2/pg+0aqNj
VA5BQTPTXx9aKZo7ao6h9ErRrxYSvfqO62QsOoBowgJlN4swToqn2ZkHxQzFXTdJ
UTrqUu8mP//fm3FX6pmZQbyE2sHsQM7LybLacG+KUoGUsZclSCZXTZS6csAXidsK
xbIh9Um7B506Z9GlXkkXsJpeuvQ0AdqzlIZ3BivKQFdJ4LXbfCnc8wHSTbgV1xhk
AVXJDGoDpxdmjfLy8Q5S9XQ7kyQ75MeXqqVSj4nEFbGblHPR5ponEqh4Fcq4JNJm
TDFDz0TNKIkA5X4eCbEfgSKo7eSJipPk1U27+uinOXgtwmp28YrMoq6y49IpD6E1
P7EIo0d71BdALz3kQW9zd9ll8oLD44W6ctle0zBEF98Z2Tgag+zpIWnndAHjnIOn
sT+FYpY61orrwDvkJPRrCJ7OD+e8ziH5mBJLwNNRJ76FEPsb0xHeV9HOYee3Pt1C
BgqpevEbl3d49vMGo6da3SUtuu45Rpbedj0NJNKRrXm7/PV/jOP06LZ4lxV5JzAm
yIOECJ+LsADY/nQgYc7/
=Pkay
-----END PGP SIGNATURE-----

--kr14OxHsRwZHHqxS--
