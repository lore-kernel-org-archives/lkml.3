Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3JYUoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 16:44:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab3JYUoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 16:44:08 -0400
Date: Sat, 26 Oct 2013 07:43:49 +1100
From: NeilBrown <neilb@suse.de>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, linux-mm@kvack.org
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131026074349.0adc9646@notabene.brown>
In-Reply-To: <154617470.12445.1382725583671.JavaMail.mail@webmail11>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
	<20131025214952.3eb41201@notabene.brown>
	<alpine.DEB.2.02.1310250425270.22538@nftneq.ynat.uz>
	<154617470.12445.1382725583671.JavaMail.mail@webmail11>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ruxvo/UHlXxrQJ/hv4uQd02"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ruxvo/UHlXxrQJ/hv4uQd02
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Oct 2013 18:26:23 +0000 (UTC) "Artem S. Tashkinov"
<t.artem@lycos.com> wrote:

> Oct 25, 2013 05:26:45 PM, david wrote:
> On Fri, 25 Oct 2013, NeilBrown wrote:
> >
> >>
> >> What exactly is bothering you about this?  The amount of memory used o=
r the
> >> time until data is flushed?
> >
> >actually, I think the problem is more the impact of the huge write later=
 on.
>=20
> Exactly. And not being able to use applications which show you IO perform=
ance
> like Midnight Commander. You might prefer to use "cp -a" but I cannot ima=
gine
> my life without being able to see the progress of a copying operation. Wi=
th the current
> dirty cache there's no way to understand how you storage media actually b=
ehaves.

So fix Midnight Commander.  If you want the copy to be actually finished wh=
en
it says  it is finished, then it needs to call 'fsync()' at the end.

>=20
> Hopefully this issue won't dissolve into obscurity and someone will actua=
lly make
> up a plan (and a patch) how to make dirty write cache behave in a sane ma=
nner
> considering the fact that there are devices with very different write spe=
eds and
> requirements. It'd be ever better, if I could specify dirty cache as a mo=
unt option
> (though sane defaults or semi-automatic values based on runtime estimates
> won't hurt).
>=20
> Per device dirty cache seems like a nice idea, I, for one, would like to =
disable it
> altogether or make it an absolute minimum for things like USB flash drive=
s - because
> I don't care about multithreaded performance or delayed allocation on suc=
h devices -
> I'm interested in my data reaching my USB stick ASAP - because it's how m=
ost people
> use them.
>

As has already been said, you can substantially disable  the cache by tuning
down various values in /proc/sys/vm/.
Have you tried?

NeilBrown

--Sig_/Ruxvo/UHlXxrQJ/hv4uQd02
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmrYBTnsnt1WYoG5AQLuSA/7BMZQHQ0T9U0PVyggS9AeboIxLXlnMjIp
IXNLZLqvfuSpAwTeSvrc58DCxQsoggkQYIbSrHy3j1mwFAhHFq2z/Q1JvdkLfuA7
FhXJYI3F05L09+/KxOoStIBkD2MqBYlZYSbWu2UZOzzZIlKOrtb8wTXVt7IrU2oq
+KzvuttIaF1/3QEQL3SocPhUuJGS9Ym1yxlnLaiDPNEgoa61tg5VOAFyJQP+dybT
3UDvSunL3vFZhrg8oDqcauiQl7DO+hnLw0jew93DBun1svFPaOtjSNc/vWnoXST7
PnYsMsHC/NBQGGdNe6BG4paShoUNR6Z7rXxrQf/HLmcMAiy+7On1/HIe2Qcfju3k
T5hoIqSLvG9bHXQxOR8XnMG3P8rNzQ9I9R/5sHFGZJeNuFjBpxk3CxSzTtbjoGPN
P+PFyXs/n9L5QvjEKsKFk+PT8DYYiY0U9+rklP7verpqOa3mVgvsVQuVLlEyL51T
BXBOrRXJedOLUzUE6fxNS/QeZ6CF/dner1qlf/G6aEEJLmqs//qVS1IxnB6UiZKJ
NNjXaRY64idodWP8pOSG41WFP2WSvFXymJ+s6qF6gaJEtiQNeHeukF38h2X2qn7A
EsyG/NXH6XOt3vP+nQkhrNAe4iZqKIOV29FANIJy11nUHEB0nsE3qH9GYcHl5ZD4
AxPLr+BkgaE=
=ZScs
-----END PGP SIGNATURE-----

--Sig_/Ruxvo/UHlXxrQJ/hv4uQd02--
