Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbbAMQsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:48:32 -0500
Received: from sauhun.de ([89.238.76.85]:35974 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbbAMQsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:48:30 -0500
Date: Tue, 13 Jan 2015 17:48:29 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c / ACPI: Pick the first address if device has multiple
Message-ID: <20150113164829.GO7660@katana>
References: <1419860928-195404-1-git-send-email-mika.westerberg@linux.intel.com>
 <20150113155059.GN7660@katana>
 <1421167477.4459.229.camel@spandruv-desktop.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nG9yj4eE4W6Oba0"
Content-Disposition: inline
In-Reply-To: <1421167477.4459.229.camel@spandruv-desktop.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+nG9yj4eE4W6Oba0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2015 at 08:44:37AM -0800, Srinivas Pandruvada wrote:
> On Tue, 2015-01-13 at 16:50 +0100, Wolfram Sang wrote:=20
> > On Mon, Dec 29, 2014 at 03:48:48PM +0200, Mika Westerberg wrote:
> > > ACPI specification allows I2C devices with multiple addresses. The cu=
rrent
> > > implementation goes over all addresses and assigns the last one to the
> > > device. This is typically not the primary address of the device.
> > >=20
> > > Instead of doing that we assign the first address to the device and t=
hen
> > > let the driver handle rest of the addresses as it wishes.
> > >=20
> > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> >=20
> > Yes, seems better than what we do know. But maybe taking the lowest
> > address is a bit better heuristic than taking the first address?
> > Not sure, though...
> The problem in taking lowest is that in many cases in current devices,
> the lowest address may end being 0x0C, which is reserved address for
> SMBUS (ARA). This will require different handling. Unfortunately ACPI
> doesn't have a way to distinguish whether SMBUS support is desired or
> not.=20
> The other option is to skip all reserved addresses for SMBUS also and
> then create on the lowest.

Well, this makes me think that Mika's approach is probably the sanest
one...


--+nG9yj4eE4W6Oba0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtUxcAAoJEBQN5MwUoCm2h6gQAKPX2S2zYcUK/yY8tufCA2+w
5Ev4vljd7wa7hemJd8cOV0rb5tv2kEMhoU9CUqdHuIfFkLMedA7CKvQOJTlhQGnT
Qe1hak/3buESfhdQxmusuEsc6D5Djac0qLgE2pKYacwokNWus6vvjW3oF9zDQm0z
GsBCFwvVeWp8OrruPDIVTeBeJP1TZx+xae5gcAPUeGfLJIAaiwRN8ct6e5GE1BSS
rpzFxmG9Fa/zE1YcsnKj88jTHT6GHupNu9Eib0A4P7WOZrOgWlHNgyIFzmZqAwD+
XYtMayb7dWBzLslPr5X9RueTZ36y6SHTxSMslcJbC7aIpY7JHcmHRDstxqAq6R8G
cDNS4J7UUJgcexJDiU6qrpUTtehMeZzK7GUaKwhanqbckJxVQdV5QEh6qDkd6F9K
QpdNhTGDtostn4zf/ZC4XwfWT+0TdX5lamyk4J2D6tX+jUu+JFqqDd6FXZLCKH3u
sFlRXO3FGPJkSm8hlhlx46VgmpFRfHtyVyTuDzUp4iXvvCRlOFfPnCB7TaJIClnj
MBAm56NM8aulmwEsZH7Ys2VtBegPTyShqiaG2vhg004/0B0cQpXDZCFwoSABvkso
gkqMQLSReab1Xk8hDssRoIhwYksiLWiLlG5OThuJyBLbO6pdXycH4MIFde4yPRNB
OrbyYrDnxirqLbweKqOf
=WO18
-----END PGP SIGNATURE-----

--+nG9yj4eE4W6Oba0--
