Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab3GQBsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 21:48:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab3GQBsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 21:48:51 -0400
Date: Wed, 17 Jul 2013 11:48:39 +1000
From: NeilBrown <neilb@suse.de>
To: CoolCold <coolthecold@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
        Linux kernel <linux-kernel@vger.kernel.org>,
        Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: 3.10: discard/trim support on md-raid1?
Message-ID: <20130717114839.4a67b142@notabene.brown>
In-Reply-To: <CAGqmV7qf14zrsimCMRsVWobq8SpLaavxPQvEyU6N=f1nBgvFHQ@mail.gmail.com>
References: <001701ce7fb4$889bdd40$99d397c0$@lucidpixels.com>
	<20130716171527.7c6cb722@notabene.brown>
	<CAGqmV7qf14zrsimCMRsVWobq8SpLaavxPQvEyU6N=f1nBgvFHQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/omkt2qr2rdYJGFRv+E_twTQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/omkt2qr2rdYJGFRv+E_twTQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Jul 2013 00:44:15 +0400 CoolCold <coolthecold@gmail.com> wrote:

> Neil, I've tryed to look around commit logs but failed to find commit
> where discard/trim were added.
> I was looking via
> http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/log/d=
rivers/md?id=3D9f2a940965286754f3a34d5737c3097c05db8725&qt=3Dgrep&q=3Ddisca=
rd+support
> , tryed just "discard" without support - found commits about dm, not
> md, though.
>=20
> Can you shed some light here? Thanks in advance.
>=20
> (resent in plaintext mode, please reply to this one)

Did you try:
    grep -i discard drivers/md/raid1.c
??

commit 2ff8cc2c6d4e323de71a42affeb3041fa17d5b10
Author: Shaohua Li <shli@fusionio.com>
Date:   Thu Oct 11 13:28:54 2012 +1100

    md: raid 1 supports TRIM

is the commit that introduced discard support for md/raid1.c

NeilBrown


>=20
>=20
> On Tue, Jul 16, 2013 at 11:15 AM, NeilBrown <neilb@suse.de> wrote:
> > On Sat, 13 Jul 2013 06:34:19 -0400 "Justin Piszcz" <jpiszcz@lucidpixels=
.com>
> > wrote:
> >
> >> Hello,
> >>
> >> Running 3.10 and I see the following for an md-raid1 of two SSDs:
> >>
> >> Checking /sys/block/md1/queue:
> >> add_random: 0
> >> discard_granularity: 512
> >> discard_max_bytes: 2147450880
> >> discard_zeroes_data: 0
> >> hw_sector_size: 512
> >> iostats: 0
> >> logical_block_size: 512
> >> max_hw_sectors_kb: 32767
> >> max_integrity_segments: 0
> >> max_sectors_kb: 512
> >> max_segment_size: 65536
> >> max_segments: 168
> >> minimum_io_size: 512
> >> nomerges: 0
> >> nr_requests: 128
> >> optimal_io_size: 0
> >> physical_block_size: 512
> >> read_ahead_kb: 8192
> >> rotational: 1
> >> rq_affinity: 0
> >> scheduler: none
> >> write_same_max_bytes: 0
> >>
> >> What should be seen:
> >> rotational: 0
> >
> > What has "rotational" got to do with "supports discard"?
> > There may be some correlation, but it isn't causal.
> >
> >> And possibly:
> >> discard_zeroes_data: 1
> >
> > This should be set as the 'or' of the same value from component devices=
.  And
> > does not enable or disable the use of discard.
> >
> > I don't think that "does this device support discard" appears in sysfs.
> >
> > I believe trim does work on md/raid1 if the underlying devices all supp=
ort it.
> >
> > NeilBrown
> >
> >
> >
> >>
> >> Can anyone confirm if there is a workaround to allow TRIM when using
> >> md-raid1?
> >>
> >> Some related discussion here:
> >> http://us.generation-nt.com/answer/md-rotational-attribute-help-206571=
222.ht
> >> ml
> >> http://www.progtown.com/topic343938-ssd-strange-itself-conducts.html
> >>
> >>
> >> Justin.
> >>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>=20
>=20
>=20


--Sig_/omkt2qr2rdYJGFRv+E_twTQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUeX3+Dnsnt1WYoG5AQICig//Ts9VuZYzRMo0KRkcLaCV8QZXcKHxIBi5
NWI+H2A4YJ2dmKM6DnBM9iGBufdmbLZbRHS/oL4wUfpPrMh4btXUJvKAq+hT5SzX
DEmi6JEEgcokf/Fchflo+uBHZJzk+T4bqg2OFxqCbPtcztW8PyIQk0Yt24caKmK1
twy1KvRBmOGluquU1PAOVffeB0/OqDayUTALHjTB5XbUznqAlrvTtxFe4BCubi6/
AT7ZYeZGtAlLPDiqPSSlXASG5gCDSC59Zv8zgjEVPrVIFxWj81Wv1vwseEbrRlQM
ZzB5jb1fs0+SqG9iDkXKUiKXA4JP16TkjUpOrCLlKeuxuVxY4zVX9QehaP+J63gU
Fb0jyJz/xZcPJLw3yyoLTRiTbvSJS2N6XnNdgjXNXaSxMnAaq2i9UVsjOCA3yfej
APbSZclnKf7x83clUKAG+tn/DTDKRGFhhmmRjBMPeO1W7YDw5klGoMp3bpuBdLKe
KMHsyKU6Gd0r11Afxo62cxmOdiWH6zHX0IFbaidZKkO1Mb0fU6S0Hd0lafq35K1Q
CDoBimnxlQqPk969zFPb9ub21NNORMbiTbC8UgA/efVIzqnLla+mxnh1fWdf6Xjl
M54U3E9M5LGGifB8z0cJVaEfzNTa8LOz1gTy6ytegmHXKxJPRaR91aL7q86ohoxx
e08+4UpZHis=
=ZHe1
-----END PGP SIGNATURE-----

--Sig_/omkt2qr2rdYJGFRv+E_twTQ--
