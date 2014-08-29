Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaH2Ocm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:32:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56828 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaH2Ocl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:32:41 -0400
Message-ID: <54008F05.9090403@canonical.com>
Date: Fri, 29 Aug 2014 16:32:37 +0200
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
References: <20140827204940.GA10556@laptop.dumpdata.com> <1409248903-19625-1-git-send-email-stefan.bader@canonical.com> <53FFB045.9010809@citrix.com> <54003BE5.5010603@canonical.com> <54008BF2.5050905@citrix.com>
In-Reply-To: <54008BF2.5050905@citrix.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="c7blQgDphrGCfficsfEaQxjA75J1PECQb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--c7blQgDphrGCfficsfEaQxjA75J1PECQb
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 29.08.2014 16:19, Andrew Cooper wrote:
> On 29/08/14 09:37, Stefan Bader wrote:
>> On 29.08.2014 00:42, Andrew Cooper wrote:
>>> On 28/08/2014 19:01, Stefan Bader wrote:
>>>>>> So not much further... but then I think I know what I do next. Pro=
bably should
>>>>>> have done before. I'll replace the WARN_ON in vmalloc that trigger=
s by a panic
>>>>>> and at least get a crash dump of that situation when it occurs. Th=
en I can dig
>>>>>> in there with crash (really should have thought of that before)...=

>>>>> <nods> I dug a bit in the code (arch/x86/xen/mmu.c) but there is no=
thing there
>>>>> that screams at me, so I fear I will have to wait until you get the=
 crash
>>>>> and get some clues from that.
>>>> Ok, what a journey. So after long hours of painful staring at the co=
de...
>>>> (and btw, if someone could tell me how the heck one can do a mfn_to_=
pfn
>>>> in crash, I really would appreaciate :-P)
>>> The M2P map lives in the Xen reserved virtual address space in each P=
V
>>> guest, and forms part of the PV ABI.  It is mapped read-only, in the
>>> native width of the guest.
>>>
>>> 32bit PV (PAE) at 0xF5800000
>>> 64bit PV at 0xFFFF800000000000
>>>
>>> This is represented by the MACH2PHYS_VIRT_START symbol from the Xen
>>> public header files.  You should be able to blindly construct a point=
er
>>> to it (if you have nothing better to hand), as it will be hooked into=

>>> the guests pagetables before execution starts.  Therefore,
>>> "MACH2PHYS_VIRT_START[(unsigned long)pfn]" ought to do in a pinch.
>> machine_to_phys_mapping is set to that address but its not mapped insi=
de the
>> crash dump. Somehow vtop in crash handles translations. I need to have=
 a look at
>> their code, I guess.
>>
>> Thanks,
>> Stefan
>=20
> What context is the crash dump?  If it is a Xen+dom0 kexec()d to native=

> linux, then the m2p should still be accessible given dom0's cr3.  If it=

> is some state copied off-host then you will need to adjust the copy to
> include that virtual range.

No its a domU dump of a PV guest taken with "xl dump-core" (or actually t=
he
result of on-crash trigger).

>=20
> ~Andrew
>=20



--c7blQgDphrGCfficsfEaQxjA75J1PECQb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUAI8FAAoJEOhnXe7L7s6j88cP/26i7bJUXEJC5HpOwz0Q+Z8u
wR+gBaVe5zSekEgZQUF8qKg85gzCzWD9d4JgcEKKkIataHu0OjFT0c+3ji88f07a
Ush3rcKZmL/osZYERJivoNYL4nxoiz99PlQwoDjtBpnKvui8z6AdAFZTU12gJkvq
J1ihk/ltLwB5Y1jVUGks9X8DRQRs5Tav2MayN4ApmWVCHxWbqwpoBapdHottJfoy
LJtGr5XibXruf7v5Ba4m7GLQ7MFAwxKXi+lKTbCkz5jnA++Bjm5bmQUyjMPjnlXy
SQj4ByDkhCgP9mCK9huGgEFRI8xNDoCFX8/dFCeS6BBdCv/tiBRJVZpdQEEeD9gg
QvWAfyl/98sOvSKHOyAnw5aKP+dRnoeIVd8snaIcSxUD4xpKIQ6vUeTtg+ovhxBn
PJFEhYWpasAHVFJ9/1vX+wOlikaqCmMutIOdPwC5od1rpifEzJWl7tRuU7gk8J97
31rXqPRxm/ALkpY86iNjWdazn8DQYb8KpiTYGNy6YqaMKEUrWfnV9bNSVne3n5zt
DzLCSqSsP2VI1O3qOoyOMopm/td4MNxnNBnUYvjBrY87/FBjyzuJW2Jm0ZU7uIbr
oGyGKK/RzvOzxgopD7dJws+iWgThH+si+UO4cVnnVsqEB+8ZLS3VbymeLloK/gbm
BX7E2s78JqgQT5gfwvxh
=vel3
-----END PGP SIGNATURE-----

--c7blQgDphrGCfficsfEaQxjA75J1PECQb--
