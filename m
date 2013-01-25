Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab3AYKAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:00:48 -0500
Received: from 8bytes.org ([85.214.48.195]:49370 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab3AYKAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:00:45 -0500
Date: Fri, 25 Jan 2013 11:00:41 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull] ioapic-cleanups-for-v3.9
Message-ID: <20130125100040.GA13908@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jan 25 11:00:43 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 510257cb22971538623520
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

  Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/ioapic-=
cleanups-for-v3.9

for you to fetch changes up to 91b7344672ed72355624415e036f117782c5809c:

  x86, irq: Move irq_remapped out of x86 core code (2013-01-24 18:29:33 +01=
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
 arch/x86/include/asm/irq_remapping.h |   40 ++--
 arch/x86/include/asm/pci.h           |    2 +
 arch/x86/include/asm/x86_init.h      |   27 ++-
 arch/x86/kernel/apic/apic.c          |   28 ++-
 arch/x86/kernel/apic/io_apic.c       |  370 +++++++++++++-----------------=
----
 arch/x86/kernel/hpet.c               |    2 +-
 arch/x86/kernel/x86_init.c           |   24 ++-
 drivers/iommu/amd_iommu.c            |    8 +-
 drivers/iommu/dmar.c                 |    2 +
 drivers/iommu/intel-iommu.c          |    2 +
 drivers/iommu/intel_irq_remapping.c  |   12 ++
 drivers/iommu/irq_remapping.c        |  176 +++++++++++++++-
 drivers/iommu/irq_remapping.h        |    1 +
 16 files changed, 439 insertions(+), 301 deletions(-)

Please pull.

Thanks,

	Joerg


--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRAlfIAAoJECvwRC2XARrjcwkP/1vS+5dP1kEb1tDCy3ACCDDO
YpbyDLhPfI/zFqUUt/p7vlcOkjQokmOXc3SXKajHqO0lcBO9Y0oH4D0V1WgEWgQw
fDrzt6w2S2vFUz3Q/izFoyGiG2G8I4rLUG/Oigf1jYvwGn0Uc6y6tPuMKlwiV+/b
TsnWNFdBcrLlblhOTkdNAhfTpJZ0LmTNGuzx67x7zuFCnpszFgm7J2zwZ01RfAUs
ZLmmH2p1im+u0KiNeVRtSjBKGaFYqkKKoGhJBaKegkam6krFmLPFpH7yLXfMMZgE
j7b/VvpLJtR0/dOjUJE4XDT421m5hma1wQHiOvgHiiNo9i+tJAt13s21Rjzs5Dhm
Tc+NnrqupPo4o2boo2JNiM0Rj4go/uM+zeXO5zQ5XUMqhopQ0FCj3KKQ7GfSA51C
xwOtYOEzOQ5UPiaeRCRLVJxpnbDAShmbIiIUw3pHvyneAf67ITEPGwTJ/KnmsCLB
YnJcUE9fAScJZv//N2uhCksq52XLMjH1TZ46cizL48hKjJEGD/sJoXh36MoaR2OQ
DtT/aFXRRhnyW2lthcnMqwvemALvtkVDnFSeLtn5z8NXnDiq9oT8mE/fXhYo1gjV
Rpo2UTiEhcU2Z7mXSTXGgYBKdvyhaHTN4+YQlV93AxyB8nzEWm/VmHZ37K+Lxj0q
ViwvHeYG3lCNOfPpN4Mz
=SeC9
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--


