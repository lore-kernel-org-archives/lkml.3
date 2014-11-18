Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbaKRVR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:17:26 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41263 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbaKRVRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:17:25 -0500
Date: Tue, 18 Nov 2014 15:17:34 -0600
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bigeasy@linutronix.de>
Subject: Re: [PATCH] usb: musb: core: Disable the Interrupts till BABBLE is
 fully handled
Message-ID: <20141118211734.GA19146@saruman>
Reply-To: <balbi@ti.com>
References: <1415953486-6000-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <1415953486-6000-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2014 at 01:54:46PM +0530, George Cherian wrote:
> Disable the MUSB interrupts till MUSB is recovered fully from BABBLE
> condition. There are chances that we could get multiple interrupts
> till the time the babble recover work gets scheduled. Sometimes
> this could even end up in an endless loop making MUSB itself unusable.
>=20
> Reported-by: Felipe Balbi <balbi@ti.com>=09
> Signed-off-by: George Cherian <george.cherian@ti.com>

while this helps the situation it doesn't solve the problem I'm having
with testusb on BBB when host port is connected to peripheral port on
the same BBB.

I still have:

# ./testusb -t 13 -c 10 -s 2048 -a
unknown speed   /dev/bus/usb/002/004    0
[  114.811407] usbtest 2-1:3.0: set altsetting to 0 failed, -71
/dev/bus/usb/002/004 test 13 --> 71 (error 71)
[  114.862387] CAUTION: musb: Babble Interrupt Occurred
[  114.868132] usb 2-1: USB disconnect, device number 4
[  114.961491] musb-hdrc musb-hdrc.1.auto: Restarting MUSB to recover from =
Babble
[  115.430829] usb 2-1: new high-speed USB device number 5 using musb-hdrc
[  115.573471] zero gadget: high-speed config #3: source/sink
[  115.584014] usbtest 2-1:3.0: Linux gadget zero
[  115.588682] usbtest 2-1:3.0: high-speed {control in/out bulk-in bulk-out=
} tests (+alt)

I think the driver is mis-detecting Babble. A babble only occurs when
the device side tries to move data without the host asking for anything.

--=20
balbi

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUa7duAAoJEIaOsuA1yqREMsgP+gJ17mTmPM05UbeiavT1dOnG
Dcfr2T6W1V63YxgDS9FrDxpCMiMDDtYGFH6V0qY376FRZoEfQwSA8JZR13pNk2WF
OmI7LmJ2Spe5w6BbsKWEg/P+6Td+GOjFlFzA1QHGKMPplKZMEmC0IX6CrKktLjD5
zzxyYraYvyaUO8aqohfkRh9sTPd5oiyR1SAUqYJdddqGefbocZylrv1nMLdLV6dn
GYVvblhEijbfyRZTK7znyifBcUslbNFIU4DlkYBCdrP8DT9JOwwUJTqoa0mkK2kq
uM0ZRjyjSmZOdspywA+2ZdkgyBEK4rLGXFDT5P4jePj+3RPF8ByjrXwYYpA2Uczc
DO98dXXv/W9JcqH/POumzxNkTnn6aD5snGZvmv9+9fzPefMalB7ElIvfhRW9vPgT
RuLpnUtWjUmSNdW4cD/eTMnFKyncVd3bthN2WdvcW/WcJn4yLz6AO2AyQBEJQ1hc
nWBRUAsEb0MtrjUtFI/jJx8v94xUgKQokPbEXeRGC4ocPvL3eK/+aa2QqhemRwtx
oL8S5cGPteXhPVhSsr2tvrF2nbj755FJogMywF6Rv+us1j3annCZXA8yE7rCLUHa
qYeuHjbdaAE3FsJxrxX9w92mZYsSuWgldmlIQM6gd4s9AEz2QDLm0Uv7zdE8KStp
JU5AsqZ1Ul+8c4cDnv/2
=SM5F
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
