Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3HLKzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:55:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41439 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab3HLKzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:55:12 -0400
Date: Mon, 12 Aug 2013 11:54:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Felipe Tonello <eu@felipetonello.com>, alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz>, linux-kernel@vger.kernel.org
Message-ID: <20130812105447.GQ6427@sirena.org.uk>
References: <1375430365-13232-2-git-send-email-eu@felipetonello.com>
 <1376029315-3217-1-git-send-email-eu@felipetonello.com>
 <s5h38qj2cqj.wl%tiwai@suse.de>
 <CAGrhNMxj++uJ5HnhhcfOOxhu9u77WMBRP+H5ar5wATi=kHJYKg@mail.gmail.com>
 <s5hli47yz01.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8lV4/+ewWCwXF+0e"
Content-Disposition: inline
In-Reply-To: <s5hli47yz01.wl%tiwai@suse.de>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/2] ALSA: Added jack detection KControl support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8lV4/+ewWCwXF+0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 12, 2013 at 12:39:10PM +0200, Takashi Iwai wrote:

> But, don't get me wrong: I'm not against the action itself, the
> removal of input jack support in HD-audio.  I myself did propose this
> once ago.  Again,  what's missing in your approach is the proper
> process.

> - Think whether removal of input-jack support is really needed for
>   HD-audio;
>   for example, if you integrate snd_jack stuff to support both
>   input-jack and kctl jack, HD-audio driver can use it solely instead
>   of calling snd_kctl stuff.  Then both input and kctl jacks will be
>   supported automagically.

I think this is the best approach - just get everything using jack.c for
all types of jack and deal with things there.  We've also got extcon
based reporting to consider, having a single place where all the
userspace interfaces are implemented will mean we can just add that.

This is why I put everything in jack.c in the first place :(

--8lV4/+ewWCwXF+0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCL7zAAoJELSic+t+oim9qd4P/i8PFAPVUQe4sOWqndyUjCUg
hc0Nt/cS3bLmlx2Nf+y5BC/ejqelZ+8KL0pNcG3mOVselB3DYD/lEnL6Egie3dWV
Q1CaSsX73rEGZrkJGrEJKeck5eF5GTHzGUmWEhiL6LIVaj0gTKO1U467kiO6nXTw
7nP5Q0AbKceg3sehzZaL10yg0Woia2F6kzVQeN29moPjpNIsS64xO9FE53Hdxser
WrbRBIm8NPXpVLi8AdkUXV5bpV1YVsAFmGjwYufEp5edzuMwb5qjqlHZqK59OUM+
P72ogtArBwefaCeiSOe6na5mvO1eo8e0jDST63PVHrpIjuaIYmrHgdUbmNvoqAuK
G2se41+C/TTDn8mmp2FsPWkKHDLwJArZ6FnmYM03eo3NH5fLnPU+fIJH9Lwm6QLE
JAdA0m4hg3RnKRS0J2sGtGpjkQrIWbTE6s6cAcn4GZNNUantb7ku+Nn7kcP4IRMb
Ijh/nH1HJ7gOpdINrTsukvNl7UG6YVzUjAAh862llb7bwyxAIcoWw8bOkJqNvt9d
Px4Jgt0C9pZ5vHk4aJr0UeEdf2cVGoNnhKbn/Pbed3GPI2slcuBcJMJ2glL/geYq
ND/n9rs+dz9+s/NCCSsuBY3+RfIUXXU2aGWxTcOU8fwIAB/otV2Qa0JEW8UtTf5g
PeUiFzTOJ0E5sW3wXKzM
=cep3
-----END PGP SIGNATURE-----

--8lV4/+ewWCwXF+0e--
