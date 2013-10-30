Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3J3VST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:18:19 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:49246 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3J3VSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:18:18 -0400
Date: Wed, 30 Oct 2013 22:18:15 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Paulo Zanoni <przanoni@gmail.com>
Cc: David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] drm/sysfs: Do not drop device reference twice
Message-ID: <20131030211814.GC7686@mithrandir>
References: <1383130745-32165-1-git-send-email-treding@nvidia.com>
 <CA+gsUGSjJmqu9Ph0znE5XJJOJdeh-UT3z2Cjm7sEMB4F+ZtAvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L6iaP+gRLNZHKoI4"
Content-Disposition: inline
In-Reply-To: <CA+gsUGSjJmqu9Ph0znE5XJJOJdeh-UT3z2Cjm7sEMB4F+ZtAvg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L6iaP+gRLNZHKoI4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2013 at 02:05:02PM -0200, Paulo Zanoni wrote:
> 2013/10/30 Thierry Reding <thierry.reding@gmail.com>:
> > device_unregister() already drops its reference to the struct device, so
> > explicitly calling put_device() before device_unregister() can cause the
> > device to have been freed before it can be unregistered.
> >
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
>=20
> I started investigating this problem yesterday and reached the same
> conclusion. The connector path can be easily reproduced on i915.ko:
> get a machine that has an eDP panel, physically disconnect the panel,
> boot the machine, "modprobe i915" and watch the segfault.
>=20
> Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
> Tested-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
>=20
> I didn't really bisect, but I believe this is probably a regression
> from "drm/sysfs: sort out minor and connector device object
> lifetimes".

Yes, I think that's the one that broke it.

Thierry

--L6iaP+gRLNZHKoI4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJScXeVAAoJEN0jrNd/PrOhTLsP/1jSA43Ie5nwnqy51Zr+fL63
/3bCepldqSDmi3/a24pOPkO5EYwKw03MzC/47HdkrkzM2JVpOBaY6LTVZW7sJ9G+
59WSJiPVjArvmiUKAY0en3Y3QKT6KGIdaYDlzHOUe/o8IGAhMNNpYQDJK8eadgGP
zhtr5wujfxVUL4wT4dmygWp12WsqztVEY/vipPGNzQROiFJuhB4LTtwytA08FESU
imRBmJIIWG4Bjn6fpvRImTZz7sNwnNHr4MXGtUS0ZwoNr7dYSWDH/jioiyuCVCb2
KsX8HmVUvW98GnxfKbF3RH15totmEYsj/ijQLlCEe972adMxg3P57FlO5271yu1U
U/e2EKrLTLVQwGFx+hlPTHxRf9ihsh8QCY9Kr6QwQDJf5n/6JAQ+5EJkTcFhuqkY
fPwAYVuOkCJQMxX0GCHJUfO3oNHHb+AHq3bsPh0AikAcymtAWpICYUmMXzSgon18
/6eTa822k0zPzZ1iN49PL1xyKZmuDTew+Os4SK8kZgBFeTez9YGwIQ1kIS7DuQXv
RNwlVFR2KW8orErHyf75kYZHjP9IAamvE7ZZkyHc5SKRAQb6kVnPswZt+I7NVK/y
EueKuKCqnOOXQubi5nD1YmiHxEIU3Nft0ofNoUQk0UdW1+yRMy/qAlONAtB1Uhrm
l285mn8jFJrniYRZwPCF
=7zvV
-----END PGP SIGNATURE-----

--L6iaP+gRLNZHKoI4--
