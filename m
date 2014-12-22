Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbaLVQoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:44:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33906 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbaLVQoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:44:08 -0500
Date: Mon, 22 Dec 2014 10:43:17 -0600
From: Felipe Balbi <balbi@ti.com>
To: Luis Henriques <luis.henriques@canonical.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ronald Wahl <ronald.wahl@raritan.com>, Felipe Balbi <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-usb@vger.kernel.org>, <stable@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RESEND PATCH] usb: gadget: at91_udc: move prepare clk into
 process context
Message-ID: <20141222164317.GJ12815@saruman>
Reply-To: <balbi@ti.com>
References: <1416411447-31112-1-git-send-email-nicolas.ferre@atmel.com>
 <20141120195049.GF23217@saruman>
 <20141219135123.GA2620@charon>
 <54942FDC.8030404@raritan.com>
 <5494314F.1030002@atmel.com>
 <20141219141831.GB2620@charon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9pltayyoy9lWEMH"
Content-Disposition: inline
In-Reply-To: <20141219141831.GB2620@charon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--M9pltayyoy9lWEMH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 19, 2014 at 02:18:31PM +0000, Luis Henriques wrote:
> On Fri, Dec 19, 2014 at 03:08:15PM +0100, Nicolas Ferre wrote:
> > Le 19/12/2014 15:02, Ronald Wahl a =E9crit :
> > > On 19.12.2014 14:51, Luis Henriques wrote:
> > >> Hi Felipe,
> > >>
> > >> On Thu, Nov 20, 2014 at 01:50:49PM -0600, Felipe Balbi wrote:
> > >>> On Wed, Nov 19, 2014 at 04:37:27PM +0100, Nicolas Ferre wrote:
> > >>>> From: Ronald Wahl <ronald.wahl@raritan.com>
> > >>>>
> > >>>> Commit 7628083227b6bc4a7e33d7c381d7a4e558424b6b (usb: gadget: at91=
_udc:
> > >>>> prepare clk before calling enable) added clock preparation in inte=
rrupt
> > >>>> context. This is not allowed as it might sleep. Also setting the c=
lock
> > >>>> rate is unsafe to call from there for the same reason. Move clock
> > >>>> preparation and setting clock rate into process context (at91udc_p=
robe).
> > >>>>
> > >>>> Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
> > >>>> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > >>>> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > >>>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > >>>> Cc: Felipe Balbi <balbi@ti.com>
> > >>>> Cc: <stable@vger.kernel.org> # v3.17+
> > >>>> ---
> > >>>> Hi Felipe,
> > >>>>
> > >>>> I forgot to answer you on this patch. So I resend it now with the =
proper
> > >>>> "stable" tag. You can also queue it during this -rc phase if you f=
eel it is
> > >>>> still possible.
> > >>>
> > >>> I think it's late for v3.18, so it'll go on v3.19 and get backporte=
d to
> > >>> 3.17 and 3.18. Sorry :-s
> > >>>
> > >>
> > >> Although this commit (b2ba27a5c56f "usb: gadget: at91_udc: move
> > >> prepare clk into process context") is tagged for stable v3.17+, it
> > >> seems like it could be applied to earlier kernels.
> > >>
> > >> 3.16, 3.13 and 3.12 seem to be affected by the same issue (and they
> > >> all include commit 7628083227b6 "usb: gadget: at91_udc: prepare clk
> > >> before calling enable").  Is there any reason for not applying it in
> > >> these trees?
> > >=20
> > > Not to forget 3.14 (LTS) which was the branch where I primarily found=
=20
> > > the issue...
> >
>=20
> Yes, of course!  Sorry.
>=20
> > Well it's maybe an issue with the re-naming of the directory to
> > drivers/usb/gadget/udc/ introduced by patch:
> > 90fccb529d24 (usb: gadget: Gadget directory cleanup - group UDC drivers)
> >=20
> > The patch doesn't apply out of the box but it surely can be applied in
> > those earlier kernels.
> >=20
> >
>=20
> Right, the file was renamed but the backport seems to be trivial.
> Thanks for confirming.

can someone resend the patch with the correct Cc: stable tag so I can
apply it ?

--=20
balbi

--M9pltayyoy9lWEMH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmEokAAoJEIaOsuA1yqREKuIP/0mQp59D9MjPAe+h7dMrqwxy
lnBMfth38iAF2TacCt/KlaRaLd+kGvbb1I6vBoCx8iKeTuChTvgQFfSSmdHCwKfJ
W0ywd+O5h7dDLzjcsD+52fA/y2OzZN7OeoBJPJ/0jLX6colaV8cpTaDizKJgdsmU
0AHH7E9TPsvXseZ/Wf+iqMwafn5pBce6i04yGtQS1/s9wkRr7edL69Bo93syUjpF
OTas2kUplZ9b3y13hWgTum/0A3rNdB4qacxqxtF7BCnhLwuNF0Z2ws+Quj+Zcqle
t5uGFYzgNHt6uT+Vstr+TIoY6o2k1JzfDQL4utrdNxC1fNOv80KkBufcOCdgJSYF
MW/1ZrB0fOESvGm/eUncB3p5k2jhqpPeBhfnN7y4ltxxHgfKyTPP5oRgoIWaGXkP
ePwnVmLUowHB/zxLUic87KVnOEQMxYMN4vMjIjJTLbut9R8vlIMzTAyQWQ/76bi/
hq/4FSXPVL0/06iXB17rzKwG2NZFhcA7nMIY/WOB/juSOVA+v8s6msc1rBPgkNfW
5JVdUy6JYz65f/EDSz+qb9CKXux2MIMDiGPTgDiKlZGTlYzdrNJvr/RyxQIBeqJV
T69nY0TKxG7qOThmo3TkBf4QjAy9T3rFA6b2Ox/eHfJv/HTAB6S/TIuxvf4WrsO9
t1lsWfU74Z/Z9i4EdHLQ
=+UBj
-----END PGP SIGNATURE-----

--M9pltayyoy9lWEMH--
