Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbaJ1JAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:00:10 -0400
Received: from down.free-electrons.com ([37.187.137.238]:59068 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755026AbaJ1JAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:00:05 -0400
Date: Tue, 28 Oct 2014 09:59:08 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 0/8] ARM: at91: Remove mach/ includes from the reset
 driver
Message-ID: <20141028085908.GB31979@lukather>
References: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
 <20141028085053.41c6ce46@bbrezillon>
 <20141028085202.GC722@piout.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <20141028085202.GC722@piout.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 28, 2014 at 09:52:03AM +0100, Alexandre Belloni wrote:
> Hi,
>=20
> On 28/10/2014 at 08:50:53 +0100, Boris Brezillon wrote :
> > Hi,
> >=20
> > On Tue, 28 Oct 2014 00:09:29 +0100
> > Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
> >=20
> > > This series removes the mach/ headers dependency from the reset drive=
r. It is
> > > also laying some groundwork for the necessary power management suppor=
t rework.
> > >=20
> > > The first patch adds and export a function to shutdown the sdram from=
 the sdramc
> > > driver. That function also take the RSTC CR register and a value as p=
arameters
> > > to be able to reset the chip. This is a hackish way of doing it but i=
t ensures
> > > that all the code fits in one cache line. We already have plan to sta=
rt using
> > > the sram to have a cleaner way to execute that code safely as soon as=
 that
> > > series goes in:
> > > http://lists.infradead.org/pipermail/linux-arm-kernel/2013-September/=
198778.html
> > >=20
> > > The second patch makes the sdramc driver usable from the board files.
> > >=20
> > > The third patch actually registers the sdramc driver from the boards =
files.
> > > The fourth patch does the same, only for sam9g45 and sam9rl to simpli=
fy future
> > > merging as the board files have been removed. Simply drop that patch.
> > >=20
> > > The fifth patch makes the at91-reset driver use the newly created
> > > at91_ramc_shutdown() function and removes the mach/ headers inclusion.
> >=20
> > I'm not a big fan of this approach.
> >=20
> > I definitely think each step of the reset process should be handled in
> > the appropriate block (and the patch series you pointed out would
> > definitely help in achieving this goal), but you're just moving all the
> > stuff done in the reset driver into the SDRAM one, which means you're
> > solving one design issue by introducing a new one.
> >=20
> > Moreover, the errata at the origin of this hack is attached to the RSTC
> > (Rest Controller) block in the datasheets.
> >=20
>=20
> I agree it is still not clean but it is a step in the good direction.
> The sdram shutdown will have to be down in the sdram driver at some
> point, even if the errata is attached to the reset controller. At least,
> the series introduces a function to do the sdram shutdown.

Not really. AFAICS, this adds a function to reset the CPU. Actually,
it doesn't add anything at all, it just copies what was done in the
reset driver.

> > I'd rather keep the reset driver as is and move SDRAM related macros
> > into a specific header (include/linux/memory/atmel-sdram.h or
> > include/soc/atmel/memory.h as you proposed) so that the reset driver
> > can reference them without including mach headers.
> >=20
>=20
> My personal opinion is that it is better to hide the registers/bits from
> the reset driver right now as we have two different IPs and the sdram
> driver already knows how to make the difference between them.

The reset driver doesn't do anything anymore with these patches. Why
not just remove it altogether?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUT1rcAAoJEBx+YmzsjxAgEf4QAKMRVlkCEJNQIgKGFO+nbHch
e7xmM8wmTTg9RR3XGaCfU5+Mc8fBVsjf1SaOt7QBb/B5cK6rbDMcgE4ieCu4Uukg
IOXqs+nkRgmIyafjDno4K6z7toYEc6CQQhmuGB6NHCsAkxBTrnb2e/dKd4eZT/vx
6p4twQYjdOzh6YaopaRAWQFGQybahBTd7LzX9gAmwfCSQZ90uDugM57uVK5I6g4K
fmbEid0I0tT22MSzFGqQ8NyZ+H0tX+rTiTfFhZW+QSP33VG7K/TIOxg6dRb+K2QL
WSRBtBTEKUm25Iju7H3/gKp+t5DHOFhW7TIyGHsgfBua8fELM/oob20FU9DFOSZ8
U4BZH2siAwMDmWjY3EupDZS/E6S19oR0fP4LpF4uRgzeKx0yhkio/2BJvQnjIQIf
Anw7RRFV46iBQIBaCD2v/buPfW5176xpSRDwUOGGcvc1zAYdLUb8WROOnDqPPQgR
XYs44VHS8ba7gnJUTeHk+uNCTdZ/jR8QG0jqJNDkoi7VFyRuLZBxg+gromXSxKHo
tELT7PD8Nc6l1nVWRXdXRBcjKsbcHpohNKsCOPlIr5yPmMIG0TULzSqXBphKcEhh
4V9dTRF7barksevq1NZgTSbk1ubsUxpwQRBDZ1uONokM5cW2mF3JndhEIw3/bIjL
IE75N8YJtduS2e2/0s4A
=Yhcu
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
