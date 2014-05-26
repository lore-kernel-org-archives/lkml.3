Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaEZXAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 19:00:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:54697 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbaEZXAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 19:00:06 -0400
Date: Tue, 27 May 2014 01:00:01 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
Message-ID: <20140526230001.GB32691@earth.universe>
References: <20140516105814.3EA3FC403C2@trevor.secretlab.ca>
 <CAMuHMdWw39n8O0fFWECR6v6GaEJ3aB5S3ront4eDdXwxNO6Fgw@mail.gmail.com>
 <20140520055026.E3A98C412DA@trevor.secretlab.ca>
 <CAMuHMdXjWENrq0MW-DU2x7WnaCsWyipN4DO=y0ZTL+3G_fPYGg@mail.gmail.com>
 <20140526104824.63F13C42129@trevor.secretlab.ca>
 <CAMuHMdUGdjVKBR5rRzZ274rf7p8XfztNRWEojH1RrZV8c_V1uA@mail.gmail.com>
 <20140526112348.907B7C421A5@trevor.secretlab.ca>
 <A6195DFD-0447-4444-AC09-501C43F09924@konsulko.com>
 <20140526150942.GA26787@earth.universe>
 <53835A40.8050902@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
In-Reply-To: <53835A40.8050902@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 26, 2014 at 08:14:08AM -0700, Guenter Roeck wrote:
> On 05/26/2014 08:09 AM, Sebastian Reichel wrote:
> >On Mon, May 26, 2014 at 02:55:37PM +0300, Pantelis Antoniou wrote:
> >>On May 26, 2014, at 2:23 PM, Grant Likely wrote:
> >>>On Mon, 26 May 2014 12:57:32 +0200, Geert Uytterhoeven <geert@linux-m6=
8k.org> wrote:
> >>>Heeheehee. We're back where we started. The original question is wheth=
er
> >>>or not that is a valid approach. If the overlay represents something
> >>>that can be hot plugged/unplugged, then passing it through to the seco=
nd
> >>>kernel would be the wrong thing to do. If it was a permenant addition,
> >>>then it probably doesn't need to be removed.
> >>>
> >>>We do actually keep the overlay info in memory for the purpose of
> >>>removal exactly so we can support hot unbinding of devices and drivers
> >>>that make use of overlays.
> >>
> >>We can support either method. I am not feeling any wiser about which on=
e should be
> >>the default TBH, so what about exporting a property and let the platform
> >>figure out which is more appropriate?
> >
> >What about supporting "negative" overlays (so an overlay, that
> >removes DT entries)? That way one could reverse apply an overlay.
> >All the dependency stuff would basically be the users problem.  The
> >kernel only checks if it can apply an overlay (and return some error
> >code if it can't). This this code is needed anyway to check the
> >input from userspace.
> >
>=20
> Does that mean that I would need to describe such a negative overlay
> for each overlay to be able to get it removed ?
>=20
> This would introduce an endless source of problems with bad "reverse"
> overlay descriptions. Sure, that would "be the users problem",
> but I don't think that would make it better.

I was thinking about supporting something like "patch --reverse". So
you can try to undo the overlay by reverse applying it and you can
do it in arbitrary order.

Note: The dependency check must be done for all overlays coming from
userspace, so that's not a problem __here__. The reverse method can
"simply" reverse the overlay patch and apply it like a normal
overlay from userspace (and thus using the same dependency checks).

-- Sebastian

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTg8dxAAoJENju1/PIO/qa3AgP/AwzZA2jxOwDsse7y+S/6e16
M6DRqqVgt+qa/eZgmICWStgfrSiuOnDs5zZmqdpQlh8XVbx0Gop74nVHV8qz3rwR
npgk316RXv+lF34NRgqIDlYwsFzJoL7sUoyqDnA39dmC89Ac4OWGir5drVRHAM98
Gsi8hdCF8yheVq6xm8ZBIch2/sa8Hw8IV0IitA64LXZXR1JgwqW+qN9LkrJX+2Jp
7EUjgwyLzmJotLNfrTvlH9GZpai0nv7LxDDUv/seYz8eSbZS3iv0DVdeaV7c2y2B
8gHIhfA1GgKUIGm3gvhkMjVD1/hbxB6VCDUdo3P2Ffh8ovIYiR6w6gOvCNZfZeVo
za/u/GnVAuKkwC3yKfhLWj6NrBKLHhfA71s9wt70yl6m5oJ1GGfk5J0jrX+q+xVf
OYWuTgcOMWLH+Igvioe5gGouyPCJUlTd8gB+yYTFMBUWQ6AOZ6/GTc9fcArFg8kC
B3tIr6250BDg5M0Fo3w5KD3FkBTBdSTnlu+sAGdi8yPTaPO7e5ckFx0NCWHE4bqL
BUzYS7VCmfacwOADiwfEKXhDN0LqKs4ZFNGmxfBvVtev1G1B+zYBhDkzre/IDegC
0LKPI6f/oDo+QzhWtW7XbQfO5KHDXlpPiDW8ntROsEQ+marwLDjyELTPqzLMD3bE
dLdVGR6qAMc4gH5qMdkE
=ywFj
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--
