Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbaGFPtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 11:49:23 -0400
Received: from mout.web.de ([212.227.15.14]:59329 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbaGFPtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 11:49:21 -0400
Message-ID: <53B96FF5.2050107@web.de>
Date: Sun, 06 Jul 2014 17:49:09 +0200
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
References: <53B7ADAA.9030101@web.de> <20140706151242.GN18167@minantech.com> <53B96A2B.4040909@web.de> <20140706154112.GO18167@minantech.com>
In-Reply-To: <20140706154112.GO18167@minantech.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="awM8XJ4RqIFVt8NSsbERFb45wPQ1MiIDK"
X-Provags-ID: V03:K0:M/GI8NqqG3g2Tcnfbf4v8w7REnHz6FKfPEgBYjLoqk37x0zbUxF
 Y991x862HVp3US0K3i5Np0tpVktOK6JYt5E046F/eezxCE+yvEkl4JqQTztWP6vqXMAyC2n
 /yWzQBSUrpef6SuQXcjG2SvXFHgHrWYiA3M0VdfxrORN4VWfcXGIgf/Wr6arCoziuve9IWe
 JRfktrdUcPPxu6gxAYAqA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--awM8XJ4RqIFVt8NSsbERFb45wPQ1MiIDK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-07-06 17:41, Gleb Natapov wrote:
> On Sun, Jul 06, 2014 at 05:24:27PM +0200, Jan Kiszka wrote:
>> On 2014-07-06 17:12, Gleb Natapov wrote:
>>> On Sat, Jul 05, 2014 at 09:47:54AM +0200, Jan Kiszka wrote:
>>>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>>>
>>>> We are able to use x2APIC mode in the absence of interrupt remapping=
 on
>>>> certain hypervisors. So it if fine to disable IRQ_REMAP without havi=
ng
>>>> to give up x2APIC support.
>>> FWIW I did similar thing back when I added x2apic to KVM:
>>> http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-06/msg14579.html=

>>> But was advised against it.
>>
>> I don't get the point from that thread.
> It is not architectural to use x2apic without irq remapping, so Suresh

Slightly off-topic for this patch: Is this dependency documented
somewhere? I guess there are broken systems where it can fail, but none
of the (Intel) boxes I tried so far had problems with x2APIC mode on
(given APIC IDs < 255) and IRQ remapping disabled.

> from Intel felt that it should not be allowed to create a kernel that
> can run on real HW and has non architectural configuration compiled in,=

> though only when running on a VM x2apic will ever be enabled without ir=
q
> remapping. I didn't argue about it to much back then. If HYPERVISOR_GUE=
ST
> guaranties that resulting kernel can run only on a VM (does it?) this
> objection does not hold any more.

Yes, indeed. Your patch suggested to remove the dependency, this one
preserves it. There will still be no real hardware able to turn on
x2APIC without IRQ remapping enabled as well (though I'm hoping to
overcome this for Jailhouse scenarios until we can hand over DMAR units
from Linux to the hypervisor).

Jan



--awM8XJ4RqIFVt8NSsbERFb45wPQ1MiIDK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlO5b/UACgkQitSsb3rl5xRdGQCdFpZdtHB6FkRgi/3sVVi3tLjg
2MoAmwfa7QaJrboxmomEHGFFV7Rs6SYD
=WxiA
-----END PGP SIGNATURE-----

--awM8XJ4RqIFVt8NSsbERFb45wPQ1MiIDK--
