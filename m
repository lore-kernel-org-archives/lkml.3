Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaBRStD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:49:03 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43212 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbaBRStA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:49:00 -0500
Date: Tue, 18 Feb 2014 12:47:41 -0600
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <sarah.a.sharp@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb/xhci: fix compilation warning when !CONFIG_PCI &&
 !CONFIG_PM
Message-ID: <20140218184741.GI28506@saruman.home>
Reply-To: <balbi@ti.com>
References: <1389059068-18491-1-git-send-email-david.a.cohen@linux.intel.com>
 <1389063739-6028-1-git-send-email-david.a.cohen@linux.intel.com>
 <20140218180030.GA10029@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OfrWf2Fun5Ae4m0Y"
Content-Disposition: inline
In-Reply-To: <20140218180030.GA10029@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OfrWf2Fun5Ae4m0Y
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2014 at 10:00:30AM -0800, David Cohen wrote:
> Hi Sarah,
>=20
> On Mon, Jan 06, 2014 at 07:02:19PM -0800, David Cohen wrote:
> > When CONFIG_PCI and CONFIG_PM are not selected, xhci.c gets this
> > warning:
> > drivers/usb/host/xhci.c:409:13: warning: =E2=80=98xhci_msix_sync_irqs=
=E2=80=99 defined
> > but not used [-Wunused-function]
> >=20
> > It happens due to lack of __maybe_unused flag on xhci_msix_sync_irqs()
> > function in case of !CONFIG_PCI.
> >=20
> > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > ---
>=20
> Ping :)
> Any comments here?
>=20
> Br, David
>=20
> >=20
> > Change v1 -> v2:
> >  - xhci_msix_sync_irqs() already uses __maybe_unused flag when CONFIG_P=
CI is
> >    set. Proper solution is to add same flag when !CONFIG_PCI instead of=
 define
> >    function as inline.
> >=20
> >  drivers/usb/host/xhci.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> > index 4265b48856f6..ed6b717b8ee1 100644
> > --- a/drivers/usb/host/xhci.c
> > +++ b/drivers/usb/host/xhci.c
> > @@ -406,7 +406,7 @@ static void xhci_cleanup_msix(struct xhci_hcd *xhci)
> >  {
> >  }
> > =20
> > -static void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
> > +static void __maybe_unused xhci_msix_sync_irqs(struct xhci_hcd *xhci)

bellow is likely a better fix. Usually stubs are marked inline, rather
than getting an unused attribute:

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 3712359..8f1a6d5 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -404,16 +404,16 @@ static int xhci_try_enable_msi(struct usb_hcd *hcd)
=20
 #else
=20
-static int xhci_try_enable_msi(struct usb_hcd *hcd)
+static inline int xhci_try_enable_msi(struct usb_hcd *hcd)
 {
 	return 0;
 }
=20
-static void xhci_cleanup_msix(struct xhci_hcd *xhci)
+static inline void xhci_cleanup_msix(struct xhci_hcd *xhci)
 {
 }
=20
-static void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
+static inline void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
 {
 }
=20

--=20
balbi

--OfrWf2Fun5Ae4m0Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTA6rNAAoJEIaOsuA1yqREPywP+waIoe2rdcrSNWn3ttaZ4+Df
ZvgdzIlG8YY4Tzw6hAccB8KB31/5nAspDbVEdWuOyaQvu3I6UgdWJ1A/ZuaMWySU
HdiOaJLpf+l5Nt1rpTJj8TEXDkl1SIbBn+pcklzxs+anmcrT65aNWwkC0Tdkfsqc
/5WzNp4e3uxY/T3aHIz3PeP+54GmhJKtg9Fv9Bc1uQ6XE0rM/EN9a7dM+fnVfus4
rJZ21oVZWVyMRzogf/TqNHn7q0yHDds+CAhRzCSQyBGzsJhLLiSBy1E21C6xhbbN
aBZncytZu3x+NLT9WS7VXzMmXdGvnfXLAWWlMFLVOvsyK+TeW6H0mNLccfLpCaky
8nPSLzbip3ex1WYWYHNAHKknzwo9DX/kB3cbg7cc0a011Qkb4zb4vWkDiYBaqOup
PZ7W2FuAcvmIEkF0sA6kvqILmGEftam/1PnVJnLWkm/8R8hPXg6JLBRG1Pe6VNZZ
TOfXuvASiZS4Rb+Cs9pFjrls9kDZ+NyTMcvQCYnu/7jKCh2EApGc9DnjnJPnOgxm
j/fM9fY5up4n65xwySftcRU9pGTLavd5vW/lKRbDV1E3w7LUnq6Q5QIcRHGUAnlL
akbJ0k+LoShtkh+5SzOXj2i4/kyzCcwwIa5vjyD0BnN2ha6sKqUwUQhJFz7glPuc
xffEamUo60jMn4/5UovI
=8xNN
-----END PGP SIGNATURE-----

--OfrWf2Fun5Ae4m0Y--
