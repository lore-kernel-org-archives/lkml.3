Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbaGDPLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 11:11:10 -0400
Received: from ozlabs.org ([103.22.144.67]:47066 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbaGDPLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 11:11:08 -0400
Date: Sat, 5 Jul 2014 01:10:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sachin Kamat <spk.linux@gmail.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: linux-next: Tree for Jul 4
Message-ID: <20140705011058.198ae810@canb.auug.org.au>
In-Reply-To: <CAK5sBcGq54sOSzJKXrEbhAUTZZh=+9NuVh294Qxn0dQvbh-G8w@mail.gmail.com>
References: <20140704164251.7dc67e07@canb.auug.org.au>
	<CAK5sBcGq54sOSzJKXrEbhAUTZZh=+9NuVh294Qxn0dQvbh-G8w@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/k/EspPWTzP/8YpgndVhqCKN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/k/EspPWTzP/8YpgndVhqCKN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Sachin,

On Fri, 4 Jul 2014 14:12:11 +0530 Sachin Kamat <spk.linux@gmail.com> wrote:
>
> Was bisecting a kernel crash on Arndale octa board (Exynos5420). It
> points to a merge
> commit:
> 40556a4c485d12d324f1ea196cc30f590e564237 is the first bad commit
> ("Merge remote-tracking branch 'nfsd/nfsd-next'").
>=20
> How do I proceed with this?

I guess we get the owner of the tree (possibly) in question involved
(cc'd).

> Bisect log as follows:
>=20
> git bisect start
> # good: [4c834452aad01531db949414f94f817a86348d59] Linux 3.16-rc3
> git bisect good 4c834452aad01531db949414f94f817a86348d59
> # bad: [bb62c798798659624c53e3727bbc18cf47eb7ae8] Add linux-next
> specific files for 20140704
> git bisect bad bb62c798798659624c53e3727bbc18cf47eb7ae8
> # bad: [de5ea10b7647b299d27a40511772f024629b466d] Merge
> remote-tracking branch 'md/for-next'
> git bisect bad de5ea10b7647b299d27a40511772f024629b466d
> # bad: [3ca365b4451d1bab28adc72a985d9bbdf535df0e] Merge
> remote-tracking branch 'dmaengine/next'
> git bisect bad 3ca365b4451d1bab28adc72a985d9bbdf535df0e
> # good: [d72d4e47cb1e8ac1259a5f5935320ae1e7022066] Merge
> remote-tracking branch 'renesas/next'
> git bisect good d72d4e47cb1e8ac1259a5f5935320ae1e7022066
> # good: [fdb82f0a3d19eaa0661d799b980d0a9b689fcf75] Merge
> remote-tracking branch 'nfs/linux-next'
> git bisect good fdb82f0a3d19eaa0661d799b980d0a9b689fcf75
> # bad: [fc48eed8cd350e4be1227ff3c990d48906afd00a] Merge
> remote-tracking branch 'hwmon-staging/hwmon-next'
> git bisect bad fc48eed8cd350e4be1227ff3c990d48906afd00a
> # bad: [7d3f94ee2f2808b13dd3a96f6e6ca754a954d4b9] Merge
> remote-tracking branch 'ubifs/linux-next'
> git bisect bad 7d3f94ee2f2808b13dd3a96f6e6ca754a954d4b9
> # good: [8cdb8b21b1d00856b885734c514821627c8078bc] NFSD: Avoid warning
> message when compile at i686 arch
> git bisect good 8cdb8b21b1d00856b885734c514821627c8078bc
> # good: [da575690c01993471e38faf3eee1991ee69d7b20] nfsd: clean up
> nfsd4_close_open_stateid
> git bisect good da575690c01993471e38faf3eee1991ee69d7b20
> # good: [95217c1e686bdd7c27b8483bbdda1c09d6fa9a92] nfsd: Don't get a
> session reference without a client reference
> git bisect good 95217c1e686bdd7c27b8483bbdda1c09d6fa9a92
> # good: [bdd79ee31bf842051365c798effaffe0e647b501] nfsd: Allow struct
> nfsd4_compound_state to cache the nfs4_client
> git bisect good bdd79ee31bf842051365c798effaffe0e647b501
> # good: [e9110361a9a4e258b072b14bd44eb78cf11453cb] UBI: fix the
> volumes tree sorting criteria
> git bisect good e9110361a9a4e258b072b14bd44eb78cf11453cb
> # bad: [40556a4c485d12d324f1ea196cc30f590e564237] Merge
> remote-tracking branch 'nfsd/nfsd-next'
> git bisect bad 40556a4c485d12d324f1ea196cc30f590e564237
>=20
> Regards,
> Sachin.

Can you please double check that commit bdd79ee31bf8 is good and commit
40556a4c485d is bad.  Also check that commit fdb82f0a3d19 is good.

In that case we have the unlikely event that the (automated) git merge
is not correct or patches on each side of the merge semantically
interact badly.

I guess the next thing to try is just Linus' tree (commit 5170a3b24a91)
merged with the nfsd tree (commit 2fc193cf924e).

You should also post your information about the crash you are
diagnosing as others may have seen it as well - or know what may cause
it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/k/EspPWTzP/8YpgndVhqCKN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTtsQIAAoJEMDTa8Ir7ZwVT8YQAJHzYeZf6IF73wGmY34jtcBg
NV9sjuZkz5lsbxn16Jf/QKP+55REwBV49S1rZ3xgd61Xkvp1IDnIEGStV/cvCHDp
B3Y0fMRcJdkr+rnEncyhQMCVET1CclYc27I9/hdVhP2WYCxITF5C+NgRmUC0kI3I
NLjZktEOV2BXqRidStejPgyVWUfaYKnKjWKiprjmJGixPmHQLepU+38ni3zJnqjD
Gr7eD9jQbojPhz5rx0dK69uPF3pRV8W48y9qokq+L96T4rRA1RX0dEoTRhHnN8Ya
Z9uuPjOjIqXNeL3716s9Wm2sMmjfuAR3pXU+D+kIMcAhKCLEat7JCfchCVdtUE7B
nE4xVo3aGV/StIJSAsDGg6AO4Bv6G+QYTogXCkagu6JSfyCusYFcDyu37nykMKOo
8uLU9fqXeC2dcB4WHT/Jl8KkOhCJvwQfKLBO24+u3G3U63Hh0tmcFpsrUo+CUwhd
xjN5htGMMHL+45wrt96x5tXS7U3yNh91uhJkVnjPlYOiXq0u8XOIr8ETOKXAmYPq
rY7S+bASeZWOtQwNrKOeEvFO0lo5Me5IpLxlQ3bPN2RfmzjM9RWUzYj4uv1bVBIQ
98O634e2GkZqjWXHylmGRWSkUaHbBSWoE9UqWvYdGe03qhv4Z36ZWOAoDNuhfaoN
tUay6k8nubBoBQ5peEe8
=B9sz
-----END PGP SIGNATURE-----

--Sig_/k/EspPWTzP/8YpgndVhqCKN--
