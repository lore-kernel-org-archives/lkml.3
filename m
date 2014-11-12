Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaKLPAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:00:36 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46007 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbaKLPAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:00:35 -0500
Date: Wed, 12 Nov 2014 09:00:57 -0600
From: Felipe Balbi <balbi@ti.com>
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Felipe Balbi <balbi@ti.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux USB Mailing List" <linux-usb@vger.kernel.org>
Subject: Re: usb: gadget: midi: f_midi_alloc() can be static
Message-ID: <20141112150057.GD641@saruman>
Reply-To: <balbi@ti.com>
References: <201411121904.vA8htDl2%fengguang.wu@intel.com>
 <20141112132824.GA27653@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZInfyf7laFu/Kiw7"
Content-Disposition: inline
In-Reply-To: <20141112132824.GA27653@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZInfyf7laFu/Kiw7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 09:28:24PM +0800, Fengguang Wu wrote:
> drivers/usb/gadget/function/f_midi.c:1072:21: sparse: symbol 'f_midi_allo=
c' was not declared. Should it be static?
> drivers/usb/gadget/legacy/gmidi.c:118:30: sparse: symbol 'fi_midi' was no=
t declared. Should it be static?
> drivers/usb/gadget/legacy/gmidi.c:119:21: sparse: symbol 'f_midi' was not=
 declared. Should it be static?
>=20
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

I'm taking this one, but next time please Cc linux-usb

> ---
>  function/f_midi.c |    2 +-
>  legacy/gmidi.c    |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> Index: linux/drivers/usb/gadget/function/f_midi.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/usb/gadget/function/f_midi.c
> +++ linux/drivers/usb/gadget/function/f_midi.c
> @@ -1069,7 +1069,7 @@ static void f_midi_unbind(struct usb_con
>  	usb_free_all_descriptors(f);
>  }
> =20
> -struct usb_function *f_midi_alloc(struct usb_function_instance *fi)
> +static struct usb_function *f_midi_alloc(struct usb_function_instance *f=
i)
>  {
>  	struct f_midi *midi;
>  	struct f_midi_opts *opts;
> Index: linux/drivers/usb/gadget/legacy/gmidi.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/usb/gadget/legacy/gmidi.c
> +++ linux/drivers/usb/gadget/legacy/gmidi.c
> @@ -115,8 +115,8 @@ static struct usb_gadget_strings *dev_st
>  	NULL,
>  };
> =20
> -struct usb_function_instance *fi_midi;
> -struct usb_function *f_midi;
> +static struct usb_function_instance *fi_midi;
> +static struct usb_function *f_midi;
> =20
>  static int __exit midi_unbind(struct usb_composite_dev *dev)
>  {

--=20
balbi

--ZInfyf7laFu/Kiw7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUY3YpAAoJEIaOsuA1yqRE7kMQAIygOWJW2+y0/Vf5GZnMfODL
iiMHzM/nYXQeiHjtKBzBgk/Tb+37C9LyeGoqb7ACOnsW5QUoSoix5gkfvlkeGBIV
+vORCszfjEoZ+qfNNZFnz6zgxpb5fr9apDPDxg0gp9EmOwAubKLUz+Pj5vQ1kcWT
dCX2Tn3safRRfNBBO1YyRVWD1X8ufieEW+5I/I1M5tZUtLWa9+cVjzRtIP52v9Qp
mYg919nFxtpWAjfZb73Q2VmBo3q/FK2yc/LDqUJ4GxLKl1JCbcYdPCzUMoRFP3Fr
BP7xAf2E/e2WCNXST2jeX08VWsqRtDCJ5bdTFEnmiYzZUkX/uIyvauce7D8XyBRe
96NoKOVIKZjFzSinOtBKJhta15E9xo5DQTP9gveyH6oVoCaUABAk3vBIwz5372KQ
tpdUjo+cLuh+RyvQRqi6m4G0eFz1ZbA2g3CAjd/1E/V8kp+v+1AWF49htlna8K8b
OorlINM5OVNHKxxxWRE/kygneXLyTRvjNIGfWRl7iWDQo+fyEqj5AsG6lUN8phpC
bUY7b+Ctu8hwywiLtMphwJAC7fdWBKxZiz4gf6xWtQCbNOQYmegticNjh/6cSs5h
6vlRQygnAXhCFOAuBlJwfzsGr5+ALYcIgDtlJEUCsGeW3sD9fCKaO45xvc90DPk0
br6t/xXtKMJqw35xsPGz
=9U0m
-----END PGP SIGNATURE-----

--ZInfyf7laFu/Kiw7--
