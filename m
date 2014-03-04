Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbaCDWCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:02:48 -0500
Received: from ring0.de ([5.45.105.125]:38548 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbaCDWCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:02:47 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 4 Mar 2014 23:02:40 +0100
From: Sebastian Reichel <sre@debian.org>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv1 1/2] rx51_battery: convert to iio consumer
Message-ID: <20140304220238.GA11789@earth.universe>
References: <CAAfyv37B=xn3AktnUxPDpuey+5S73vW0PJnuUZtorP4rajPKiw@mail.gmail.com>
 <20140226215452.GA11468@earth.universe>
 <CAAfyv340pA2ihUAoFytBgevLtedvtj5Z0aw_=G9Rbx5occtyqw@mail.gmail.com>
 <20140228020536.GB5427@earth.universe>
 <CAAfyv36jJoMxZQ5e43pEC2rzNBHHW9Jt_4dg5O-fS8e+Aim7jA@mail.gmail.com>
 <20140228210857.GA17467@earth.universe>
 <CAAfyv34UB52FCDQGMWWgsdHH8ksTLmTg0iWQcC+dUbhk5nwuoQ@mail.gmail.com>
 <CAAfyv36RPCkUKLOC6yHRwaNjA16EeG_niyfZoaJ15LZ5_HdR7g@mail.gmail.com>
 <20140228232223.GB23878@earth.universe>
 <CAAfyv36LD_JmPfBFCkQo9pLbgM4vwqk_P0M_XOAnPTUppQ1Zug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <CAAfyv36LD_JmPfBFCkQo9pLbgM4vwqk_P0M_XOAnPTUppQ1Zug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Tue, Mar 04, 2014 at 10:20:32PM +0100, Belisko Marek wrote:
> On Sat, Mar 1, 2014 at 12:22 AM, Sebastian Reichel <sre@debian.org> wrote:
> > On Fri, Feb 28, 2014 at 11:32:22PM +0100, Belisko Marek wrote:
> >> Seems I found issue. I have missing property ti,system-uses-second-madc-irq
> >> as original twl4030_madc_battery used SW2 but this change doesn't fix completely
> >> the problem.
> >
> > I remember adding this property because you requested it :) Good to
> > know, that its really needed.
> >
> >> What it fixed completely is change:
> >> -       req.raw = !(mask == IIO_CHAN_INFO_PROCESSED);
> >> +       req.raw = 0;//!(mask == IIO_CHAN_INFO_PROCESSED);
> >
> > ok, that figures it. Instead of changing the twl4030-madc driver
> > you should change the twl4030-madc-battery driver. You currently
> > call iio_read_channel_raw(), which gives you raw values. Your
> > driver wants processed data from twl4030-madc, so you should use
> > iio_read_channel_processed() instead.
> Yes this helps but also not completely :(. twl4030_madc_battery using
> chanel 1, 10, 12. Channel 1 and 10 have flag IIO_CHAN_INFO_PROCESSED
> set but channel 12 not and values from channel 12 are read as raw which is not
> what I want.

mh. I should have added IIO_CHAN_INFO_PROCESSED for all channels
and not just for current & temperature special cases.

I will send an updated patchset.

> Can I simply add IIO_CHAN_INFO_PROCESSED also to channel 12?

Yes, but if you wait some minutes you can use my updated
twl4030-madc patchset. This way you can add your Tested-by
once its working.

-- Sebastian

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTFk1+AAoJENju1/PIO/qaRoYP/0k5PzQ2YpBtoOj/qGYYAyPO
d8lvsbSwszIyBbNAmVwg5yLfStC/IbLSCVShr6Y4/yrurpedA+w/sPmhH83oi8Vc
KVfAGyPWzBbY7bpyg1zjPf9epUoKkJWLJdipSQBp864onLAjrI7drAckt0sHLrHH
wzgqZKZTRpOF8LoQuTaIt4GmkwM7JPzZAWDqeCEcV/gc0792bm5U1jykTNnQw66Z
IVUpCA7dSM01xdtzo3RT06Opj2EYoxD6uVPpbxtL+DaA9Ij0cFljxgkqehapv8JR
NLs/KnmccCYn6CKNNvbebSGQgATogGV+/RtSeAosTbMzo52l6AN0xkYSC1P3tBff
56CSB1DolsKEwfvVEv09qSmAk7iE5+iNI26CA3MTXF02KdiBsdWiZQYdGX5FvDdV
3+pwgpK/+E+CxrGHQARuRz1/Czb9rgVbIBkQb/E8VQk0tVXL6Cpkxpr/FyJPDH5O
qrGUaqjnn+L0SDvxS/UqPT/sQcQI/3FogqVfSwiB7gdPajIn0AaJeHLYc9FVnK5I
eHScD5zCDkwYbSvMsRJkw/kGHAFXbJAGjbSnvzZ0H4KSrnOn5B2BK6Umk8z1n1O0
zTsMvS8cVMF1o1WVXjfUrlKI57CUedpmNFBHVat6UjAiO1adpmLhOmRBjGep09ko
fNcZ5+SUEAIMcWgjUAL+
=IvxF
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
