Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab3FGHw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:52:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34869 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3FGHw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:52:56 -0400
Date: Fri, 7 Jun 2013 17:52:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Peng Tao <bergwolf@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>,
        Greg KH <greg@kroah.com>, "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20130607175244.95368825087acdfb25a2a8eb@canb.auug.org.au>
In-Reply-To: <CA+a=Yy7BOcCXjZnbiZArWf=JCeSyp7k=J4DaBhQYQjy2ASgGkw@mail.gmail.com>
References: <20130607162830.9d7ce277a9eda2b54fe73e92@canb.auug.org.au>
	<CA+a=Yy7BOcCXjZnbiZArWf=JCeSyp7k=J4DaBhQYQjy2ASgGkw@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Jun_2013_17_52_44_+1000_qz6_+kuZeigcY__."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Jun_2013_17_52_44_+1000_qz6_+kuZeigcY__.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 7 Jun 2013 15:26:56 +0800 Peng Tao <bergwolf@gmail.com> wrote:
>
> On Fri, Jun 7, 2013 at 2:28 PM, Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> >
> > After merging the akpm tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >
> > In file included from drivers/staging/lustre/include/linux/libcfs/linux=
/libcfs.h:49:0,
> >                  from drivers/staging/lustre/include/linux/libcfs/libcf=
s.h:44,
> >                  from drivers/staging/lustre/include/linux/lnet/linux/l=
ib-lnet.h:45,
> >                  from drivers/staging/lustre/include/linux/lnet/lib-lne=
t.h:44,
> >                  from drivers/staging/lustre/lnet/lnet/api-ni.c:38:
> > drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h: In funct=
ion 'set_shrinker':
> > drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h:102:3: er=
ror: 'struct shrinker' has no member named 'shrink'
> >   s->shrink =3D func;
> >    ^
> >
> > Caused by commit a37f14f05f2f ("shrinker: Kill old ->shrink API") from
> > the akpm tree interacting with the new Lustre client code from the
> > staging tree.
> >
> > I have just disabled the Lustre client code again (by reverting commit
> > ee04fd11f11f ("Revert "Revert "staging/lustre: drop CONFIG_BROKEN
> > dependency""")) and maybe someone can tell me what I need to do to fix
> > this when I get back in a week.
> I have a patchset to fix this but haven't yet sent out because it will
> break build in Greg's staging tree. I can send it now but please tell
> me to whom I should send the patches? Greg's tree doesn't contain
> shrinker change, and mm- tree doesn't have Lustre code.

The mm- tree now has the lustre code since it it based on most of
linux-next, so send them to Andrew.

It will then be up to Andrew and Greg to make sure that the staging tree
is merged into Linus' tree before Andrew's patch bomb.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__7_Jun_2013_17_52_44_+1000_qz6_+kuZeigcY__.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRsZFRAAoJEECxmPOUX5FER+8P/3EF8T8BEJbqAvRdPPWLNdum
Szv4RsWXfX74nx4LI+TcFYgsFv2+YCzQ7qhypNlh3kGLx3kU9MIQybb2/1SC76bh
ckchXtW4x3+GUtmNTE3ZUN7Wvi9DSLXnbEB/W0AfzYtX1uea5zAhnLXC47e12Cbb
URje21Xt+HzgMtSzo8TJcNiYx/E8lWh/E/ws0ejrAGq426xz8pZZlH88QRUzlE5W
OIh+AugivuCLnSYA7Rs2aSQBYFm9NSZWr0vvBjc1B7YabxUDKxA+v+SviTpvHiAl
aoRqifKZ1iyOrnMS28l4zXwX4RL1sTIiYvq/YteYqnRxFynDNSLbAMGxfxxnwuvf
2VT2Yzmw6XFGK+Z5DVAy/71fpJfu7ujgCpdddDD75dcuw4dUmrDMOxO/em5XbALV
v0AuCsJE3yqwSc3A6HMLrg/00a5JyHCAM7Lw91BmB8dmNSwmdNgfEzU1SvKw8fOV
KNMPXygQUWJRrEm3UAZIn13RYcbfo003FOkpA+wGH8RWAv6zzETKaJ4hQCmqSZ0t
KwSI/HUQODzIi8LlsODVP3UjUvxJLIxZJeAHx5eZnuOR8ykOCB4zXMwAi8cDbD3V
SCeNbESbKVd6fhITOYnQX7dWs3urkidcO/u3pNCp5FcNa1hG2zgTY/XmK/z75uWN
JxIXtaCHzkovFi5HUXAd
=Zs1/
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Jun_2013_17_52_44_+1000_qz6_+kuZeigcY__.--
