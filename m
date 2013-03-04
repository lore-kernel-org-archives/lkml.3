Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3CDFOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 00:14:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33991 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740Ab3CDFOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 00:14:06 -0500
Message-ID: <1362374037.3768.298.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 093/153] ALSA: hda - hdmi: Make jacks phantom, if theyre not
 detectable
From: Ben Hutchings <ben@decadent.org.uk>
To: David Henningsson <david.henningsson@canonical.com>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Date: Mon, 04 Mar 2013 05:13:57 +0000
In-Reply-To: <20130304033716.795093499@decadent.org.uk>
References: <20130304033716.795093499@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3yAMCSeSCyWe+az68ft/"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3yAMCSeSCyWe+az68ft/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-03-04 at 03:38 +0000, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: David Henningsson <david.henningsson@canonical.com>
>=20
> commit 30efd8debd1ef30be342d374f01e993509f5b76b upstream.
>=20
> Just as for analog codecs, a jack that isn't suitable for detection
> (in this case, NO_PRESENCE was set) should be a phantom Jack
> instead of a normal one.
>=20
> Thanks to Raymond Yau for spotting.
>=20
> BugLink: https://bugs.launchpad.net/bugs/961286
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D903869
> Signed-off-by: David Henningsson <david.henningsson@canonical.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> [bwh: Backported to 3.2: adjust context]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

David, do I need to change this further for 3.2.y?

Ben.

> ---
>  sound/pci/hda/patch_hdmi.c |    3 +++
>  1 file changed, 3 insertions(+)
>=20
> --- a/sound/pci/hda/patch_hdmi.c
> +++ b/sound/pci/hda/patch_hdmi.c
> @@ -1228,6 +1228,9 @@ static int generic_hdmi_build_jack(struc
>  	int pcmdev =3D spec->pcm_rec[pin_idx].device;
> =20
>  	snprintf(hdmi_str, sizeof(hdmi_str), "HDMI/DP,pcm=3D%d", pcmdev);
> +	if (!is_jack_detectable(codec, per_pin->pin_nid))
> +		strncat(hdmi_str, " Phantom",
> +			sizeof(hdmi_str) - strlen(hdmi_str) - 1);
> =20
>  	err =3D snd_hda_input_jack_add(codec, per_pin->pin_nid,
>  			     SND_JACK_VIDEOOUT, pcmdev > 0 ? hdmi_str : NULL);
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-3yAMCSeSCyWe+az68ft/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTQtlee/yOyVhhEJAQphwhAAgYRAjGYF2EHU0bdVxkdU+Fa8Q9sQrNI5
4Rm6VREb8y69qy7e0tDK5EjZ/FlZZgBQpIXgY5hH5qMndOUVw5vo+eAwgtieAHnt
kIAq5wNzB9BmdiYumtjRLTXEBoKjdMVpmpRLlvYLRpm/0mguQTJG8kByqVXhISAo
/YrG4F2+rCcweEORBJB4i7KJn1fA+ygvKXsD1R5Njcpid5bJNximjy/ELGXFn/A+
jk71f6tN4bdRhgb8D1UFLKXLNW5IJJqJmoHuW5UOiP4fX9UcZAR0/RTTqxGITbJk
4//lKuKr2T7SGLrhA6u6YMOeGB9GM8WCcU8vSWP4bSW1xHh/ipm0FrGPAnphzmBr
jv27xG5ao0A5WkZnDzPnbQTHDudInkEWZtKRGWIsptQLOT+DK1ZZAIErERnuCK2o
cxkEETm3uR1FpHpxZD9fnC59fps03QsnquvDfrm8EMJftkH/Dzu0WpKu1TVu5cfu
WGOpU+fe4Zn5zu8c/kggb2JiqEjWJW8kfw8jlt+2ueo7ljah/CUVnlmezvTpnMOe
H315GOlQr0zgavCCM6NblniUCx8jr/ewAmKmy1d63M7nVmFBCZ3LnneAmTW1ycL+
lRRjK9v/w7EK8MWVI7Wc3T7fRwWGFVVyl+8ue5PRHnm6POZyS0/GCELz/+QdzXav
FAvBr1YQ2oU=
=4Gnl
-----END PGP SIGNATURE-----

--=-3yAMCSeSCyWe+az68ft/--
