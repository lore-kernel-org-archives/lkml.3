Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3LNMhP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:37:15 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:34458 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3LNMhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:37:13 -0500
Date: Sat, 14 Dec 2013 13:37:10 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] dma-buf: Implement test module
Message-ID: <20131214123709.GE17467@mithrandir>
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
 <52AA0FC4.3090606@vmware.com>
 <CAKMK7uGOt2CYCgyE5rnXE3wJJjJiRpoQMB_-+_+m_qhk3TH8QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UnaWdueM1EBWVRzC"
Content-Disposition: inline
In-Reply-To: <CAKMK7uGOt2CYCgyE5rnXE3wJJjJiRpoQMB_-+_+m_qhk3TH8QQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UnaWdueM1EBWVRzC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2013 at 11:30:23PM +0100, Daniel Vetter wrote:
> On Thu, Dec 12, 2013 at 8:34 PM, Thomas Hellstrom <thellstrom@vmware.com>=
 wrote:
> > On 12/12/2013 03:36 PM, Thierry Reding wrote:
> >>
> >> This is a simple test module that can be used to allocate, export and
> >> delete DMA-BUF objects. It can be used to test DMA-BUF sharing in
> >> systems that lack a real second driver.
> >>
> >>
> >
> > Looks nice. I wonder whether this could be extended to create a "stream=
ing"
> > dma-buf from a user space mapping. That could be used as a generic way =
to
> > implement streaming (user) buffer objects, rather than to add explicit
> > support for those in, for example, TTM.
>=20
> Atm there's no way to get gpus to unbind their dma-buf mappings, so
> their essentially pinned forever from first use on.

Shouldn't this work by simply calling the GEM_CLOSE IOCTL on the handle
returned by drmPrimeFDToHandle()? I mean that should drop the last
reference on the GEM object and cause it to be cleaned up (which should
include detaching the DMA-BUF).

Thierry

--UnaWdueM1EBWVRzC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSrFD1AAoJEN0jrNd/PrOhkOcQAIU6mAIRpiWsMNzIRAxEVmSM
0Ny2doua3ABovzlUfSzyliCBp/Dyu9AX3G0oEJK5hDTaNpE5ExBEEAIRhJ6zOIq9
oIBTgsI5Q3fYs8GvugzxbiiUXwhJQS2t8kjLIig9SdIB5rwwnpZBB2bUz2w7XAg+
zg+duUnRUzISHPJqslcob1Va62XzGIAVG1enGpJCRlsROIxwtoihq+31y2kFA7xt
IKsl0f/60vebHVNTWqyhd6d07saxExH+gDZ34fhU7Z8kfAFZf49/ZrCiuR5Z78Ak
Jugllj86buGjCMfVO4Z5xdkJ27zoNunFdZ6dk3rKFgtM/MrDhP+MK4j2YPUL5u8+
p8SMB1cTX6lT8rlD5v2MFg4RnL/td9vqsZydhrNLKrRYFThvQqW3ZRISYaPDI3yq
vxVGd6apBOwkfikwlomD9meuV4pOHLoNXoK7Urz20eRZp2wzn2hrNneKeYei6WJi
7vjQIh2BUFlIB3xd5a81kKJO7Px3z9gs/2+mxMtO4KYOuhw7wCaIT5Nm7JmkQVvu
mRWlYA7x3LMRt2d6RQoJianKidV1J6xzIpW6S0IhvE6jOxUoLlXzmi/0vD6EpLz8
BmfaDFRreL2Rf7RQ/Aw0h0cNuCLAB/0I67bmiGkQbxvVe3sgoLibCwoeGAi9xIpp
VWtxBzqfg3wiEKuzn+lx
=8jiv
-----END PGP SIGNATURE-----

--UnaWdueM1EBWVRzC--
