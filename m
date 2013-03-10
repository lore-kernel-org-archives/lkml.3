Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab3CJRxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 13:53:18 -0400
Received: from scrye.com ([75.148.32.185]:60555 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab3CJRxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 13:53:17 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Mar 2013 13:53:17 EDT
Date: Sun, 10 Mar 2013 11:44:02 -0600
From: Kevin Fenzi <kevin@scrye.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ALSA: Conexant CX20585 (thinkpad t510) speaker powersave
 regression
Message-ID: <20130310114402.2953273c@jelerak.scrye.com>
In-Reply-To: <s5h7gnhjvtq.wl%tiwai@suse.de>
References: <20121222142324.73586307@jelerak.scrye.com>
	<s5hk3rnofv5.wl%tiwai@suse.de>
	<20130112114024.551d37b5@jelerak.scrye.com>
	<s5h7gnhjvtq.wl%tiwai@suse.de>
Organization: Scrye, INC
X-Mailer: Claws Mail 3.9.0cvs107 (GTK+ 2.24.17; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA512;
 boundary="Sig_/jq6pMcS6N6g.8yze7dtt9GV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jq6pMcS6N6g.8yze7dtt9GV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 13 Jan 2013 10:06:41 +0100
Takashi Iwai <tiwai@suse.de> wrote:

> At Sat, 12 Jan 2013 11:40:24 -0700,
> Kevin Fenzi wrote:
> >=20
> > On Tue, 08 Jan 2013 16:26:38 +0100
> > Takashi Iwai <tiwai@suse.de> wrote:
> >=20
> > > At Sat, 22 Dec 2012 14:23:24 -0700,
> > > Kevin Fenzi wrote:
> > > >=20
> > > > Greetings.=20
> > > >=20
> > > > I've got an issue with sound on my t510. It started in the late
> > > > 3.4.x kernels. Sound works on boot and for 5-10min after, then
> > > > the speakers stop working at all.=20
> > > >=20
> > > > I posted a while back on the alsa-users list, and someone else
> > > > had the same issue:=20
> > > >=20
> > > > http://www.mail-archive.com/alsa-user@lists.sourceforge.net/msg2876=
9.html
> > > >=20
> > > > It seems that the speakers(?) are getting moved to state D3 and
> > > > turning off. You can manually get it to come back for a few
> > > > minutes by using hda-verb to move it back to D0:=20
> > > >=20
> > > > hda-verb /dev/snd/hwC0D0 0x1f SET_POWER_STATE 0
> > > >=20
> > > > http://www.alsa-project.org/db/?f=3Dfd5ca157b2e76942df5ce2f0ae1a281=
7f3f08afd
> > > > is my alsa-info.=20
> > > >=20
> > > > I'd file a bug on the alsa bug tracker, but it still seems to be
> > > > down (for many months now?). No response on alsa-users, so now
> > > > that I have a bit of time, I am posting here in hopes someone
> > > > can look. ;)=20
> > > >=20
> > > > Happy to provide more info or try things.=20
> > >=20
> > > It's a known problem that some people have already reported, but
> > > currently no clue who actually turns down the pin to D3.
> > > Conexant guys wrote me that the codec doesn't do it by itself,
> > > and the driver neither, AFAIK.  A possible answer is the
> > > firmware / BIOS, but who knows.
> > >=20
> > > In anyway, could you try to trace the hd-audio events and see
> > > whether the power down is *not* issued by the driver when you see
> > > this state? See Documentation/sound/alsa/HD-Audio.txt, the
> > > section "Tracepoints" for a brief instruction.
> >=20
> > ok. I am not sure I am doing the right thing, but:=20
> >=20
> > - echo 1 > /sys/kernel/debug/tracing/events/hda/enable
> > - Run hda-verb to get sound working.=20
> > - Play a video to confirm.=20
> > - check /sys/kernel/debug/tracing/trace
> > - Wait a while.=20
> > - Play another sound that doesn't come out of speakers.=20
> > - check /sys/kernel/debug/tracing/trace for anything new.=20
> >=20
> > The only things I see in the trace file are my hda-verb call, and
> > the sounds playing. Nothing else.=20
> >=20
> > I then tried to duplicate it, but the trace file didn't seem to
> > update properly. Is there some reset needed?=20
> >=20
> > Or is this not the info you were looking for?
> >=20
> >         hda-verb-27187 [001] .... 78907.305149: hda_power_count:
> > [0:0] power_count=3D1, power_on=3D1, power_transition=3D0
> >         hda-verb-27187 [001] .... 78907.305152: hda_send_cmd: [0:0]
> >         val=3D1f70500
>=20
> Yes these are what I'd like to check.

Sorry for the long delay here... was the above info of any use?=20

> The point to check here is exactly which verbs have been sent, and how
> is the codec power status.  Check what is the last power_on value when
> the problem appears.  If it's power_on=3D1, it's fine.
> And you can concentrate on the verb to NID 0x1f, namely, hda_send_cmd
> with a value 1fxxxxx.  In the example above, 1f70500 means it's
> setting the power state of 0x1f to D0.
>=20
> Last but not least, you can try my very latest code in sound-unstable
> tree:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-unstable.git
>=20
> Either master or test/hda-migrate branch contains the latest code for
> Conexant codecs.

I'll note that the problem persists in 3.9.0-0.rc1

Please let me know if there's anything I can do to move this along or
try. ;(=20

kevin

--Sig_/jq6pMcS6N6g.8yze7dtt9GV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCgAGBQJRPMZlAAoJEEs3sNgP+7teg+kP/1ndrPBvjsTZcrOP6qtQQtW1
RbDTZVHPMfMkveeYX5quDDlk7kfMkkjmJlMGwqDLs0b804dpbf6HFOEkUEF8+VhN
jh30e/YeEO1EtEccE7my/WqeBoVlgg90vNHuhMQ1RiexGK78PqD4P0kLnAMxLqsw
7ywcd1CjpvATdmpbpI03A71aBKPH4JfFkoVNmJa0N5LoYMr0rBoE7AZoxmHWHaiW
ycqk+UX3J02PhYk3X0RwVfr7sDtHK2FQo3jMXNQWVHMP/p2Qz2g1Zqm0W6u9QkgC
6sOSq3WcbSLml7AFPmfcLH2FUuy1aj8X0OWvq4GywnZsnnEUU2MBP5VN249KBdbw
HeYqLFI7z3caDNQGR4PgSK8nUV0O7jE6A21MWKdy9cJpyK66QY2y6qu/BDpGXIPZ
/L3E3yD9J2ymqNuiXCF2xHZL1oT5UF1nOIdOicL7LvjVOkhNqy6GhpCPej7vwowu
r+BWJjny7GLL5KB3KmQAahi7+vT3E/gmQshJDqzz+7LbotUBGyswprMsfwW+1noD
VqcrzhVhxv/9IOwjas93PcQfIkqpmr7u/FZQTS5Cffq5sq4DxpnLGLLJkKCGNhso
x5nu6YnMZSt0eiLmDf/yEmi4TdyjiYv8RwjFkSTv6tvnzL/R9wkbzCcYXGG9532z
7nTWMBT7qY6EDImDoALP
=kk2Z
-----END PGP SIGNATURE-----

--Sig_/jq6pMcS6N6g.8yze7dtt9GV--
