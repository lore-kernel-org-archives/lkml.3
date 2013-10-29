Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab3J2AKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 20:10:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691Ab3J2AKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 20:10:51 -0400
Date: Tue, 29 Oct 2013 11:10:37 +1100
From: NeilBrown <neilb@suse.de>
To: Mark Brown <broonie@kernel.org>
Cc: Alex Courbot <acourbot@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: Any news on Runtime Interpreted Power Sequences
Message-ID: <20131029111037.6e59499d@notabene.brown>
In-Reply-To: <20131028235344.GB16686@sirena.org.uk>
References: <20131025112224.6e5265e6@notabene.brown>
	<526A0E71.100@nvidia.com>
	<20131025183345.2b963e13@notabene.brown>
	<526E3605.9080002@nvidia.com>
	<20131028221004.3294c1ea@notabene.brown>
	<20131028235344.GB16686@sirena.org.uk>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/b3VR9kQfisD2E9rJ_6neAcX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/b3VR9kQfisD2E9rJ_6neAcX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Oct 2013 16:53:44 -0700 Mark Brown <broonie@kernel.org> wrote:

> On Mon, Oct 28, 2013 at 10:10:04PM +1100, NeilBrown wrote:
>=20
> > I agree that this power-up sequence should be a property of the device.
> > However until the device has been powered up, Linux doesn't know about =
it.
> > Neither a board file or a devicetree can (as far as I can tell), tell t=
he
> > MMC port that a particular card is attached.  Rather the host probes th=
e card
> > to see what it is.
> > So there isn't any way for the device driver to get control at the
> > appropriate time to effect the proper sequencing.
>=20
> If it is a genuinely pluggable MMC slot then I'd expect the sequence to
> be implementing whatever is required for standard MMC enumeration to
> work.  If the device is a soldered down one with extra control (as is
> quite common) then there shouldn't be a problem describing it?

Yes, the device is soldered down and has a reset line that needs to be puls=
ed
low at about the same time that the MMC port enables the regulator.

How do you propose that I describe this?  Which driver should know about the
reset GPIO, how to I tell it about the GPIO, and which function should do t=
he
pulsing?

Thanks,
NeilBrown

--Sig_/b3VR9kQfisD2E9rJ_6neAcX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUm78/Tnsnt1WYoG5AQKXXQ/8DqthJiyg61Ukzd/1FwchfiarukJYfh7z
VBGIem0lBRNGUblNIXRPSZmg0sQYsWiyhM8AT8QzZHfn2AV2Mt0nepjQt9RcxxpW
6uNZmZQbRn09RGuU4gMQMJRkYaRhe/iyL0XeoTqAIKH3IgAShBqu/mfrQSG8xTp1
wqh/4J1DXhxchNuMuyfaXQ7dI33OFkMCpNjrO34kU1I+kYgvBhNiXrg6ttYq5SRw
CsuHmodHwKDBjG/tldpu+S3p2jRQD/QYDjoCbQzY35uPdKzqp7vy4bCw4y8NnBLb
EmMnB4EpThvc9C3K1x3JXg0zErK6Pjibh+1sAm9YnsG8iFZQ26FhNHEIr5K9wSM8
lezHtSP/7kgaYVoRW9Nw3HDLo4LCt5Iv/fwxfhO/jArNfYbEwMa3McYb6+sdtND0
WDb4J7jld/H+0f3Tu5N958hzJyBosEJbmK0rzmSReop7duE9lV7W0rOFw9YUbZE6
DYXbUhLi7ricOptrkef/1NwkLy3Vtzrvfz56ngz+OYAurMA7cHeo1y7tc+nP0N+R
Br9WMsMyYwHNSaCZ8mSnyY1//dv7AI6eyosWKlFzai55tiKpjjpeW6FW/fv8GDnd
hUvCbIoJMaYrxn/uSOyXyyAL575wlMn3ZsnLKelvJyYABIpseyu3wonSgyeC//Pc
F78DGw0gEtg=
=xA6D
-----END PGP SIGNATURE-----

--Sig_/b3VR9kQfisD2E9rJ_6neAcX--
