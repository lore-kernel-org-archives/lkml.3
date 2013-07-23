Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257Ab3GWUdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:33:13 -0400
Received: from home.keithp.com ([63.227.221.253]:47452 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933810Ab3GWUdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:33:12 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: drm: Asynchronouse page flipping interface and Intel implementation
In-Reply-To: <20130723201559.GO5939@phenom.ffwll.local>
References: <1374544202-15496-1-git-send-email-keithp@keithp.com> <20130723201559.GO5939@phenom.ffwll.local>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i486-pc-linux-gnu)
Date: Tue, 23 Jul 2013 13:33:06 -0700
Message-ID: <86fvv53tkt.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Daniel Vetter <daniel@ffwll.ch> writes:

> Quick comments on the i915 kernel part:
> - Iirc the w/a database has a bunch of entries about async flips. Those
>   need to be addressed and annoted with the new w/a tag comment format
>   Damien recently created.

Where does this database live?

> - kms_flip needs to be extended to beat on async flips. Obviously the
>   timing checks don't apply but otherwise I think it won't hurt to enable
>   all the existing interaction tests with async flips, too. On top of that
>   I think we should test interactions between async flips and vblank
>   synced flips. Without the timing checks the other tests will run as fast
>   as possible, so that should gives us good coverage of the
>   non-ratelimited nature of async flips - even with vblank flips we've hit
>   ugly issues by e.g. starving the unpin workers.

async flips are still somewhat rate-limited -- the actual buffer flip
happens on a scanline boundary instead of a frame boundary, so we still
take an interrupt and report an event back to user mode. There are
worrying comments in the bspec which say that an async flip queued
during vblank may actually take a couple of scanlines *past* the vblank
interval before it takes effect. Because of the delay, the code path
differences between the two cases are limited to just setting the bits
in the hardware, which leaves me fairly confident in our ability to test
both cases successfully.

> Oh and my little comment about moving all checks into core code is a bit
> wrong, we'd still need to check for X-tiling with async flips ofc.

From=20my reading, non-async flips do not have the stride and tiling mode
requirements which are currently in the code though. Might be nice to
test this?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUe7ogjYtFsjWk68qAQgfiRAAsy4CRw9lt5jm06AvcHaxo7b++ugzCNMZ
wbkZhjir1mhmW9VE7LGkGTkBa+nUXbx3CDOiTkjgITOdm79GRhm+8fAm0U7FDos4
pW0OwB7R4OON3IZdByHHw/za4AlrWwn2kgFEs2zXsFKda/FtYwg7REsZ2iX3F5sk
eozk4cHLcn5/U1d0RmGM/+63KgL7QuXSEyiyJzE4VYaAZpkmrcVT9YYIatldUVTb
OFgukrB248Eu85jjNh+Rnnin7B9cEgNE/USNS+X7YfT9ffsSVitWS4JQPvo/7RjO
L2XMVFMXEXNEaa704zb129FLQFvfTxbH1xX0zemVLTkszvnJzUMm/o4mO6w3iOus
qN7jokkXnc3yM/6l7ZOvSF03yk4QuQRYt6VXEPfVykgPkOGeOyrFY6AgdcPgM9Cs
DuSGK7S9+oqYD3o2AgU7ysK+sCDLhj+nh9f/GLr1xvKtAEIQYvG9c7CcJzu0W6LS
99pINNPjPnmVpXDv9XGB9Kf/NgqR2Xk1qPKPNmD7fawmp/UW7iVrSlue5TSX+O3P
L/SWEPv+sz3H7dGufBE6lvXtMwoHKpxwV3s/esvvQgjSgqH+jgfq6VazJwnRj1dH
toswjyd+MpgSwtzkghseD21MRnBHgL65tIEsMMoKCF6tjdGUv4v0mjSrMLUKskuC
HkdJUqjcg9o=
=1FDI
-----END PGP SIGNATURE-----
--=-=-=--
