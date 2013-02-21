Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3BUAPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 19:15:32 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:50409 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab3BUAPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 19:15:31 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Wonky PS2-USB converter issues...
In-Reply-To: Your message of "Wed, 20 Feb 2013 16:07:49 -0800."
             <20130221000749.GC14395@kroah.com>
From: Valdis.Kletnieks@vt.edu
References: <21767.1361400518@turing-police.cc.vt.edu>
            <20130221000749.GC14395@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1361405698_1911P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 20 Feb 2013 19:14:58 -0500
Message-ID: <26591.1361405698@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.51256703.00D6,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1361405698_1911P
Content-Type: text/plain; charset=us-ascii

On Wed, 20 Feb 2013 16:07:49 -0800, Greg Kroah-Hartman said:

> PS-2 connectors can not normally handle hotplugging, the protocol
> doesn't allow it, and for some unlucky devices, it could actually fry
> the motherboard or the PS-2 device.
>
> So that's probably the issue here, the device just doesn't support it,
> sorry.

You mis-understood the problem.

This works:

PS/2 keyboard plugged into this device:
Bus 006 Device 002: ID 0e8f:0020 GreenAsia Inc. USB to PS/2 Adapter
USB side of device plugged into USB port on the Latitude laptop.
Power up, boot - the keyboard works.

If you plug the USB side of the GreenAsia adapter into a USB slot on
the dock, the keyboard is dead and not recognized by the system.  However,
replugging the USB, or unplug/plug the PS/2 side, and it becomes recognized
and starts working.

This tells me that the dock is doing something busted with USB that the laptop
does correctly, and not enumerating devices until something happens to whack it
upside the head. I was hoping to identify it and maybe quirk it.


--==_Exmh_1361405698_1911P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUSVnAQdmEQWDXROgAQJoAQ/9Fju6jFZihkI7w1a/NFroCh65NQqPLTWR
PYi+KKIIxxkAb1s2+rbelKpSp2ZD1qB1iJS0d38D7E3WhVn0VZyD+Qn1UojkaM74
zqlacrNLZa1l/GvUK83QZhyOUmCV/QcUPKuiKrvB0fv7vqOqDGhAqhs+v0POgky4
ph4KPlOSMPcIRjqtmm9AeehyZsqWyJ6mL9IYFMD5P9LU/v/eA5ACZoKJKCJ+uHvv
EDkw6E8naJqHUX5kbod7QNLAEmMtAh+LWSIWeoX/eOrWbv2Eahn0BSmjS8ewlRoc
ZhTXQpUH8wi2WyWttGBNbnzxfwsqmPLPwCsDoIERtkP5CuXwYSYc4MYho2dmI3kt
LaF1x2roE4ZjjYZIWsYSb6CjmEg6jQ6LuKWcK9t4l3AgGDtZC25EawyQ+/eDHJ+f
sHpqMcxbPestl4TU2IWVkVPe3IZaHoY0RKFi4R1SfhMSehSZ3RPeRdRIVcu/+s/O
+t5WF9yXM8jS+6iqGNdwBJbzCOXlYpXoiqrsr/YUXAFBQpbMToYNNJuco/8LG4AR
turvWOG8UrcAMwLe221uEcSZ9LRglMrQ/O5So2yRzZpv6j4SzuCtkWkiQurKGEMI
ukT4wlXUUflZ+d+NEZ0skK+8LbsTblYY0y7nSHx9tDLWYZu+uNLuw1ZJcFDYRHd6
7QCzWlWD9GY=
=hZfP
-----END PGP SIGNATURE-----

--==_Exmh_1361405698_1911P--

