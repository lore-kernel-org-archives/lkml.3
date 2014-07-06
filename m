Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaGFPZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 11:25:53 -0400
Received: from mout.web.de ([212.227.15.3]:54576 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbaGFPZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 11:25:51 -0400
Message-ID: <53B96A2B.4040909@web.de>
Date: Sun, 06 Jul 2014 17:24:27 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86: Make x2APIC support depend on interrupt remapping
 or guest support
References: <53B7ADAA.9030101@web.de> <20140706151242.GN18167@minantech.com>
In-Reply-To: <20140706151242.GN18167@minantech.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="bfuJHuw70tFtSQuRbJBQu9K9xb0IaHQov"
X-Provags-ID: V03:K0:5s5IHL8/lZW6jQfVD4XM/Z21AUykGzoHissB09PuKOiJbmEKXrL
 ghY/Jm4fhd9eDs1lnAIQDj+Wlgbz2T81CXOjBAb5QNmsR7IKSAjoPWdJqAeYjZE0lbkSlqj
 urqqsH0iR6NUyBWnAY1w8c+5n2MBAdBpY428HwB9OHsDpqvxQMpCezI0TeQH5DhLHDN5tnk
 P2kPdv9RII+o1eLj1P74Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bfuJHuw70tFtSQuRbJBQu9K9xb0IaHQov
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-07-06 17:12, Gleb Natapov wrote:
> On Sat, Jul 05, 2014 at 09:47:54AM +0200, Jan Kiszka wrote:
>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>
>> We are able to use x2APIC mode in the absence of interrupt remapping o=
n
>> certain hypervisors. So it if fine to disable IRQ_REMAP without having=

>> to give up x2APIC support.
> FWIW I did similar thing back when I added x2apic to KVM:
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-06/msg14579.html
> But was advised against it.

I don't get the point from that thread.

However, this change is just formalizing a configuration that is already
being used: there is no interrupt remapping available with KVM (yet),
but we do run our guests in x2APIC mode most of the time. Interrupt
remapping code in kernels tailored as KVM guest is dead code, right now.

Jan

>=20
>>
>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>> ---
>>  arch/x86/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index a8f749e..30a9987 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -310,7 +310,7 @@ config SMP
>> =20
>>  config X86_X2APIC
>>  	bool "Support x2apic"
>> -	depends on X86_LOCAL_APIC && X86_64 && IRQ_REMAP
>> +	depends on X86_LOCAL_APIC && X86_64 && (IRQ_REMAP || HYPERVISOR_GUES=
T)
>>  	---help---
>>  	  This enables x2apic support on CPUs that have this feature.
>> =20
>>
>>
>=20
>=20
>=20
> --
> 			Gleb.
>=20



--bfuJHuw70tFtSQuRbJBQu9K9xb0IaHQov
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlO5ai0ACgkQitSsb3rl5xRvaACfSR8fN4+9TTpBNpSEjUcUAlwB
ceEAnjykP+L1tJ3RWVNgYQ+OFd/6HiJX
=WLTj
-----END PGP SIGNATURE-----

--bfuJHuw70tFtSQuRbJBQu9K9xb0IaHQov--
