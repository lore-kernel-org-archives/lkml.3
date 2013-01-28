Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3A1P6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:58:09 -0500
Received: from 8bytes.org ([85.214.48.195]:53041 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab3A1P6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:58:06 -0500
Date: Mon, 28 Jan 2013 16:58:02 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] ioapic-cleanups-for-v3.9
Message-ID: <20130128155757.GA3643@8bytes.org>
References: <20130125100040.GA13908@8bytes.org>
 <20130125104915.GB23332@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <20130125104915.GB23332@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jan 28 16:58:04 2013
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5106a00c22971968838755
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Fri, Jan 25, 2013 at 11:49:15AM +0100, Ingo Molnar wrote:
> Hm, there are some not so trivial looking conflicts in=20
> io_apic.c, due to the MSI patches I applied yesterday:
>=20
>  5ca72c4f7c41 AHCI: Support multiple MSIs
>  08261d87f7d1 PCI/MSI: Enable multiple MSIs with pci_enable_msi_block_aut=
o()
>  51906e779f2b x86/MSI: Support multiple MSIs in presense of IRQ remapping
>=20
> Could you please resolve them and resend?

Okay, I resolved the conflicts and tested the result again. Here it is:

The following changes since commit 5ca72c4f7c412c2002363218901eba5516c476b1:

  AHCI: Support multiple MSIs (2013-01-24 17:25:13 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/ioapic-=
cleanups-for-tip

for you to fetch changes up to a1bb20c232d066de0762f8e7cf332e5ce8385210:

  x86, irq: Move irq_remapped out of x86 core code (2013-01-28 12:51:52 +01=
00)

----------------------------------------------------------------
Cleanup X86 IOAPIC code from interrupt remapping details

These patches move all interrupt remapping specific checks out of the
x86 core code and replaces the respective call-sites with function
pointers. As a result the interrupt remapping code is better abstraced
=66rom x86 core interrupt handling code.

The code was rebased to v3.8-rc4 and tested on systems with AMD-Vi and
Intel VT-d (both capable of interrupt remapping). The systems were
tested with IOMMU enabled and with IOMMU disabled. No issues were found.

----------------------------------------------------------------
Joerg Roedel (19):
      x86, apic: Move irq_remapping_enabled checks into IRQ-remapping code
      x86, apic: Mask IO-APIC and PIC unconditionally on LAPIC resume
      x86, io_apic: Introduce x86_io_apic_ops.disable()
      x86, io_apic: Introduce x86_io_apic_ops.print_entries for debugging
      x86, hpet: Introduce x86_msi_ops.setup_hpet_msi
      x86, msi: Use IRQ remapping specific setup_msi_irqs routine
      x86, io_apic: Introduce set_affinity function pointer
      x86, io_apic: Convert setup_ioapic_entry to function pointer
      x86, io_apic: Move irq_remapping_enabled checks out of check_timer()
      x86, io_apic: Remove irq_remapping_enabled check in setup_timer_IRQ0_=
pin
      x86, irq: Move irq_remapping_enabled declaration to iommu code
      x86, irq: Add data structure to keep AMD specific irq remapping infor=
mation
      x86, io-apic: Move CONFIG_IRQ_REMAP code out of x86 core
      x86, io-apic: Remove !irq_remapped() check from __target_IO_APIC_irq()
      x86, irq: Move irq_remapped() check into free_remapped_irq
      x86, irq: Introduce setup_remapped_irq()
      x86, msi: Introduce x86_msi.compose_msi_msg call-back
      x86, io_apic: Introduce eoi_ioapic_pin call-back
      x86, irq: Move irq_remapped out of x86 core code

 arch/x86/include/asm/hpet.h          |    5 +-
 arch/x86/include/asm/hw_irq.h        |   13 +-
 arch/x86/include/asm/io_apic.h       |   28 +++
 arch/x86/include/asm/irq_remapping.h |   40 ++-
 arch/x86/include/asm/pci.h           |    3 +
 arch/x86/include/asm/x86_init.h      |   27 +-
 arch/x86/kernel/apic/apic.c          |   28 +--
 arch/x86/kernel/apic/io_apic.c       |  446 +++++++++++-------------------=
----
 arch/x86/kernel/hpet.c               |    2 +-
 arch/x86/kernel/x86_init.c           |   24 +-
 drivers/iommu/amd_iommu.c            |    8 +-
 drivers/iommu/dmar.c                 |    2 +
 drivers/iommu/intel-iommu.c          |    2 +
 drivers/iommu/intel_irq_remapping.c  |   12 +
 drivers/iommu/irq_remapping.c        |  231 +++++++++++++++++-
 drivers/iommu/irq_remapping.h        |    1 +
 include/linux/irq.h                  |    3 +
 17 files changed, 504 insertions(+), 371 deletions(-)

Please pull.

Thanks,

	Joerg


--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRBqAFAAoJECvwRC2XARrjyn8P/jpaDXLQklU8Wijapa8jYNjm
aN/5qlznHtDfJUf3Fi5D+qQv6G2gs2pl5zb8gz8Ei6ViQohxj3XhcZwc/e5rtI+c
tfOy2OjO2iRamjEHR+So+ZB/5pfvELxnUAsqZO3tc8QzxymVWrXYj+t1Xw1jXmW0
1cmRPWDrlmo5kYPNtPrAr1evhTMC0oH9Jac/+zxzi2LgorXQUsmvKKqTyuVC8qiE
3gAwKwm60Q76S9qPqF2PCfOXx8QSO3BvBgL4avTrtJ5cC9yKXeuqOPuu72BOHx4o
aSN/kkLbv9iukE6NZ76IPN4BBiVWrVBPu8VlW+xM5SgCM3cY0YvQaIDTUPAWDs4v
/Oxis2msmJ+hIJP/VXnXqRUaaBTTsAek9EcbyVxmDjOYYwJvb4kRZ8zS7APu69ng
1OgNUl5mrwH6aZoMZ2it5hOtGfhDtykAsYC9NdjbKEanQe1G8JlDovONBdliPC4n
bjZEA2u2QNh51bWqpEv+m229CnhE79/85UOFqBqF0UUa635BssOSvRUf+/6lZVyU
4pNhTOxNQBN3qcW7ZtxB1/6s4kV3SHst+xi8GFOTBCVGvP9YY8ZPiB9Iwq02Yoob
beTy/fPDkHM1hQ0UjrDjFz0gquwE4Uis3jSGRsdzw8BRyr/BIRwwBDuUfkiPG1wF
YMppGGvLdGiYeMZw+NmN
=MQ6Q
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--


