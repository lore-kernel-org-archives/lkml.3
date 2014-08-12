Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaHLSF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:05:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36664 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbaHLSF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:05:57 -0400
Message-ID: <53EA5782.1080301@canonical.com>
Date: Tue, 12 Aug 2014 20:05:54 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Xen PV domain regression with KASLR enabled (kernel
 3.16)
References: <53E4B281.5050302@canonical.com>	<53E4C5D5.2090103@citrix.com>	<53E4E042.1070300@canonical.com> <CAGXu5jJ+FTqgYpLH5x0VBm9QMND-b0Sze6q6pc=tRe2oFMu5uA@mail.gmail.com>
In-Reply-To: <CAGXu5jJ+FTqgYpLH5x0VBm9QMND-b0Sze6q6pc=tRe2oFMu5uA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="4KiKWNV9gPdUmxOPO7k3juhlsQ53wjJID"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4KiKWNV9gPdUmxOPO7k3juhlsQ53wjJID
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12.08.2014 19:28, Kees Cook wrote:
> On Fri, Aug 8, 2014 at 7:35 AM, Stefan Bader <stefan.bader@canonical.co=
m> wrote:
>> On 08.08.2014 14:43, David Vrabel wrote:
>>> On 08/08/14 12:20, Stefan Bader wrote:
>>>> Unfortunately I have not yet figured out why this happens, but can c=
onfirm by
>>>> compiling with or without CONFIG_RANDOMIZE_BASE being set that witho=
ut KASLR all
>>>> is ok, but with it enabled there are issues (actually a dom0 does no=
t even boot
>>>> as a follow up error).
>>>>
>>>> Details can be seen in [1] but basically this is always some portion=
 of a
>>>> vmalloc allocation failing after hitting a freshly allocated PTE spa=
ce not being
>>>> PTE_NONE (usually from a module load triggered by systemd-udevd). In=
 the
>>>> non-dom0 case this repeats many times but ends in a guest that allow=
s login. In
>>>> the dom0 case there is a more fatal error at some point causing a cr=
ash.
>>>>
>>>> I have not tried this for a normal PV guest but for dom0 it also doe=
s not help
>>>> to add "nokaslr" to the kernel command-line.
>>>
>>> Maybe it's overlapping with regions of the virtual address space
>>> reserved for Xen?  What the the VA that fails?
>>>
>>> David
>>>
>> Yeah, there is some code to avoid some regions of memory (like initrd)=
=2E Maybe
>> missing p2m tables? I probably need to add debugging to find the faili=
ng VA (iow
>> not sure whether it might be somewhere in the stacktraces in the repor=
t).
>>
>> The kernel-command line does not seem to be looked at. It should put s=
omething
>> into dmesg and that never shows up. Also today's random feature is oth=
er PV
>> guests crashing after a bit somewhere in the check_for_corruption area=
=2E..
>=20
> Right now, the kaslr code just deals with initrd, cmdline, etc. If
> there are other reserved regions that aren't listed in the e820, it'll
> need to locate and skip them.
>=20
> -Kees
>=20
Making my little steps towards more understanding I figured out that it i=
sn't
the code that does the relocation. Even with that completely disabled the=
re were
the vmalloc issues. What causes it seems to be the default of the upper l=
imit
and that this changes the split between kernel and modules to 1G+1G inste=
ad of
512M+1.5G. That is the reason why nokaslr has no effect.

-Stefan


--4KiKWNV9gPdUmxOPO7k3juhlsQ53wjJID
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT6leCAAoJEOhnXe7L7s6jBzUP/RDHfmYA+xIfirRb2P85W5Gl
v9IpJA9ItxGumXHosvT/lfjYYJZOY1m8enCs5jyfgOvoeIc27juvtIWby6h8beTk
4nI47GJi3m9nsxszBuJ6mhBmP6vK3tJhkeCeCsoZbZ+KoGReLy2nVG1RgjxpLPp/
8NRf9NnxgsjGrBkor5WRZkykcMngbT8nk10kswgGvIqq/wjApDWlRVv8QVbrQ94r
aMB40XufxVWyIVfm7EFq9vSkRNggCnLMtxhkOeFzQ20ylcvK8dYTsU438yJkiLm1
C69qIT8zD3OG3ej5+PHn/qiFuk+gIR43cvq15scHVw2xus9cElVMNZW2s+ccRvhA
KxGf3/00y3Fbmys7r6uMg04gVNnDsK/nZ2QGfZOFS3bjzUD+MlA9ONVCWOOiky44
JdnE11IKfs9zkES8o8fMszah0fqLtFUJ6goyPpKl1AfhJ/F6I2nTWMQnB7pgWkCB
VDBc7hqQQnAa/Hxq8IoXu5Di7Xal53oeVBH4b6QntAud9pDYTspiBFgHGuloV3Xu
Lcpdtge0Op0ljAPSTv9g4pVIa6hocRePeMIcXfeai+KGfmcDp0CZWTjBB6XpgpXR
I0bSO4f3FT1qz3trDNKsaDQcZYBSnC1qKrmgFcopybhIF3pWl4q21RXgMSlLXXcp
z4DyC6ipAu+760YGYeKs
=281R
-----END PGP SIGNATURE-----

--4KiKWNV9gPdUmxOPO7k3juhlsQ53wjJID--
