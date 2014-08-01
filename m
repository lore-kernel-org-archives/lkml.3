Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbaHAOBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:01:32 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:54495 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaHAOB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:01:29 -0400
Date: Fri, 1 Aug 2014 16:01:23 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Antoine =?utf-8?Q?T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: libahci: Make host flags unsigned long
Message-ID: <20140801140121.GB373@ulmo.nvidia.com>
References: <1406893181-24764-1-git-send-email-thierry.reding@gmail.com>
 <20140801125206.GB21624@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <20140801125206.GB21624@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 08:52:06AM -0400, Tejun Heo wrote:
> On Fri, Aug 01, 2014 at 01:39:41PM +0200, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > Commit 725c7b570fda (ata: libahci_platform: move port_map parameters
> > into the AHCI structure) moves flags into the struct ahci_host_priv's
> > .flags field, which causes compiler warnings on 64-bit builds when that
> > value is cast to a void * pointer. Rather than adding additional casting
> > to silence the warning, turn the flags field into a unsigned long.
>=20
> Unless we're talking about a lot of places where such casting is
> necessary, I'd actually prefer to keep the flags uint and use explicit
> casting.  How many are we talking about?

I think there's just one occurrence. Turning the flags into an unsigned
long seems like a much more natural thing to do, though Besides it being
what many other parts of the kernel use for flags it gives us natural
alignment within struct ahci_host_priv. The structure currently looks
like this:

	struct ahci_host_priv {
		unsigned int flags;
		u32 force_port_map;
		u32 mask_port_map;

		void __iomem *mmio;
		...
	};

On 64-bit that unsigned int will be 32-bit and cause additional padding
to be inserted between mask_port_map and mmio to align the 64-bit
pointer.

It's not like the alignment is that *hugely* important, but it's still,
you know, pretty.

Thierry

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT252xAAoJEN0jrNd/PrOhpIEP/0vUilXCfVDocsj35CZaO4P0
qdDHuTnBoDiUZt/cpDPg8O9LbcGhOgQPVuXtJio7bWb17MutQC1Ptz7knDB2ZsC5
Vx/SKMREGNPEtlB8bban1PnASx62RkTZConp4xcIGIn9lvBvXNlFXROCERyPBwH2
I1OKx6hZMF5nczPdm825qA3IF85IXvkM00k51Sa6Nou6Bgfyrz7HAHO38GySImqR
YntwO1fjQxVdZ3NrXkSBaKD3g9AWMVCKMICvLjdUPcd4zz8BxM0+SHA7x/jrYzZJ
b1hFDVlUN3Vhp4vS68VXSB8CnY2FJPZcxkpuxxY1n3bteBwIQvhra7rvQ1m02ne5
QvmQsiMX66EERn13ILChyXTRqQQjaOMlgGoIfVXU+UbIVXDM3Rctzt6x3TK2efFf
n5Tg6ndWHxfQ0Oak0//sx65IpIHIvOjdUvy2l7qB5aBXORrKPoMTr046YuOHWmWw
0V7EkuoPS2xH0IvsVT+H5s0o45ouIQ3sjZ3L9RAC/ki616W3ttS63FWCNi+RvrZi
fgrYjhOWvIGbO4gJ3kUNxTZEnnwYNPZRzS7PkwdT9tYzImxDgbnjHgkfH3cwHaWY
q4igi14LCKTcw5SG5zXRgjb2kXl+EnY0dLjC5t0O8s+qsmmRYQv4tgYh66TYoKlj
94vFzUse8wBzOqv4YoTX
=nhnL
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
