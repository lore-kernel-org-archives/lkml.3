Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaHAOLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:11:54 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45373 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbaHAOLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:11:52 -0400
Date: Fri, 1 Aug 2014 16:11:47 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Antoine =?utf-8?Q?T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: libahci: Make host flags unsigned long
Message-ID: <20140801141146.GB1913@ulmo.nvidia.com>
References: <1406893181-24764-1-git-send-email-thierry.reding@gmail.com>
 <20140801125206.GB21624@htj.dyndns.org>
 <20140801140121.GB373@ulmo.nvidia.com>
 <20140801140928.GE21624@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
In-Reply-To: <20140801140928.GE21624@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 10:09:28AM -0400, Tejun Heo wrote:
> Hello,
>=20
> On Fri, Aug 01, 2014 at 04:01:23PM +0200, Thierry Reding wrote:
> > I think there's just one occurrence. Turning the flags into an unsigned
> > long seems like a much more natural thing to do, though Besides it being
> > what many other parts of the kernel use for flags it gives us natural
> > alignment within struct ahci_host_priv. The structure currently looks
> > like this:
> >=20
> > 	struct ahci_host_priv {
> > 		unsigned int flags;
> > 		u32 force_port_map;
> > 		u32 mask_port_map;
> >=20
> > 		void __iomem *mmio;
> > 		...
> > 	};
> >=20
> > On 64-bit that unsigned int will be 32-bit and cause additional padding
> > to be inserted between mask_port_map and mmio to align the 64-bit
> > pointer.
> >=20
> > It's not like the alignment is that *hugely* important, but it's still,
> > you know, pretty.
>=20
> I don't get how that's pretty.  Sure, that space is consumed by
> something on 64bit archs but the extra space consumed can't be
> utilized unless we're gonna change how we use flags depending on the
> bitness of the architecture.  You're saying that rather than leaving
> unused space as unused it's better to commit that space to a variable
> which can't make use of that extra space anyway.  What if we later
> wanna add another int there?  Do we make that int a long too or modify
> the complete unrelated ->flags back to int?
>=20
> Prettiness is a good thing but code fundamentally should match what
> the underlying requirement dictates it to.  We sure have to trade that
> off too at times when the benefit gained is worthwhile, but I
> completely fail to see how this feel-good packed prettiness is
> anything worthwhile.
>=20
> In general, please don't do things like this in the kernel.  Use ulong
> for flags iff it's necessary (atomic bitops).

Oh well, as you wish, then.

Thierry

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT26AiAAoJEN0jrNd/PrOhJwMQAJkgsS8Q3z0MBWWz9ClXQg2S
XFvWTkIwryPGbhksplF9SSt1InQfhfvENgVt0duWAtoF/L839FofpnCINjUz0vTR
DPOL0LnDsdXqjGGCk5kisDgBSjb3g/nPpq7lJN3Th5L4rFWP0okOXq1geuWV0/H2
l4CjtJPGNT2QYYblYF4CFXju1AltHxouUG5IpwteU6qiL249Rkpv2cSlkRfy5jCM
GQVSjyqBfsj7Z+K7UNuHMPkxnjZZxIXw1fbxE4ZgszfUUehtwAy+FUskLAqZFYUE
Ck1nLFNVNQsivHs7NFyX5YCdYQUHVZX9yWyplb9324Snaq9Dw8zGRE/VsuJoR6gS
LcjieJ2DAErYAz0xDqv6U8/jPR8o3Nv7/lNYowH/Q6LsvX7dOEIZVtWoPZ6bUXeV
V7vItNxYbPfL+7Ru2CaRTNBokrpWohDbQla4BxDFRncQB28LAUXLeI/UY4RZ0bu/
yvGvKgzXIhnkvRG4WLIiox58fT9B3rmeCmRB+ChmuSWWxJ2zTG7YVrXbtC1CciYS
Vavr7wnjSJQDAMSSTaJCPi8JAmryIfWJvjpTH27VAYTaQjDCTjs4/UYRSD+tRifw
y8mqcVLlpq46BSNdjbmatc/6v6ifD7msun7U9Qewi56RKL6LhxoAxgkEydsTmPTm
bpznJYP+0M0/5lRADLOV
=Kc43
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
