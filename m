Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3H1NQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:16:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47147 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3H1NQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:16:43 -0400
Date: Wed, 28 Aug 2013 15:16:09 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Terje Bergstrom <tbergstrom@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] host1x: hdmi: Detect whether display is connected
 with HDMI or DVI
Message-ID: <20130828131608.GA604@ulmo>
References: <1377686459-16634-1-git-send-email-mperttunen@nvidia.com>
 <1377686459-16634-3-git-send-email-mperttunen@nvidia.com>
 <20130828120727.GA32254@ulmo>
 <521DEE6D.4050503@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <521DEE6D.4050503@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2013 at 03:34:53PM +0300, Mikko Perttunen wrote:
> On 08/28/2013 03:07 PM, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Wed, Aug 28, 2013 at 01:40:56PM +0300, Mikko Perttunen wrote:
> >>Use EDID data to determine whether the display supports HDMI or just DV=
I.
> >>This used to be hardcoded to be HDMI, which broke support for DVI displ=
ays
> >>that couldn't understand the interspersed audio/other data.
> >>
> >>If the EDID data isn't available, default to DVI, which should be a saf=
er
> >>choice.
> >>
> >>Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> >>---
> >>  drivers/gpu/host1x/drm/hdmi.c | 8 ++++++++
> >>  1 file changed, 8 insertions(+)
> >>
> >>diff --git a/drivers/gpu/host1x/drm/hdmi.c b/drivers/gpu/host1x/drm/hdm=
i.c
> >>index d81fac8..140339b 100644
> >>--- a/drivers/gpu/host1x/drm/hdmi.c
> >>+++ b/drivers/gpu/host1x/drm/hdmi.c
> >>@@ -702,6 +702,14 @@ static int tegra_output_hdmi_enable(struct tegra_o=
utput *output)
> >>  	unsigned long value;
> >>  	int retries =3D 1000;
> >>  	int err;
> >>+	struct drm_property_blob *edid_blob =3D output->connector.edid_blob_p=
tr;
> >>+
> >>+	if (edid_blob && edid_blob->data &&
> >>+		drm_detect_hdmi_monitor((struct edid *)edid_blob->data)) {
> >>+		hdmi->dvi =3D false;
> >>+	} else {
> >>+		hdmi->dvi =3D true;
> >>+	}
> >>
> >>  	pclk =3D mode->clock * 1000;
> >>  	h_sync_width =3D mode->hsync_end - mode->hsync_start;
> >
> >Odd, now that I see that code I remember that there was a similar patch
> >a few months back, but it was never applied for some reason:
> >
> >	http://lists.freedesktop.org/archives/dri-devel/2013-January/033509.html
> >
> >That was already reviewed by me and Jon Mayo, so I'll go ahead and apply
> >that one instead.
> >
> >Thierry
> >
> >* Unknown Key
> >* 0x7F3EB3A1
> >
>=20
> That patch seems to cause a warning for me:
> drivers/gpu/host1x/drm/hdmi.c: In function =E2=80=98tegra_output_hdmi_ena=
ble=E2=80=99:
> drivers/gpu/host1x/drm/hdmi.c:706:2: warning: passing argument 1 of
> =E2=80=98drm_detect_hdmi_monitor=E2=80=99 discards =E2=80=98const=E2=80=
=99 qualifier from pointer
> target type [enabled by default]
> include/drm/drm_crtc.h:1037:13: note: expected =E2=80=98struct edid *=E2=
=80=99 but
> argument is of type =E2=80=98const struct edid *=E2=80=99

Given the discussion about this back in January, I think the best way,
at least for now, is to keep a copy of the EDID data so that it can
actually be modified.

But looking at the problem more closely, I don't think the patch from
January is quite correct. The problem is that it uses the EDID stored
within the struct tegra_output. That's problematic because that field
is not updated when EDID is probed via DDC. That would make the patch
that you proposed more correct.

Thierry

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSHfgYAAoJEN0jrNd/PrOhLoAP/ROg98PTWP/OoDyWRRLelWVx
LZfc3BYBQwLLn4Y7/bwbWUBacGdJ28pwMOuF7rc7Se3SkfcqiZCXBcbhoxv0oZ4y
seT9NxQynIh5CzrEL9SyqqlaP5ZeidbHVfHOoJQfXKTQN1cSQTmf957RaO7ueMwH
Osl3O11LAt9HUhQRYn5pClxLrhO3Jhbr6LpEc3hp19IImrV5h4YnDr4OpCclMwGz
ple9/MtL/Uyco4YEyriv8ABzZqHdtUheVyxNhuBZO74/LZ5GWHSfIrfFjxxeaIXg
/RBxwj88izUREY1GCxyK+VCzX7WSZZGeMNrERqIiMk/x314Tfre2rvjOZ7788S3y
93R7ePghv4Pw2GU1TbHjlwmwpBIaySUSbUen1v2EioD4J18fPatiaAXVz6YlWHdj
fWhG2IC+dDatg0wje6XaiA5vRc6RNpgAC/fqGbBfiXLNs4LmXT9n/jCfjfuI+3PJ
9yAkrnNFIUBs8tIFVE34UmhRkpMcLLOlDz5TZ+uVMVx+TRMW5vDx6/7ixFQ58k8X
Pv69D/lxPq6yVSIbT7+RI+AjFpyAo5QyCK/V1CQCp5xSnVHpTBSW/GUOTybcuk5c
KXAUy08lGn3hexL3V603HTFZrbei5MvgIfShP4IlYKCfvcD/jE05dnP5OTH1R+0p
EXVafjW78C0n/G0eVSCg
=4f73
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
