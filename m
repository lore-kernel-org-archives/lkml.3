Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951AbaCZIdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 04:33:12 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:58760 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaCZIdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 04:33:08 -0400
Date: Wed, 26 Mar 2014 09:32:48 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC] dma-buf: Implement test module
Message-ID: <20140326083247.GA9512@ulmo>
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
 <20131212144210.GA1527@ulmo.nvidia.com>
 <20131213020258.GC13333@kroah.com>
 <20140325161722.GA23842@ulmo>
 <20140325180110.GA3532@ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <20140325180110.GA3532@ravnborg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2014 at 07:01:10PM +0100, Sam Ravnborg wrote:
> >=20
> > There are two things that don't work too well with this. First this
> > causes the build to break if the build machine doesn't have the new
> > public header (include/uapi/linux/dma-buf.h) installed yet. So the only
> > way to make this work would be by building the kernel once with SAMPLES
> > disabled, install the headers and then build again with SAMPLES enabled.
> > Which really isn't very nice.
> >=20
> > One other option that I've tried is to modify the include path so that
> > the test program would get the in-tree copy of the public header file,
> > but that didn't build properly either because the header files aren't
> > properly sanitized and therefore the compiler complains about it
> > (include/uapi/linux/types.h).
> >=20
> > One other disadvantage of carrying the sample program in the tree is
> > that there's only infrastructure to build programs natively on the build
> > machine. That's somewhat unfortunate because if you want to run the test
> > program on a different architecture you have to either compile the
> > kernel natively on that architecture (which isn't very practical on many
> > embedded devices) or cross-compile manually.
> >=20
> > I think a much nicer solution would be to add infrastructure to cross-
> > compile these test programs, so that they end up being built for the
> > same architecture as the kernel image (i.e. using CROSS_COMPILE).
> >=20
> > Adding Michal and the linux-kbuild mailing list, perhaps this has been
> > discussed before, or maybe somebody has a better idea on how to solve
> > this.
> I actually looked into this some time ago.
> May try to dust off the patch.
> IIRC the kernel provided headers were used for building - not the one ins=
talled on the machine.
> And crosscompile were supported.

That sounds exactly like what I'd want for this. If you need any help,
please let me know.

Thanks,
Thierry

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTMpCvAAoJEN0jrNd/PrOhQpwP/j044gKlg3K+K9ecnxJ1iT+P
js9z0/zLWG+aA27zbLj5V3LmGo06cdJcAaZOheiQYsHSkHhfOQXOqLnUOIyMKFXx
IH4/VNpy2K56T+bJPbDH/UgZ6zVfViIZq7bS8OHgwvB9s7mjPD68VyvFhF/NofGX
gqR7gYXzz7R5nJyQT4U4eRuE75d2y/z47z/vwI2maTWxicivhyodDlZF3Ydgt8yU
OlSN9MYsLdEYxv52nKUFbLoo6yNMxhztsJCmN3eAiht9I/ZY7OEFhRt1yu4/w4KR
P88Vp3k5SFaDRYA8V9IEGaAAxCL6ICTLc3wrHzBSScdhtCFtiImYv/BQDuPJ7Vx8
qto+rI77esA1S0oxDvfrcN4SCGWvyQ1bu3+g8djt8k5sZmmlzpYoygwX6PUv4QpA
FGeGqgDjHjEmQ0j9dWPJr/ZQE/8jLMQJwO5HIhkz/dNNbrgLnFrPsSSoKb/RW5Bp
f2vsiQFZPovca1Gv5NT4/MnNfAL+gqBPhp/mWQR9fNOx7kEEOBp0FApLve/B9EKS
Nftacokbg3GAEAHhRU1Ewq7eGUBMyBUX4wFfweX283Z9RfIbfvOz5YFxPqvDXz3Y
cUrNTUUxc+FvX6Pd3qjztPVGXiJdvi4BLD38kpi7dmaYjXFX8++PhO7QdVg05AP/
TdIke9AVMx4PVezzpvO0
=dvzz
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
