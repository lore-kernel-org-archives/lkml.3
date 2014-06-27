Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaF0LDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:03:48 -0400
Received: from sauhun.de ([89.238.76.85]:51499 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbaF0LDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:03:46 -0400
Date: Fri, 27 Jun 2014 13:03:34 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: rjw@rjwysocki.net, mika.westerberg@linux.intel.com, awilliam@redhat.com,
        lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V3 4/5] I2C/ACPI: Add i2c ACPI operation region support
Message-ID: <20140627110333.GC2641@katana>
References: <1400590764-11108-1-git-send-email-tianyu.lan@intel.com>
 <1400590764-11108-5-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qtZFehHsKgwS5rPz"
Content-Disposition: inline
In-Reply-To: <1400590764-11108-5-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qtZFehHsKgwS5rPz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 08:59:23PM +0800, Lan Tianyu wrote:
> ACPI 5.0 spec(5.5.2.4.5) defines GenericSerialBus(i2c, spi, uart) operati=
on region.
> It allows ACPI aml code able to access such kind of devices to implement
> some ACPI standard method.
>=20
> ACPI Spec defines some access attribute to associate with i2c protocol.
> AttribQuick 	       	       		Read/Write Quick Protocol
> AttribSendReceive			Send/Receive Byte Protocol
> AttribByte 			 	Read/Write Byte Protocol
> AttribWord				Read/Write Word Protocol
> AttribBlock				Read/Write Block Protocol
> AttribBytes				Read/Write N-Bytes Protocol
> AttribProcessCall			Process Call Protocol
> AttribBlockProcessCall			Write Block-Read Block Process Call Protocol
> AttribRawBytes 				Raw Read/Write N-BytesProtocol
> AttribRawProcessBytes			Raw Process Call Protocol
>=20
> On the Asus T100TA, Bios use GenericSerialBus operation region to access
> i2c device to get battery info.
>=20
> Sample code From Asus T100TA
>=20
>     Scope (_SB.I2C1)
>     {
>         Name (UMPC, ResourceTemplate ()
>         {
>             I2cSerialBus (0x0066, ControllerInitiated, 0x00061A80,
>                 AddressingMode7Bit, "\\_SB.I2C1",
>                 0x00, ResourceConsumer, ,
>                 )
>         })
>=20
> 	...
>=20
>         OperationRegion (DVUM, GenericSerialBus, Zero, 0x0100)
>         Field (DVUM, BufferAcc, NoLock, Preserve)
>         {
>             Connection (UMPC),
>             Offset (0x81),
>             AccessAs (BufferAcc, AttribBytes (0x3E)),
>             FGC0,   8
>         }
> 	...
>      }
>=20
>      Device (BATC)
>      {
>          Name (_HID, EisaId ("PNP0C0A"))  // _HID: Hardware ID
>          Name (_UID, One)  // _UID: Unique ID
> 	 ...
>=20
>             Method (_BST, 0, NotSerialized)  // _BST: Battery Status
>             {
>                 If (LEqual (AVBL, One))
>                 {
>                     Store (FGC0, BFFG)
>                     If (LNotEqual (STAT, One))
>                     {
>                         ShiftRight (CHST, 0x04, Local0)
>                         And (Local0, 0x03, Local0)
>                         If (LOr (LEqual (Local0, One), LEqual (Local0, 0x=
02)))
>                         {
>                             Store (0x02, Local1)
>                         }
> 	...
>=20
>     }
>=20
> The i2c operation region is defined under I2C1 scope. _BST method under
> battery device BATC read battery status from the field "FCG0". The request
> would be sent to i2c operation region handler.
>=20
> This patch is to add i2c ACPI operation region support. Due to there are
> only "Byte" and "Bytes" protocol access on the Asus T100TA, other protoco=
ls
> have not been tested.
>=20
> About RawBytes and RawProcessBytes protocol, they needs specific drivers =
to interpret
> reference data from AML code according ACPI 5.0 SPEC(5.5.2.4.5.3.9 and 5.=
5.2.4.5.3.10).
> So far, not found such case and will add when find real case.
>=20
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

Added Mika's review tag and applied to for-next, thanks!


--qtZFehHsKgwS5rPz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTrU+FAAoJEBQN5MwUoCm26gcQAI8ZS/ujjq38OT5p839GNkhw
62P2pU4LrXLzK7la4wCrWPLu5jBfFZTJwV6fisXMniWqbqzOrPZew6BbrmDu/cQM
QvTjk6oL+HzwL9i1QOsfLQQVSbP248WRl2yGNXftH4wmwP76wCxlhCBVmUbFce5f
yZNgxq2EZ7QjY03NBoNUoR1CowwGuDe8EoJn0CJTlXLrJNZO4HevdxOYBIF+UmKp
rTdHnlGp7s2v7DkL9SxGK7CV+kCDrpvn8G83sUwuAHB3mj1HsUNniJDFYvln6tPa
djfhtz1aVZ/EkzWboBTP1gBaKLsGh3Reo34VMVxvlRwm685Oj/4wNWt3WgmDjHGO
CNFY1zSqCYfRWFakSRUnIsaHPLXpRf4FeBvSBX0u96DKmEQ9snhb4QT8nGkP8aX9
z5bgq4D+c7v90vck1EGOvbVkIr2izg9tT+RAbpU7tghPMJZ1Zq4p2NAKChpkvDgR
FIZkCfmT4OSThAsuiJqL3d1G00heu/F6M+J+DdvxU66NT+FQKQG+D8Q2FO6iZPDQ
Ii/3a2341PFYV9JYu1N3NK5J9hO8Jei4UfGTCI9T3H3+BBs8vgJ0LRgwMUjRgjRt
89xJCmg+Y9QXLqfxRTLb4iTs0qop5YTVLe70LR9BGDKkjgIDvIovZoeq374NZfn9
gV1j1tUNUBiaAkmdr0cQ
=kAse
-----END PGP SIGNATURE-----

--qtZFehHsKgwS5rPz--
