Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab3H1AEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 20:04:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53686 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3H1AEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 20:04:43 -0400
Date: Wed, 28 Aug 2013 10:04:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>
Cc: =?UTF-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>,
        James Hogan <james.hogan@imgtec.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>
Subject: Re: linux-next: manual merge of the clk tree with Linus' tree
Message-Id: <20130828100431.3005d52d77c565c241399269@canb.auug.org.au>
In-Reply-To: <20130827165319.8231.9@quantum>
References: <20130827190304.c3f2f891f20d078d66b703b1@canb.auug.org.au>
	<521C7AF0.1020903@imgtec.com>
	<20f57100-4440-4353-9c84-6e5781f7c6d3@DB9EHSMHS025.ehs.local>
	<20130827165319.8231.9@quantum>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Aug_2013_10_04_31_+1000_AL3lxsZs/HZ=beRz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Aug_2013_10_04_31_+1000_AL3lxsZs/HZ=beRz
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 27 Aug 2013 09:53:19 -0700 Mike Turquette <mturquette@linaro.org> w=
rote:
>
> Quoting S=C3=B6ren Brinkmann (2013-08-27 08:44:11)
> > On Tue, Aug 27, 2013 at 11:09:52AM +0100, James Hogan wrote:
> > > On 27/08/13 10:03, Stephen Rothwell wrote:
> > > > Hi Mike,
> > > >=20
> > > > Today's linux-next merge of the clk tree got a conflict in
> > > > drivers/clk/zynq/clkc.c between commits 252957cc3a2d ("clk/zynq/clk=
c: Add
> > > > dedicated spinlock for the SWDT") and 765b7d4c4cb3
> > > > ("clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to ethernet muxes") f=
rom
> > > > Linus' tree and commit 819c1de344c5 ("clk: add CLK_SET_RATE_NO_REPA=
RENT
> > > > flag") from the clk tree.
> > > >=20
> > > > I fixed it up (see below and in a couple of places I chose
> > > > CLK_SET_RATE_NO_REPARENT over CLK_SET_RATE_PARENT, which may, of co=
urse,
> > > > be wrong) and can carry the fix as necessary (no action is required=
).
> > >=20
> > > The case you mentioned looks correct to me.
> > >=20
> > > I can't see todays -next yet, but if by "choose CLK_SET_RATE_NO_REPAR=
ENT
> > > over CLK_SET_RATE_PARENT" you mean one branch adds CLK_SET_RATE_PAREN=
T,
> > > clk-next adds CLK_SET_RATE_NO_REPARENT, and the resolution ends up wi=
th
> > > only CLK_SET_RATE_NOREPARENT then that sounds wrong, as the two flags
> > > are orthogonal.
> >=20
> > I can just agree, the case included in the mail looks correct, but in
> > case of other conflicts both flags should be set. Just like in the case
> > shown here.
>=20
> Stephen's fix is correct. The Zynq patches came in as fixes so I think
> this will be a rare event.

Can you guys discuss this and come up with a single answer.  I read the abo=
ve as:

(for the two places I used CLK_SET_RATE_NO_REPARENT where the two
branches each added that and CLK_SET_RATE_NOREPARENT respectively)

"Stephen was wrong"
"Stephen should have taken both"
"Stephen was right"

:-)

I can fix up my merge resolution if you tell me the correct fix.  Also,
you will need to know so that you can tell Linus (or whoever else has to
resolve these conflicts).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Aug_2013_10_04_31_+1000_AL3lxsZs/HZ=beRz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHT6TAAoJEECxmPOUX5FE77EP/3bIaHH/vz/t77ng9fxnmoXt
/trKvmT1geQx3Bo58BiQq/HWt2cSanXbpCaeffnv7kaH9yTzGW4X5jBoSWmEYldZ
fU8UnQ12YBnNqPUoD6vYf7luHWfUU54VS10pvqDkJ25QgDidn1PEF/ThPHeZCmcQ
pa4k9/jF9kaGyg4cN/cl12XHXJXPldWt9VVy3KIEsCP3Dg35GnsMxlc/EyUG0J+p
OB18lWzDJaFBiNZUh6iv+m6vcspfiayyE7xCWNn2+h2W1fRfZ8J4FgHMYdSCbCjT
DpfJW2wQkFuTx9pskQWdqag9K4tBHZ3tjsK4Za+C7LlnPwZsqDnyjUikJy/te38+
PlSD9Yo4amQhhWHOMcF8/Y5O2od5hvRxdnr3e3cbgYlADAqSCU0EBRQXUqTmbojE
DICZIe1CarlsYuQVg60q2EzSxsnycnEb+LM3TOu2PxIj8UcOh7q7FWtSERsEQnY1
L1EYqD78LaC5H9vjVzFPPYOAiSJ/xyC7D9J/d4J7Lohdl+4gyT+59qhNWrmJayCL
CpgMFp1tpyhd6904GTWNh5uVcreExpdaioO5z+MEvsdZrfPNsIHnKNOQrQoW4j9F
KF3iQ8O7LXUFGAZPrDDTZAXC1SO29PE7jbQD97wfV2TzC8RcPkjOppCup5DyycnN
jXqcPXSxcocy1rEMVqS9
=vxdZ
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Aug_2013_10_04_31_+1000_AL3lxsZs/HZ=beRz--
