Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaCPXQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 19:16:20 -0400
Received: from ozlabs.org ([203.10.76.45]:45434 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124AbaCPXQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 19:16:18 -0400
Date: Mon, 17 Mar 2014 10:16:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-Id: <20140317101611.d043a90e1cb72dcfb8bc767a@canb.auug.org.au>
In-Reply-To: <20140312015021.GC10106@kroah.com>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
	<20140312015021.GC10106@kroah.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_10_16_11_+1100_MXMxE7jtATQV1hCp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_10_16_11_+1100_MXMxE7jtATQV1hCp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 11 Mar 2014 18:50:21 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Wed, Mar 12, 2014 at 12:51:52AM +0000, Mark Brown wrote:
> >=20
> > After merging the driver-core tree, today's linux-next build ()
> > failed like this on a PowerPC defconfig:
> >=20
> > HEAD is now at ceb98e684dec Merge remote-tracking branch 'driver-core/d=
river-core-next'
> >   GEN     /home/broonie/next/powerpc_ppc64_defconfig/Makefile
> > #
> > # configuration written to .config
> > #
> > /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-elog.c: In =
function 'elog_ack_store':
> > /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-elog.c:84:2=
: error: implicit declaration of function 'sysfs_schedule_callback' [-Werro=
r=3Dimplicit-function-declaration]
> >   sysfs_schedule_callback(&elog_obj->kobj, delay_release_kobj,
> >   ^
> > cc1: all warnings being treated as errors
> > make[3]: *** [arch/powerpc/platforms/powernv/opal-elog.o] Error 1
> > make[3]: *** Waiting for unfinished jobs....
> > /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-dump.c: In =
function 'dump_ack_store':
> > /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-dump.c:100:=
2: error: implicit declaration of function 'sysfs_schedule_callback' [-Werr=
or=3Dimplicit-function-declaration]
> >   sysfs_schedule_callback(&dump_obj->kobj, delay_release_kobj,
> >   ^
> > cc1: all warnings being treated as errors
> >=20
> > due to an interaction between d1ba277e7988908 (sysfs, driver-core: remo=
ve unused {sysfs|device}_schedule_callback_owner()) and 774fea1a38c6a5a8 (p=
owerpc/powernv: Read OPAL error log and export it through sysfs) from the P=
owerPC tree.
> >=20
> > I reverted 774fea1a38c6a5a8 for today.
>=20
> Sounds like the powerpc tree also needs to stop using this function :)

So, explain to us in detail why the old interface could not be maintained
for a release, please.  I thought we had become a bit more sophisticated
about changing core APIs i.e. introduce the new API - fix up all the
users - keep the old one around if possible for a release (or beyond
-rc1) to catch the new users.

It may be that there is a good reason not to so this in this case, but it
is not explained as far as I can see.

Alternatively, it looks as though there may be a fairly trivial transform
from using the old interface to using the new one which could be applied
as part of the merge of these two trees (in linux-next and then in Linus'
tree during the merge window).  Maybe you or Tejun should have explained
that and provided a prototype for the merge fix up.

Greg, you are doing core infrastructure changes in your trees - you need
to consider that new usages may be introduced while those changes are
ongoing.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Mar_2014_10_16_11_+1100_MXMxE7jtATQV1hCp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJjC/AAoJEMDTa8Ir7ZwVZHAP/39gsLMwmK8wXZxtSYgTq54N
9tU3KlBkxEaDPQ5LCbF37Sda98rPgYzy2h7R1Cu5CSuk70sr7dk1NyvOs0SRftjZ
eJzpmIesfnpxk3Fb+uvhSxzkCJAZy6hmxGFdeQpdYj0YBMblNobZEPfVdHrzht1E
yTVgc9vH/jV/30l9Sw44NXTbactdGD+kyMrnDtSldiffUPTvS1vYLCx4mLpiR3Po
1gq2+K8wQb21Gdghxj0HQTKAWsEGOkttbSEOKl0TzULrYrLmFDEBe+QoE8prjEHU
ehp0Cjmonv5NfsDL/ixKVOy+TFgANBWAS1c5W8NS2SyWRMQ9zwnpyARvBGAlNysA
ydA4heiil7zBC7qjYs1FUyvI4B2lS8VYbQwV3UdVTrfPpf7waDvfYAe3OWdlbECa
yIukDvJf+X/e5m3RWDewK97458SaG+XazbsQextqTGVYtDdGoBWV16h/0zLE53Ge
lPMERf2HDnz0icG80AS3hbblx9uNXBerpRvNdwyf9jJUZGeIOOB4rlVt6GiqoYsa
0krb7B99et6OlOaF9ggN1gBZVu/5hyS6V5F3l048urb+P0HGCAwgSZsInaK8p+I3
7anij5813fVjbvy9RTnqs8nTFjVocgEZhWdIZ/Nv2cLgFQjICuzUBZE1JcS/RQXG
B/CBsX56YmsOli3stUvB
=V+Th
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_10_16_11_+1100_MXMxE7jtATQV1hCp--
