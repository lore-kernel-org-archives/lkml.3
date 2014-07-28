Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaG1O0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:26:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:44736 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbaG1O0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:26:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,749,1400050800"; 
   d="asc'?scan'208";a="576586082"
Date: Mon, 28 Jul 2014 19:48:12 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Arnd Bergmann <arnd@arndb.de>, andriy.shevchenko@intel.com,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH v11 0/2] Add support for the Allwinner A31 DMA
 Controller
Message-ID: <20140728141812.GE8181@intel.com>
References: <1405626376-471-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140725131217.GS8181@intel.com>
 <20140725163746.GC20328@lukather>
 <20140725164218.GW8181@intel.com>
 <20140728101402.GD3952@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xA/XKXTdy9G3iaIz"
Content-Disposition: inline
In-Reply-To: <20140728101402.GD3952@lukather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xA/XKXTdy9G3iaIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 12:14:02PM +0200, Maxime Ripard wrote:
> On Fri, Jul 25, 2014 at 10:12:18PM +0530, Vinod Koul wrote:
> > On Fri, Jul 25, 2014 at 06:37:46PM +0200, Maxime Ripard wrote:
> > > > Can you please send follow patches for these:
> > > > - don't recall if I pointed earlier, but can we use direct conversi=
on for
> > > >   calculating convert_burst() and convert_buswidth(), latter one at=
 least
> > > >   seem doable
> > >=20
> > > Ok. Do you still want the error reporting for the invalid width and
> > > burst size?
> > I think for convert_buswidth() we can do away with a switch case and co=
nvert
> > the numbers directly
>=20
> Well, it's already using a switch. Do you want me to remove completely
> the function and move the switch where it's used? It's used two times
> now, so I'd like to avoid duplicating it.
You can probably remove switch in these function by converting them
arithmetically..

> > > > - don't use devm_request_irq(). You have irq enabled and you have k=
illed
> > > >   tasklet. This is too racy. You need to ensure no irqs can be gene=
rated before killing
> > > >   tasklets.
> > >=20
> > > Ok, would calling disable_irq before killing the tasklet an option for
> > > you ? that would allow to keep the devm_request_irq.
> > disable_irq also does syncronize, so it might work. But then again if t=
he
> > probe fails after registering irq due to some other reason, and you get=
 into
> > races with unitialized driver as well.
> >=20
> > I think it might be easier to amnge by working with plain old request_i=
rq()
>=20
> Yes, devm_free_irq like Russell suggested seems to both address your
> concerns, while not having to care about it at probe.
OK, pls send the fix

--=20
~Vinod

--xA/XKXTdy9G3iaIz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJT1lujAAoJEHwUBw8lI4NHQTMP/iByNWQaet7BMh7AbcpDnvRt
5GbIFTlx7oCJHbJ7w18lBGDOO7SY9RmOP7rECtm2EQ+nKOn3MRdCuTVk0jpdHttS
Kkjj3VcJmngf3dEEqCHIg4taQBrVtRgSkECbYEEKrzccymh+xFPc5IpbkAGADTqA
FGhpyWUOzjg+hDDd82ngx5oIi5U+Gl4RJyUr8/jEAPeQ3UJOo27x62iIlKWbYLsv
APFsnCKghP3/3TqWfguxopzFKxxdWIC6WWW8mKln1CFMNb17w0f8LcpNloSw/oGZ
fEDSN4L9pgzSL8gVaW41me+IIiNBCvfKE5QLQ3auBQLbCmVbn+hXQRXYSfWXB/hJ
Ug+HLMLRmJBROg08Z6tOq4a7HetT/QjlkCPxG59ulZJCfo/XvXFmbYobPZWFP2rr
t8A3d89JxpVGGTFZwpukCi+NrZZKOeE74JBbUJ/L9MGsCNjhEdiGiOR6tIH4lval
82EoAqv8uycUfoyiRHn8bnJiRRPY+pzBlXnE09Jh7ItY0Fa44y8WV3FB19ZraW21
nuZpDMCxHvtD+FikidBmJ1eAx+VlnaciOzfuWR2T7dhMnlLuHzpHqYT24mOgTmKw
8oK0PaY5kP/VSfINY2VaI107shwsZASlfG7KnFwpToLrI/tenghbZjJFhvQ/nFOa
x0wujdlhB7tdlAscS3tR
=VDFw
-----END PGP SIGNATURE-----

--xA/XKXTdy9G3iaIz--
