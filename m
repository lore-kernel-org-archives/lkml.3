Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751044AbaGaMSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:18:04 -0400
Received: from ozlabs.org ([103.22.144.67]:56474 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaGaMSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:18:02 -0400
Date: Thu, 31 Jul 2014 22:17:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoffer Dall <christofferdall@christofferdall.dk>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-next@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: linux-next: manual merge of the kvm-arm tree with Linus' tree
Message-ID: <20140731221752.4f563ced@canb.auug.org.au>
In-Reply-To: <CAEDV+gJ1oSPzgZMO=kdFDNPnzy-EOHGuLxHqTB8KO6d_8yPrxQ@mail.gmail.com>
References: <20140731163004.474501fb@canb.auug.org.au>
	<CAEDV+gJ1oSPzgZMO=kdFDNPnzy-EOHGuLxHqTB8KO6d_8yPrxQ@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/aE_yGPSgA/cRY+KhcKqtXiV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/aE_yGPSgA/cRY+KhcKqtXiV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christoffer,

On Thu, 31 Jul 2014 13:53:03 +0200 Christoffer Dall <christofferdall@christ=
offerdall.dk> wrote:
>
> On Thu, Jul 31, 2014 at 8:30 AM, Stephen Rothwell <sfr@canb.auug.org.au>
> wrote:
>=20
> > Today's linux-next merge of the kvm-arm tree got a conflict in
> > virt/kvm/arm/vgic.c between commit 63afbe7a0ac1 ("kvm: arm64: vgic: fix
> > hyp panic with 64k pages on juno platform") from Linus' tree and commit
> > 8f186d522c69 ("KVM: ARM: vgic: split GICv2 backend from the main vgic
> > code") and others from the kvm-arm tree.
> >
> > I fixed it up (the latter extensively rewrites the function, so I just
> > used that) and can carry the fix as necessary (no action is required).
> >
> >
> > Hmm that doesn't look correct, the checks  for
> PAGE_ALIGNED(vcpu_res.start) and PAGE_ALIGNED(resource_size(vcpu_res))
> still need to be enforced for both vgic-v2 and vgic-v3.  How do we provide
> a correct fix for Linux-next?

Just send me a patch relative to today's linux-next (or merge
338eeb9b8318) and I will add it when I merge the kvm-arm tree on
Monday.  And don't forget to tell Linus :-)

Or you could merge commit 63afbe7a0ac1 ("kvm: arm64: vgic: fix hyp
panic with 64k pages on juno platform") from Linus' tree into the
kvm-arm tree (which is what Linus merged) and fix it up yourself - with
an appropriate comment explaining why it was done, of course.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/aE_yGPSgA/cRY+KhcKqtXiV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT2jP2AAoJEMDTa8Ir7ZwVrl4P/28zV1AwnqX4piRKGRWuakpH
afWeoG+6FH78LvMfLvSIAinXCBtc4Frcr1UMSbrgWYconPmXwtN5Eg2ORq4E5dn8
iM9EAFhNQ3PUPDs5DiWOwAjNleFcy2hogvq6fGscqqAKS9ijXRUsjOTkmulQNLCN
oJGAEdwMNoVnlUdy+RM5i4qbK3RdNY4vJkxGMC5WoC13DsYtpAPMggI35UK6+anD
e4aWjT5r+u6t7ISNszJvi5fMLrD2vuorsHnoyvuEkc75itA05v8Doo6Xy67s1yZB
N9dp5MTNZceoaDaAL8HaAzM/wYizmeHzxqOfePJCB/v3EU0X/xnTQyXr8w3vBC78
7pM0qcsB5lsSI1KGpOtiCFnl/SAhZt0hECQ6nPb6KLAwVtPE9IzlzyLM22yWKA7k
f2E08KqQshOXrpKXVVglrYGLnqMT+3LWayCP8MjBjR+xPdUNXZZZiT09NK/hYelR
KPErsddvQt6ybOIRFp16KIh6y7p1fM/Fbzr18R6zRCWfvlb1iuP0vBC4VW7iWcP9
XC3xTquMzthNIBP+bAQnVBDIZWyi9OcpCbY4J4XSVIBxcsQgxFipZHfRbTLzqhrM
XeryPtMjzpUftSVVUNjGAZWM2eT9wINfgL3FiYeEhlbac/hvhWxINF24LczzS211
DOQQr3w6Dx+BsVKsRiuj
=P+XO
-----END PGP SIGNATURE-----

--Sig_/aE_yGPSgA/cRY+KhcKqtXiV--
