Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaGNMJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:09:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:51737 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaGNMJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:09:33 -0400
Date: Mon, 14 Jul 2014 14:09:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kan.liang@intel.com, andi@firstfloor.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH V5 1/2] perf ignore LBR and extra_regs
Message-ID: <20140714120922.GV9918@twins.programming.kicks-ass.net>
References: <1404989984-3068-1-git-send-email-kan.liang@intel.com>
 <53C3C517.4000500@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GVLQrlG8+/jMfW4X"
Content-Disposition: inline
In-Reply-To: <53C3C517.4000500@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GVLQrlG8+/jMfW4X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 01:55:03PM +0200, Paolo Bonzini wrote:
> Il 10/07/2014 12:59, kan.liang@intel.com ha scritto:
> >From: Kan Liang <kan.liang@intel.com>
> >
> >x86, perf: Protect LBR and extra_regs against KVM lying
> >
> >With -cpu host, KVM reports LBR and extra_regs support, if the host has =
support.
> >When the guest perf driver tries to access LBR or extra_regs MSR,
> >it #GPs all MSR accesses,since KVM doesn't handle LBR and extra_regs sup=
port.
> >So check the related MSRs access right once at initialization time to av=
oid the error access at runtime.
> >
> >For reproducing the issue, please build the kernel with CONFIG_KVM_INTEL=
 =3D y (for host kernel).
> >And CONFIG_PARAVIRT =3D n and CONFIG_KVM_GUEST =3D n (for guest kernel).
>=20
> I'm not sure this is a useful patch.
>=20
> This is #GP'ing just because of a limitation in the PMU; just compile the
> kernel with CONFIG_PARAVIRT

How's that going to help? If you run kvm -host the VM is lying through
its teeth is the kernel is going to assume all those MSRs present,
PARAVIRT isn't going to help with this.

> , or split the "rdmsr is always rdmsr_safe"
> behavior out of CONFIG_PARAVIRT and into a new Kconfig symbol.

That's not useful either, because non of these code-paths are going to
check the return value.

> In fact there's no reason why LBR cannot be virtualized (though it does n=
eed
> support from the processor), and it may even be possible to support
> OFFCORE_RSP_X in the KVM virtual PMU.

But its not, so something needs to be done, right?

--GVLQrlG8+/jMfW4X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw8hyAAoJEHZH4aRLwOS68FAQAIIacaLPBxO9aW2JgkRwcEl6
/uh/tlTn9afDzMSuXyLYUnOupD6Dh1aUGTu7nO+k7PuFW/VwuwLFEPuBvOGid3IA
ASjeUYCaZdV6coeKVW3M48IXes/M2fACE2zfLwKkGlvMgI0NO5+MnPyFp6m+f8b4
8DQhvre99k/LPyDX5y/CqkyJSt25VfTZMTgJPbOjdqohZ/fG0Dd2g1vjuiOQ2kzw
4+7yT2vyWhcwFnkbhOdZ9ElQLrvawBAi5ojWeEm3n3TgcWEX1f/hN+3naP0x/tG/
TuIZB2753SGeMvcjD1fQzMNr8dekRAf0ibQ9vEf8WMvWeZosVuQU99YW9G6QrDMj
/rNZ9EJAnD1IEmEAZ0EwobFKgablOjSEqsFsUI9kIHcP7OVhRnofhS0hli2mHxvz
BOZsVGICKj+a63WuCgU8hLgNCPUhpqbCZ4/W/OTqUjmB0Uo7+FFcJWStC86AqC6S
oyNfS4Me0M1ZLaaq6buhVMoAMAVxge6M1mK7R2IPgGBG03aZzk/PEw0+rYd+Sn8A
TxKC3hmHRBYGBCwt3x//S9VmpbR/vo/srHi3F+yEaJc0BiuvdUC4z6PXuL3QDCv+
Vc4NMgQ9kzrqmHWL8mIGmktuhkS2IYcQZM2qiwXgGcQ66gzl/r2H1gq4lkWHIcXb
10Tepuh3VCmFqZZRVly5
=PAvU
-----END PGP SIGNATURE-----

--GVLQrlG8+/jMfW4X--
