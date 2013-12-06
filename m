Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161070Ab3LFPDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:03:48 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46651 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab3LFPDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:03:45 -0500
Date: Fri, 6 Dec 2013 15:03:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <b42378@freescale.com>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org, tiwai@suse.de,
        perex@perex.cz, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org, rob@landley.net,
        ijc+devicetree@hellion.org.uk, swarren@wwwdotorg.org,
        mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com
Message-ID: <20131206150319.GJ29268@sirena.org.uk>
References: <cover.1386322845.git.b42378@freescale.com>
 <82d3285b7efe1f98dbc3d9c0a423b2e5e454481f.1386322845.git.b42378@freescale.com>
 <20131206144256.GI29268@sirena.org.uk>
 <20131206143817.GB29975@MrMyself>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K5rlT6r/WqkiQKGB"
Content-Disposition: inline
In-Reply-To: <20131206143817.GB29975@MrMyself>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] ASoC: fsl: imx-wm8962: Add headphone and microphone
 jack plugin/out detection
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K5rlT6r/WqkiQKGB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2013 at 10:38:17PM +0800, Nicolin Chen wrote:
> On Fri, Dec 06, 2013 at 02:42:56PM +0000, Mark Brown wrote:

> > What's this uevent trying to do and why is it open coded in the driver?

> That's a requirement from Android team of Freescale. By checking this
> event they can determine whether current output is speaker or headphone
> so as to place an icon on the notification area.

> Sir, if you think this patch is not common enough or non-community style,
> I can try to cut it down to an common one or entirely drop it.

This isn't mainline stuff, this is the Android standard switch class.
Someone should really contribute something to Android which backs it
onto the back of ALSA jacks.  The mainline equivalent is extcon which
does have switch class emulation but it's a bit broken in its generation
of uevents and is also not yet integrated into the ALSA jack stuff.

The thing to do is ideally integrate extcon with the ALSA jack code and
update the Android headset observer to work with extcon (or write a
separate extcon based observer).

--K5rlT6r/WqkiQKGB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSoec0AAoJELSic+t+oim9lXwQAIc4J1A6M0xtioHHgwOpDu+8
RIbwa8OYaRHSIS1yz5iRrEafBDMDgXee7eLk59yg0bY4l6zu2Q/x03WTc8nVtPYT
2iA3TYtqCBI6X5QRoYH43MzJ6neTM3oE+OBwO+gIw8qUZ9EYGIWVwyH1Y5Xnzc4F
y7mkXvbhnfZK+fH9ZAnagh39PT2Ocv1mS5tMHH01QUdTBWus/6Jz5ijT4GT8RIHy
DfnNGIpN4IhrV2oIthG950w7YcLuQ+6ovTlMuFUj0BQvF4CRF1ZqrknBr3YCPsYE
uTDQgAwUbanZ5hb/xBSCRizmPkLvzwfpUswzZyHM5Ce399XGNR9M//7072GQaAgT
+eHA4d2cotyxT8h3c4CCGmZIpdK5yjDtpmZbAjmwPsjMjnPXlmmIfhBX5T69B0tS
OsaxUVdVa+7qKTPry55t+GUjVQIyMztt8Oynnepxtao9jvmqYDJ7YMI2U1DYRp72
QNUws19qb9bpqyrFQjadX0TuylbIR9LW6/UBB1apD9tSuP+/sFOC6+s6ZQtFAa/g
NpkWQJ7czWTL40KPP/9/6psul937FWfX2Yu68jGEPeR3JKTSh8XaJxIn/EnitLjd
2FPr5TZpkvGW3wRLz+dXN1DVdmNNz5nhMoK+hFc7Ce005WWGGh9Zh+ALeK2svTpD
qUDwB1WUW3AxDr29UOqP
=37DF
-----END PGP SIGNATURE-----

--K5rlT6r/WqkiQKGB--
