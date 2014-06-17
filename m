Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965443AbaFQVUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:20:16 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:50598 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965386AbaFQVUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:20:08 -0400
Message-ID: <53A0AD93.7080705@Vivier.EU>
Date: Tue, 17 Jun 2014 23:05:23 +0200
From: Laurent Vivier <Laurent@Vivier.EU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Bollinger <sethb@digi.com>
Subject: Re: Broken serial port
References: <53A08D64.1060800@Vivier.EU> <53A096C2.7060800@hurleysoftware.com>
In-Reply-To: <53A096C2.7060800@hurleysoftware.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="88dWb3lPfMksJe1haGWxIPPPVX6LExqpE"
X-Provags-ID: V02:K0:wdswRatZWHp7929Pt2oo7BTT2t5tZnauM6YHt1cwv6L
 q85/89b9rZwvcYDOARZQu05EPu44rDtRkiOaT1UxTTktWNMZe8
 gKatl0lTHNcN/FmDeQU86359lbm3oADlppUFt3VmB4RUqVZr+r
 aQILeRqsjHX/RnZNti1gy4zCOqeLbJVKSJao03DLvG0Gnu3YrQ
 /otyrt3Ya/7ZCAHBz5eXcuXxbZ2nhmJRUMOokQ/221JQcxZ1KK
 j5Du2vmRozj4dUp4C99vBPYScg84kD2uIjpwVJ6B7BDgnetB8R
 7nRKNHZyWZ992XwU3mu2ltkEtDx6j8qIjWFbj/Ht/Y6NhMVesF
 sJXq57w0tZL8wYgIZEEM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--88dWb3lPfMksJe1haGWxIPPPVX6LExqpE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le 17/06/2014 21:28, Peter Hurley a =C3=A9crit :
> On 06/17/2014 02:48 PM, Laurent Vivier wrote:
>> Hi,
>>
>> I'm not subscribed to these mailing lists, so CC: me.
>>
>> I'm playing for some days with a kernel 3.15 on an old mac performa 57=
5
>> and it seems that the serial port is broken. When I log on using the
>> console on the serial port it seems there is an screen refresh added
>> after each character I send.
>=20
> What uart driver is this happening on?
>=20
> This is a known bug being worked on for these uart drivers:
> sunsab
> sunzilog
> ip22zilog
> pmac_zilog

Seems to be pmac_zilog, from dmesg :

pmac_zilog: 0.6 (Benjamin Herrenschmidt <benh@kernel.crashing.org>)
scc.0: ttyS0 at MMIO 0x50f0c022 (irq =3D 4, base_baud =3D 230400) is a
Z85c30 ESCC -
 Serial port
scc.1: ttyS1 at MMIO 0x50f0c020 (irq =3D 4, base_baud =3D 230400) is a
Z85c30 ESCC -
 Serial port

If needed, I can test the fix.

Thank you.

Regards,
Laurent

> Regards,
> Peter Hurley
>=20
>> A little demo :
>>
>> http://asciinema.org/a/10211 [at 3:20]
>>
>> I bisect and I found this commit :
>>
>> commit 717f3bbab3c7628736ef738fdbf3d9a28578c26c
>> Author: Seth Bollinger <sethb@digi.com>
>> Date:   Tue Mar 25 12:55:37 2014 -0500
>>
>>      serial_core: Fix conditional start_tx on ring buffer not empty
>>
>>      If the serial_core ring buffer empties just as the tty layer
>> receives
>>      an XOFF, then start_tx will never be called when the tty layer
>>      receives an XON as the serial_core ring buffer is empty.  This wi=
ll
>>      possibly leave a few bytes trapped in the fifo for drivers that
>>      disable the transmitter when flow controlled.
>>
>>      Signed-off-by: Seth Bollinger <sethb@digi.com>
>>      Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>>
>> If I revert it, all works fine :
>>
>> http://asciinema.org/a/10212
>>
>> Regards,
>> Laurent
>>
>=20



--88dWb3lPfMksJe1haGWxIPPPVX6LExqpE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOgrZQACgkQNKT2yavzbFMIrQCfYf7YTmRSs+s8oud/W08w/Gc6
SioAoIeOSWLAe7h6U4Ngk5gVd1X8bOZm
=l6tV
-----END PGP SIGNATURE-----

--88dWb3lPfMksJe1haGWxIPPPVX6LExqpE--
