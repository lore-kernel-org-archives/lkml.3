Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab3IWUbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:31:03 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41015 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab3IWUbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:31:00 -0400
Date: Mon, 23 Sep 2013 22:29:36 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/9] irqdomain: Introduce __irq_create_mapping()
Message-ID: <20130923202935.GA5216@ulmo>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
 <1379320326-13241-3-git-send-email-treding@nvidia.com>
 <CACRpkdYo8knzZ+Z-tc7fyEGwX5bt4RvMU3TR3k3UrOj0KRJocw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <CACRpkdYo8knzZ+Z-tc7fyEGwX5bt4RvMU3TR3k3UrOj0KRJocw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2013 at 09:14:30PM +0200, Linus Walleij wrote:
> On Mon, Sep 16, 2013 at 10:31 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>=20
> > This is a version of irq_create_mapping() that propagates the precise
> > error code instead of returning 0 for all errors. It will be used in
> > subsequent patches to allow further propagation of error codes.
> >
> > To avoid code duplication, implement irq_create_mapping() as a wrapper
> > around the new __irq_create_mapping().
> >
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
>=20
> Surprise! I don't like this.
>=20
> I think it is better to first go over the call sites and make them
> all handle negative return numbers rather than pushing the
> obscure __interface.
>=20
> I know from patch 0 that you think it's too much to change these
> 127 call sites but I don't think so, and I'm happy to merge one
> big patch changing all the 20 users in drivers/gpio.
>=20
> Likewise with the 11 consumers in drivers/pinctrl.
>=20
> It's just a a few archs+subsystems and it's just plain work.

Well, the problem is that the current patch changes the signature of the
function as well, therefore the call sites will have to be updated all
at once in a single patch to avoid build breakage. And that's excluding
any potential fallout from new callsites added between the creation of
the patch and its application.

Another alternative could be to change the signature in a way that does
not break compatibility. For instance I think it could work out if we
change this function to return int instead of unsigned int but keep the
same semantics to begin with (return 0 on failure). Then update all call
sites to handle potential negative errors and after that return negative
error codes. That still wouldn't catch any callers introduced between
the patch creation and application.

Thierry

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQKSvAAoJEN0jrNd/PrOh0LsP/iAbSX1dVXCmb8C92d91DSva
PLyYP5BNn5qIrulewqzl5XMEA9zQVg5NjYJZgqzf5n54EVGe/4s24CqCTEeNKohl
9oE2dc70UHupJmP8Uo94dMi28U94bzDyyGSxmaVoHtiLo1Z7N1djjZyOc3BiGso3
VVCALPfAWhiZ14w2EXVKKxh2gCP7cqSJzgMkNo+wsZ/nV0Hbx6RWt3JvSMHhVVvZ
INVR6dbdnHrLHNRpiFXLUQR1G8xOIku/Os0EhyaRmgY/4fDQpmijpL2VtzLP2GF/
G3zUflzzV7JgFnXRyoWkEIgPd9uxFaxG6F5xf7U9MMUV8zzDZFT+1ZmPhsSl+l30
yrm6fUFC0QBvVfn/vEZgUllo3pAFoPdXCGV8yB8xwAtb5UIkhwkxYsf+zt/1P2al
oyKXCVJ3+9Io6rLOYGDHmsI4+R71ztQtWtz2jbC5+dn4nU5he5Xtw1k2bE6+gSHl
Qu0MjNRgMZxyJJ5uZFNI2ZlTeqlt5gs3CpdjgUlZd1ntgT8BzpX6wWBiCUMhMwZn
AEX9rUSLcpIPhHLUDc9+P3d60KTL+cwETf7u5IEQPcHrmie+Wm/Hssmtzl3cK1Oo
I8ut+HoKFqTPzhrdiSbB+zaxVyedim1lX/1fjrxzOrLKWmDmdNfpuITwr9A88qsH
V5s8sAiD8V8+CQKHpjig
=89Ks
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
