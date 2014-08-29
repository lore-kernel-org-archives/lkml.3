Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaH2IiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:38:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54962 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaH2IiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:38:03 -0400
Message-ID: <54003BE5.5010603@canonical.com>
Date: Fri, 29 Aug 2014 10:37:57 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Cooper <andrew.cooper3@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kees Cook <keescook@chromium.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH] Solved the Xen PV/KASLR riddle
References: <20140827204940.GA10556@laptop.dumpdata.com> <1409248903-19625-1-git-send-email-stefan.bader@canonical.com> <53FFB045.9010809@citrix.com>
In-Reply-To: <53FFB045.9010809@citrix.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="FfPhrhQwwvLQ4SqP7kVUuFRjXOrLM98Ga"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FfPhrhQwwvLQ4SqP7kVUuFRjXOrLM98Ga
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 29.08.2014 00:42, Andrew Cooper wrote:
> On 28/08/2014 19:01, Stefan Bader wrote:
>>>> So not much further... but then I think I know what I do next. Proba=
bly should
>>>> have done before. I'll replace the WARN_ON in vmalloc that triggers =
by a panic
>>>> and at least get a crash dump of that situation when it occurs. Then=
 I can dig
>>>> in there with crash (really should have thought of that before)...
>>> <nods> I dug a bit in the code (arch/x86/xen/mmu.c) but there is noth=
ing there
>>> that screams at me, so I fear I will have to wait until you get the c=
rash
>>> and get some clues from that.
>> Ok, what a journey. So after long hours of painful staring at the code=
=2E..
>> (and btw, if someone could tell me how the heck one can do a mfn_to_pf=
n
>> in crash, I really would appreaciate :-P)
>=20
> The M2P map lives in the Xen reserved virtual address space in each PV
> guest, and forms part of the PV ABI.  It is mapped read-only, in the
> native width of the guest.
>=20
> 32bit PV (PAE) at 0xF5800000
> 64bit PV at 0xFFFF800000000000
>=20
> This is represented by the MACH2PHYS_VIRT_START symbol from the Xen
> public header files.  You should be able to blindly construct a pointer=

> to it (if you have nothing better to hand), as it will be hooked into
> the guests pagetables before execution starts.  Therefore,
> "MACH2PHYS_VIRT_START[(unsigned long)pfn]" ought to do in a pinch.

machine_to_phys_mapping is set to that address but its not mapped inside =
the
crash dump. Somehow vtop in crash handles translations. I need to have a =
look at
their code, I guess.

Thanks,
Stefan
>=20
> ~Andrew
>=20



--FfPhrhQwwvLQ4SqP7kVUuFRjXOrLM98Ga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUADvlAAoJEOhnXe7L7s6j928P/3AkixruqkH5tbBfeIE0bxLn
yVFIuX+DXjDptzX6PLHyQw7rYkzQX7YJDkVxQEeYsAAK49USh4P66MJDORnNvo3h
ZFSrPxs7Oa6xrL9KNeb78DLQAJUTpb9U/enc+ozxRo4KC7tsY5BSbTWLPuLuay03
XEcrmPhdHNzRumMC2utVUhu+84Q4tgixF082CY5whAs6Kwa6J4Owhp3qFVB5Z+fp
yFAakiltWpGjB8UcGsvl9hNs4qeh+5REslD8juEg3P5eSbOD1iLxOVJB+lf9WXKn
+NGGatlEOHiH4XJAU5Tx77K62pSwDuELx7NYmE92BNYZrSdJVCN84TMHvjduMMiD
GiASkOSMGrFSLy2iZ8oD7kxK6NWnVsZH0/B0DlPZUzdkFcdluM+dJRiY/32uQJxS
vWnGtzPVPweZrB9mN1Yswweq2R0Nzp6IOGSZ5yGUohtiORrX11UMxxmBSLcn3ibj
jtB6D3m4lKiTwP2yCHPWuEezcXP4ZUWRccfd1WbI4xk+BPR5ohy+58cIpzfJtu/E
6YJqspjcz7DZusFmny5oYvqkKgIEHAGM+pr8Fy0SN1+E9Jgm6u22J6LNp+an5ele
wco4lZi5hb8jBxNqJ+0a9aicIdxW1nh67H6Lq/3f25ry1rEIcFzvB5ZxR2sQv+fu
TEn23xeqT42fwAQTm1IT
=Lg9s
-----END PGP SIGNATURE-----

--FfPhrhQwwvLQ4SqP7kVUuFRjXOrLM98Ga--
