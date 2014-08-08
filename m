Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbaHHOfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:35:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37981 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbaHHOft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:35:49 -0400
Message-ID: <53E4E042.1070300@canonical.com>
Date: Fri, 08 Aug 2014 16:35:46 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Kees Cook <keescook@chromium.org>
Subject: Re: [Xen-devel] Xen PV domain regression with KASLR enabled (kernel
 3.16)
References: <53E4B281.5050302@canonical.com> <53E4C5D5.2090103@citrix.com>
In-Reply-To: <53E4C5D5.2090103@citrix.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="x0qLLSxA4EmVvK2TwaoNQoOHNIAXJ7Tbs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x0qLLSxA4EmVvK2TwaoNQoOHNIAXJ7Tbs
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08.08.2014 14:43, David Vrabel wrote:
> On 08/08/14 12:20, Stefan Bader wrote:
>> Unfortunately I have not yet figured out why this happens, but can con=
firm by
>> compiling with or without CONFIG_RANDOMIZE_BASE being set that without=
 KASLR all
>> is ok, but with it enabled there are issues (actually a dom0 does not =
even boot
>> as a follow up error).
>>
>> Details can be seen in [1] but basically this is always some portion o=
f a
>> vmalloc allocation failing after hitting a freshly allocated PTE space=
 not being
>> PTE_NONE (usually from a module load triggered by systemd-udevd). In t=
he
>> non-dom0 case this repeats many times but ends in a guest that allows =
login. In
>> the dom0 case there is a more fatal error at some point causing a cras=
h.
>>
>> I have not tried this for a normal PV guest but for dom0 it also does =
not help
>> to add "nokaslr" to the kernel command-line.
>=20
> Maybe it's overlapping with regions of the virtual address space
> reserved for Xen?  What the the VA that fails?
>=20
> David
>=20
Yeah, there is some code to avoid some regions of memory (like initrd). M=
aybe
missing p2m tables? I probably need to add debugging to find the failing =
VA (iow
not sure whether it might be somewhere in the stacktraces in the report).=


The kernel-command line does not seem to be looked at. It should put some=
thing
into dmesg and that never shows up. Also today's random feature is other =
PV
guests crashing after a bit somewhere in the check_for_corruption area...=


-Stefan


--x0qLLSxA4EmVvK2TwaoNQoOHNIAXJ7Tbs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT5OBCAAoJEOhnXe7L7s6jhp4QANCkgwd5l8hgydbxAQSla3B1
oxH9CHRngjqicYSgaV74TsLNSavyoG0vM7gw2b0GUXWT0jv3Bq/ouXjAE+Scy3Ic
ZWUcWsxfEVeU3OTTmmFiyXuCPoW8ZhETyxsAncQnWZtuY7c/ciXlcWnxmyzIpt2J
QXZEYNND1+iMgQz4Z40zaEJVEoxnSKIdU5GEAne4vgELr9qVnNjzVD/vsvMGXkoB
j1LnKiLHTE1YQt27G/GuPMlJA5iDXwCzgGleSbsFIYxc3idUxmhfu9k0OW9HpwFb
9q1hUTTNQja3KSnauAyjZMDa/Vv9mpEkg7pJ6q7/qUFLzUVZ4QJEVSsNnk2ejb9S
AIXXogiUSNEVih/qHtBn5JpqTNlse9blUZKVPpzLQMb/v9Mr8CIG58XdXu9GHMLy
qwOttEMbbC5WiYxz8nXqFWMjrjsIGW/u577J4dB1ZrUm5Bcr2Ru+CYm5gZosKrUS
tBR+OGlFNI/VjfeQyO0i4if5CwhcxSxGHHhl4QFXRil1Pzkl/9v3TUJC93qGAW19
NGglrSae9L/AzuodF/67TDhlqp4yib5xjni1q2mZJoBaCxNkuOlY9BulYsnrcOKY
SB6H9rhWCvNxM5RibaacLiiDz3KNJ/ceyctI5d9iJful2wVSidHHcmYPS0AUkMxA
lUzt9mun0httOWv3VyV0
=ZmHC
-----END PGP SIGNATURE-----

--x0qLLSxA4EmVvK2TwaoNQoOHNIAXJ7Tbs--
