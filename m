Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab3BVH2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:28:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56199 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab3BVH1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:27:25 -0500
Date: Fri, 22 Feb 2013 08:27:19 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dong Aisheng <b29396@freescale.com>
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v4] mfd: syscon: Add non-DT support
Message-ID: <20130222072718.GA24114@avionic-0098.mockup.avionic-design.de>
References: <1361460542-2872-1-git-send-email-shc_work@mail.ru>
 <20130222065548.GA3252@b29396-Latitude-E6410>
 <1361516478.223331042@f282.mail.ru>
 <20130222071311.GB3252@b29396-Latitude-E6410>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20130222071311.GB3252@b29396-Latitude-E6410>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:tfv1YHNrItr7Hn9hU2f6Cu+4kVtYsmjXjnbdhDM/sMP
 aLXYaDeP0UzhlC3oST0Ip/Y7y56whU+/3y/okdaKPJNnQaqhGz
 2a4m7o5u+ujAlgxvk0kRT8YX30lR9HmPJa0igaXauzxsWnBc6Q
 zYE3CqcziIz+jWXL/b0ZqQ0/zkingccorElHMVsxnzfVus1vuj
 XVTXlXp7SWWBOCKBHpN8VTWAlKaY9JqBEoUMz7SxP/3zYZaIEA
 jZlIyCuyykc8WBSZcDQYK2nRjIVh03Zc2KHNazfPeEs+Mio+d4
 OBfwPMssDAjVnVpbWo4c68IREOw+1vEsKtkgdu/1RY41YZuZc5
 /DOiE5uvqAbC6oanr/wezDKY69QwzKefWAa7cgOdMw+Hckhef/
 7EKYzdPToZjEfkmXEX41ExignwjGd/SVHpVY78Fhv+8hVxrwio
 RXjs7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 22, 2013 at 03:13:12PM +0800, Dong Aisheng wrote:
> On Fri, Feb 22, 2013 at 11:01:18AM +0400, Alexander Shiyan wrote:
> > > On Thu, Feb 21, 2013 at 07:29:02PM +0400, Alexander Shiyan wrote:
> > > > This patch allow using syscon driver from the platform data, i.e.
> > > > possibility using driver on systems without oftree support.
> > > > For search syscon device from the client drivers,
> > > > "syscon_regmap_lookup_by_pdevname" function was added.
> > > >=20
> > > > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > >=20
> > > [...]
> > >=20
> > > > +	syscon->base =3D devm_ioremap_resource(dev, res);
> > > > +	if (!syscon->base)
> > >=20
> > > Is this correct?
> >=20
> > Hmm, of course IS_ERR should be used here...
> > v5?
> >=20
>=20
> Yes.
> >From here:
> https://lkml.org/lkml/2013/1/21/140
> It seems it is.
>=20
> > >=20
> > > > +		return -EBUSY;
>=20
> Both this line could also be changed.
>=20
> > > >
> > >=20
> > > Otherwise, i'm also ok with this patch.
> > > Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
> > >=20
> > > BTW, i did not see Samuel's tree having this new API.
> > > So, who will pick this patch?
> >=20
> > I have same question.
>=20
> I CCed Thierry and Greg who may know it.

Yes, devm_ioremap_resource() never returns NULL. You always need to
check the returned pointer with IS_ERR(). The value that you return
should be extracted from the pointer with PTR_ERR().

Thierry

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRJx3WAAoJEN0jrNd/PrOhUSoP/1ANfDTxzJ5vPgqVp6IZyPYl
5cOKBqp+jZ9lXQdp5yTr9TTkyasNCMr6LvQt6a4Iz+oMqHrzzGy9ZBceU3aL396S
wjeCMglhSmq2faiqOJ/V8fXifF1Ee4rajxrRRJNcnE3j9XMzGWUdk5c77bRd6HVD
TNqskIvA7R1594hJwujj4PuShDNLe06r6cWnaZMUEvIfWk8JVFYyTbAG+pdXDoKC
lQZDlNyBHb3OTxDreMRsDf/OHRxtHFZ0iBxTpuvY99XfsU0AVvqQWSZMPowrKWrz
pO9Q0La4S0l6y94xsidSxYTnhaGW92lyN4Fm6LySwJpyC/AOZPEv+ULoBRuFpRFK
MbSx1QrnvDeVwEIsqmGlB1mx6mDzP59ib2gVhgh3mHG4MWTCg4Xvh7jPCo83nkgV
pETwwTTsXfg1DE/B2liqIany0gItxMp0UCXvrKgcpSDCwKLQZyVMNgz0mv4SciXo
r3ByVksy8jADlPXUrltu5vbPFc9gx5TUXKqHeHV4/Y+Up2z5lLBrSt4uJcQbZXZa
nb49SI8qw3Ok0JgIJQLlx9zWAKJ4KMf/OjzQheqOVU7KkXbVpfzBZpUXgFWLWxEY
+9pb/58PxbFoxHKwJMLC4zKYWOqD7rJG4Ub2D0la4xNY+rQGTFCGBD19proGirxu
vtX/dnrVTdUezIfPLQnu
=Nrfn
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
