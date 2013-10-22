Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab3JVQYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:24:19 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:33180 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab3JVQYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:24:17 -0400
Message-ID: <5266A6AD.90004@gmail.com>
Date: Tue, 22 Oct 2013 18:24:13 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: The development of GNU GRUB <grub-devel@gnu.org>
CC: Daniel Kiper <daniel.kiper@oracle.com>,
        "Woodhouse, David" <david.woodhouse@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, "keir@xen.org" <keir@xen.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Jan Beulich <JBeulich@suse.com>,
        "ross.philipson@citrix.com" <ross.philipson@citrix.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021185758.GD3626@debian70-amd64.local.net-space.pl> <1382433990.1657.66.camel@hastur.hellion.org.uk> <5266620602000078000FCA48@nat28.tlf.novell.com> <1382435127.1657.70.camel@hastur.hellion.org.uk> <526668A502000078000FCA7B@nat28.tlf.novell.com> <20131022134252.GA27302@phenom.dumpdata.com> <20131022144309.GA18547@phenom.dumpdata.com> <1382455537.8512.11.camel@shinybook.infradead.org> <20131022153258.GA12260@srcf.ucam.org> <1382456560.8512.24.camel@shinybook.infradead.org> <20131022160146.GH3626@debian70-amd64.local.net-space.pl>
In-Reply-To: <20131022160146.GH3626@debian70-amd64.local.net-space.pl>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2VDXAXADCXHQMXLBGHNUR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2VDXAXADCXHQMXLBGHNUR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 22.10.2013 18:01, Daniel Kiper wrote:
> On Tue, Oct 22, 2013 at 03:42:42PM +0000, Woodhouse, David wrote:
>> On Tue, 2013-10-22 at 16:32 +0100, Matthew Garrett wrote:
>>>
>>> There are two problems with this:
>>>
>>> 1) The kernel will only boot if it's signed with a key in db, not a k=
ey
>>> in MOK.
>>> 2) grub will read the kernel, but the kernel will have to read the
>>> initramfs using EFI calls. That means your initramfs must be on a FAT=

>>> partition.
>>>
>>> If you're happy with those limitations then just use the chainloader
>>> command. If you're not, use the linuxefi command.
>>
>> Well, we're talking about booting the Xen hypervisor aren't we?
>>
>> So yes, there are reasons the Linux kernel uses the 'boot stub' the wa=
y
>> it does, but I'm not sure we advocate that Xen should emulate that in
>> all its 'glory'?
>=20
> Right, I think that sensible mixture of multiboot2 protocol (it is need=
ed
> to pass at least modules list to Xen; IIRC, linuxefi uses Linux Boot pr=
otocol
> for it) with extension proposed by Vladimir and something similar to li=
nuxefi
> command will solve our problem (I proposed it in my first email). Users=
 which
> do not need SB may use upstream GRUB2 and others could use
> 'multiboot2efi extension'.
I think it's possible to handle secureboot with same multiboot2 base.
Correct me if I'm wrong but secureboot doesn't specify format of
signaatures, only that they should be present and checked.
So why not to make that the only difference between secureboot-enabled
and not-secureboot-enabled versions is that former enforces signatures
even against user will. This will reduce the policy-charger patch to
about 100 lines.
The signature format to use can be discussed as well. My main problem
with pe signatures as used for EFI is their apparent complexity but I
haven't looked in them yet.
>=20
> Daniel
>=20
> _______________________________________________
> Grub-devel mailing list
> Grub-devel@gnu.org
> https://lists.gnu.org/mailman/listinfo/grub-devel
>=20



------enig2VDXAXADCXHQMXLBGHNUR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iF4EAREKAAYFAlJmpq0ACgkQNak7dOguQgmjPQD/QvpFbxryySxWsDEYSz/PwDn1
Yq2TrGoBR6eqYv5yhdcA/0s2xKLqemGCioesN4i3X/JgQq1zVIsBvC5pGnZHTEZR
=8ug+
-----END PGP SIGNATURE-----

------enig2VDXAXADCXHQMXLBGHNUR--
