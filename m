Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3ALSkc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 13:40:32 -0500
Received: from 75-148-32-185-Colorado.hfc.comcastbusiness.net ([75.148.32.185]:45729
	"EHLO mail.scrye.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab3ALSkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 13:40:31 -0500
Date: Sat, 12 Jan 2013 11:40:24 -0700
From: Kevin Fenzi <kevin@scrye.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ALSA: Conexant CX20585 (thinkpad t510) speaker powersave
 regression
Message-ID: <20130112114024.551d37b5@jelerak.scrye.com>
In-Reply-To: <s5hk3rnofv5.wl%tiwai@suse.de>
References: <20121222142324.73586307@jelerak.scrye.com>
	<s5hk3rnofv5.wl%tiwai@suse.de>
Organization: Scrye, INC
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bRRHUFpDvg3_R6NF49KumbS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bRRHUFpDvg3_R6NF49KumbS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 08 Jan 2013 16:26:38 +0100
Takashi Iwai <tiwai@suse.de> wrote:

> At Sat, 22 Dec 2012 14:23:24 -0700,
> Kevin Fenzi wrote:
> >=20
> > Greetings.=20
> >=20
> > I've got an issue with sound on my t510. It started in the late
> > 3.4.x kernels. Sound works on boot and for 5-10min after, then the
> > speakers stop working at all.=20
> >=20
> > I posted a while back on the alsa-users list, and someone else had
> > the same issue:=20
> >=20
> > http://www.mail-archive.com/alsa-user@lists.sourceforge.net/msg28769.ht=
ml
> >=20
> > It seems that the speakers(?) are getting moved to state D3 and
> > turning off. You can manually get it to come back for a few minutes
> > by using hda-verb to move it back to D0:=20
> >=20
> > hda-verb /dev/snd/hwC0D0 0x1f SET_POWER_STATE 0
> >=20
> > http://www.alsa-project.org/db/?f=3Dfd5ca157b2e76942df5ce2f0ae1a2817f3f=
08afd
> > is my alsa-info.=20
> >=20
> > I'd file a bug on the alsa bug tracker, but it still seems to be
> > down (for many months now?). No response on alsa-users, so now that
> > I have a bit of time, I am posting here in hopes someone can
> > look. ;)=20
> >=20
> > Happy to provide more info or try things.=20
>=20
> It's a known problem that some people have already reported, but
> currently no clue who actually turns down the pin to D3.
> Conexant guys wrote me that the codec doesn't do it by itself, and the
> driver neither, AFAIK.  A possible answer is the firmware / BIOS, but
> who knows.
>=20
> In anyway, could you try to trace the hd-audio events and see whether
> the power down is *not* issued by the driver when you see this state?
> See Documentation/sound/alsa/HD-Audio.txt, the section "Tracepoints"
> for a brief instruction.

ok. I am not sure I am doing the right thing, but:=20

- echo 1 > /sys/kernel/debug/tracing/events/hda/enable
- Run hda-verb to get sound working.=20
- Play a video to confirm.=20
- check /sys/kernel/debug/tracing/trace
- Wait a while.=20
- Play another sound that doesn't come out of speakers.=20
- check /sys/kernel/debug/tracing/trace for anything new.=20

The only things I see in the trace file are my hda-verb call, and the
sounds playing. Nothing else.=20

I then tried to duplicate it, but the trace file didn't seem to update
properly. Is there some reset needed?=20

Or is this not the info you were looking for?

        hda-verb-27187 [001] .... 78907.305149: hda_power_count: [0:0]
        power_count=3D1, power_on=3D1, power_transition=3D0
        hda-verb-27187 [001] .... 78907.305152: hda_send_cmd: [0:0]
        val=3D1f70500
        hda-verb-27187 [001] .... 78907.305214: hda_get_response: [0:0]
        val=3D0
        hda-verb-27187 [001] .... 78907.305214: hda_power_count: [0:0]
        power_count=3D0, power_on=3D1, power_transition=3D0
       alsa-sink-17958 [000] .... 78933.682478: hda_power_count: [0:0]
        power_count=3D1, power_on=3D1, power_transition=3D0
       alsa-sink-17958 [000] .... 78933.683330: hda_power_count: [0:0]
        power_count=3D2, power_on=3D1, power_transition=3D0
       alsa-sink-17958 [000] .... 78933.683335: hda_power_count: [0:0]
        power_count=3D3, power_on=3D1, power_transition=3D0
       alsa-sink-17958 [000] .... 78933.683336: hda_send_cmd: [0:0]
        val=3D103a047
       alsa-sink-17958 [000] .... 78933.683378: hda_get_response: [0:0]
        val=3D0
       alsa-sink-17958 [000] .... 78933.683379: hda_power_count: [0:0]
        power_count=3D2, power_on=3D1, power_transition=3D0
       alsa-sink-17958 [000] .... 78933.683380: hda_power_count: [0:0]
       power_count=3D3, power_on=3D1, power_transition=3D0
...

kevin

--Sig_/bRRHUFpDvg3_R6NF49KumbS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ8a4aAAoJEEs3sNgP+7teBssP/1e2QPtrEIXKUYThOqqQESHo
pXB5eosSlkTX1n7K59XZWf/MXFceRxe0Mk4aHOaDyuGzGIioRRcRrbSR8o094W2f
XkCSXQIu92/FlePw0M2dRwuKGn6heIu9gyGUp6cHYhatfvHfpZIpqiFmsqN0Rhjd
ae6L05Lsau4dsSLCoQHsl33+BRXSh8/45qCTi8Zqeg67u36JJAoVQ7IdwNWueibY
p4MbxntCuDvvCFYCXo+cjCZ81xkwDKYqDQvbh6PgspHbQsSAIi8de3oJDjBBZ5WA
+xYXYyERSxAKQQVdFN/nGb0/mdb1uEUade/uMCuA7UU/LKBDgR6S0sKEIx+6l7Uv
SggDjj4lGZVlrLkoP+9EQxDuxTrB/PsTxp01LTHXUQH40tzWlsGix65m+Ip6ujrN
6n5ypWpE/kfSaVIhEEFF2ZQo8FO/5cF+/LXQR1TClRWb8oJpUyjGf/g9qzLfsCV8
ar6D1Pb5PNahZmziM1anjxxj5vXjK2uor/W0Xt+Mr0I2le9eJpL068l9AyY5S8WP
zX6xEzBMcxX9IwVf9MCHF2SpXT1f1uqUlRU4nfJO94j+xYq+RjZ+GgtJBVx3LkfC
mJxt/TG35mZRGxanJR6npL2oqGqAyXwpsa5xLCWfBWUdPoJDhdDYZ6xd9JfnKXnm
JLKfIgn82uhAM83PQm38
=ahCn
-----END PGP SIGNATURE-----

--Sig_/bRRHUFpDvg3_R6NF49KumbS--
