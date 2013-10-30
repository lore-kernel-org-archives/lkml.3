Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab3J3LiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:38:14 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:64594 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab3J3LiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:38:13 -0400
Message-ID: <5270EF9F.4040906@gmail.com>
Date: Wed, 30 Oct 2013 12:38:07 +0100
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>, ian.campbell@citrix.com,
        ross.philipson@citrix.com, stefano.stabellini@eu.citrix.com,
        The development of GNU GRUB <grub-devel@gnu.org>,
        david.woodhouse@intel.com, richard.l.maliszewski@intel.com,
        xen-devel@lists.xen.org, boris.ostrovsky@oracle.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        seth.goldberg@oracle.com, pjones@redhat.com,
        linux-kernel@vger.kernel.org, keir@xen.org, mjg59@srcf.ucam.org,
        shidokht.yadegari@oracle.com, neal.pollack@oracle.com,
        arvidjaar@gmail.com, mchang@suse.com, mchang.novell@gmail.com
Subject: Re: Is: Wrap-up Was: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl> <526599A8.9090501@gmail.com> <52663D54.2020800@gmail.com> <20131028162603.GA4716@phenom.dumpdata.com> <526EA686.70008@gmail.com> <526F7FC402000078000FD7BA@nat28.tlf.novell.com> <20131030111924.GE3425@debian70-amd64.local.net-space.pl>
In-Reply-To: <20131030111924.GE3425@debian70-amd64.local.net-space.pl>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2CKMTRABBCQAXXCGWNQKA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2CKMTRABBCQAXXCGWNQKA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 30.10.2013 12:19, Daniel Kiper wrote:
> Hi,
> multiboot2 protocol requires some more changes. However, about 80% of c=
ode
> is ready. In this case Xen and modules are loaded by GRUB2 itself. It m=
eans
> that all images could be placed on any filesystem recognized by GRUB2. =
Options
> for Xen and modules are passed separately which simplifies command line=
 editing
> in boot loader and parsing. multiboot2 protocol is very flexible and co=
uld be
> easily extended in the future if a need arises. Support for secure boot=
 and
> shim loader could be added. However, it was not implemented yet. Probab=
ly
> linuxefi module could be used as a reference or even as a base for deve=
lopment.
> However, I do not know are there plans to support such solution by GRUB=
2
> community. Currently, support for native PE images signatures and GPG s=
ignatures
> is under development for GRUB2 upstream.
>=20
GPG signatures are supported already. My plan is as follows:
- Implement PE signatures upstream.
- Uplift as much of secureboot to upstream as policy permits. I would
like to be in partnership over this with some distro people so that they
can carry remaining part (unless FSF allows secureboot per policy)
> There is still open question that ExitBootServices() should be called b=
y GRUB2
> loader or by loaded image itself on EFI platform. UEFI spec 2.4 states =
in many
> places that it is "OS loader" or "Operating System" responsibility. How=
ever,
> I think that "OS loader" should be understood as a integral piece of "O=
perating
> System" responsible for its load into memory without usage of any addit=
ional
> loader like GRUB2.
"Operating system" isn't just kernel. Everything you get in base install
is "Operating system" including i.a. shell or bootloader.
However this is kind of decision that couldn't be taken based on spec
alone. The bugs in real-world EFI implementations play more role in
design solutions that EFI specification.
> There is also third solution for issues with ExitBootServices(). In cas=
e
> of multiboot2 protocol OS could request that EFI should be left as is.
> Solution was proposed by Vladimir and I think that it makes sense.
I will write the specification draft for it then but probably not today.
> However,
> this does not solve problem with ExitBootServices() in case of other
> boot loaders/protocols.
multiboot2 was designed in a way not to be limited to GRUB2. It can be
added to other bootloaders as well.
> So we should take a decision accordingly to above
> considerations in regards to linux, chainloader and similar stuff.
>=20
> Daniel
>=20



------enig2CKMTRABBCQAXXCGWNQKA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iF4EAREKAAYFAlJw76AACgkQNak7dOguQgkcTQD9E/DuKgYPmB4xTi/KmHRKtmXF
kP+MFH+CHNG1vbCdMO4A/0+RaTXNTlstLoKNPkChVKrWthvF1TNE4dWY+NCbhWb0
=A7fV
-----END PGP SIGNATURE-----

------enig2CKMTRABBCQAXXCGWNQKA--
