Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbaGPS6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:58:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37241 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbaGPS6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:58:08 -0400
Date: Wed, 16 Jul 2014 13:57:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: <balbi@ti.com>, <will.deacon@arm.com>, <mingo@redhat.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: Function Profiler broken on today's linux-next
Message-ID: <20140716185732.GN3016@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140716162328.GJ1365@saruman.home>
 <20140716122921.71b118a9@gandalf.local.home>
 <20140716164141.GA3016@saruman.home>
 <20140716132413.1ede8e1d@gandalf.local.home>
 <20140716182944.GK3016@saruman.home>
 <20140716184152.GM3016@saruman.home>
 <20140716145442.15f25ec3@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5PFZVUeDPxlnBcQp"
Content-Disposition: inline
In-Reply-To: <20140716145442.15f25ec3@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5PFZVUeDPxlnBcQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 16, 2014 at 02:54:42PM -0400, Steven Rostedt wrote:
> On Wed, 16 Jul 2014 13:41:52 -0500
> Felipe Balbi <balbi@ti.com> wrote:
>=20
> > Hi,
> >=20
> > On Wed, Jul 16, 2014 at 01:29:44PM -0500, Felipe Balbi wrote:
> > > On Wed, Jul 16, 2014 at 01:24:13PM -0400, Steven Rostedt wrote:
> > > > On Wed, 16 Jul 2014 11:41:42 -0500
> > > > Felipe Balbi <balbi@ti.com> wrote:
> > > >=20
> > > >=20
> > > > > .config attached. It's actually an ARM platform, I can help out w=
ith
> > > > > testing anything you need.
> > > >=20
> > > > In that case, can you see if it works under my repo?
> > > >=20
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.g=
it
> > > > branch: ftrace/core
> > >=20
> > > works fine, thanks. FWIW
> > >=20
> > > Tested-by: Felipe Balbi <balbi@ti.com>
> >=20
> > Actually it seems like it's not counting time properly if I run my test
> > multiple times in a row:
> >=20
> > # /root/testusb -t 1 -c 100000 -s 2048 -a
> > # head -3 trace_stat/function0
> >   Function                         Hit    Time                Avg      =
     s^2
> >   --------                         ---    ----                ---      =
     ---
> >   thread_interrupt               174876    166120839 us     949.935 us =
 3048498 us
> >=20
> > # /root/testusb -t 1 -c 100000 -s 2048 -a
> > # head -3 trace_stat/function0
> >   Function                           Hit       Time                    =
Avg          s^2
> >   --------                           ---       ----                    =
---          ---
> >   dwc3_thread_interrupt            286796    967267300 us         41905=
45199 us     3241109 us=20
> >=20
> > # /root/testusb -t 1 -c 100000 -s 2048 -a
> > # head -3 trace_stat/function0
> >   Function                              Hit      Time                 A=
vg               s^2
> >     --------                            ---       ----                 =
---              ---
> >   dwc3_thread_interrupt               401346    642632072 us       1601=
=2E192 us     1194316 us=20
> >=20
> > and so on...
> >=20
>=20
> Did it use to work? In other words, is this a regression, or just some
> another bug?

It used to work at least on v3.12... It seems like it's not always
either. After I rebooted, then it took a little effort to trigger it
again. But if I just run my test in a loop, eventually it'll start
miscalculating.

--=20
balbi

--5PFZVUeDPxlnBcQp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxsscAAoJEIaOsuA1yqREky8P/iLyrkNsNJxBnZdzkNPD86pP
4106CNQR+4BSe/vOOXyoHmlZbp+DfEUytFd3N2hNg3vWWjpzHS0VQuG+6wdVBa5S
qfdqZINmsjQhbylwaHjaf/OOQFvbfz5F0aAPQQaO6z0XdYFbBfR/h/Kp6o8YfuGB
7GKyXecQ8Gy+PmHaWmnyXoQrMHQAzkKG7rqY5YxEPtygNs46ajvN8QzYBIRt0CrC
nsI+IXtBLhc2yOQF5QnKqkOjJRchpa/gL0k2wPEB7j+eON1S1RZdd9W9iFCL2DW9
jTZPJz3amNHqkM47N1g2wxcBdoKQ0e7kDmxkYNNWGgjDlZI+8H6KHLeyEyRapPs/
9A5SwmZm9Okk+Lx0jGODkKqfgpXhYBaMISyDhWBlPd63w1o22iA/975gS6mVbqjd
/U6yYKcbG59EMh0xhmkQxyuiq1Ey5knj0ElKFv3EtiKtdzUNcXnkaw+FQ/JdiwgO
RoxTuVDYw7a3dC09BpFagxcNdA+36y5X8LrfoEutWz1T/ti909Dra1tU03iJ0xlm
H3+ThJXOAZ/viHku97gIBYdMX9KJnEIf3v1rQ7esX2qV73I9rAJQtntlKCOG1/cE
fC4CytxkJJNoMlS3M6OMGTjOD/Nc5hi0+eWmdQeDaCGC7tPWCQ8P8IfskMUHmeMd
pAMC+lomHvUJ6OFu2R9T
=TXhc
-----END PGP SIGNATURE-----

--5PFZVUeDPxlnBcQp--
