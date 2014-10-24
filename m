Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbaJXJlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:41:46 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:55576 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505AbaJXJlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:41:17 -0400
Message-ID: <544A1EBA.70903@cantab.net>
Date: Fri, 24 Oct 2014 10:41:14 +0100
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xen.org" <Xen-devel@lists.xen.org>
Subject: [GIT PULL] xen: bug fixes for 3.18-rc1
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.18-b-rc1-tag

xen: bug fixes for 3.18-rc1

- - Fix regression in xen_clocksource_read() which caused all Xen guests
  to crash early in boot.
- - Several fixes for super rare race conditions in the p2m.
- - Assorted other minor fixes.

Thanks.

David

 arch/x86/xen/enlighten.c |    3 --
 arch/x86/xen/mmu.c       |    5 ++-
 arch/x86/xen/p2m.c       |   83 ++++++++++++++--------------------------------
 arch/x86/xen/setup.c     |    1 +
 arch/x86/xen/time.c      |    2 +-
 drivers/xen/balloon.c    |    3 ++
 drivers/xen/pci.c        |   27 +++++++++------
 7 files changed, 50 insertions(+), 74 deletions(-)

Boris Ostrovsky (3):
      xen/balloon: Don't continue ballooning when BP_ECANCELED is encountered
      x86/xen: Fix incorrect per_cpu accessor in xen_clocksource_read()
      xen/pci: Allocate memory for physdev_pci_device_add's optarr

Juergen Gross (3):
      x86/xen: avoid writing to freed memory after race in p2m handling
      x86/xen: delay construction of mfn_list_list
      x86/xen: avoid race in p2m handling

Martin Kelly (1):
      x86/xen: panic on bad Xen-provided memory map
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iQEcBAEBAgAGBQJUSh66AAoJEFxbo/MsZsTRduAIAJ/uO51ddrqjdsOl5owgWqol
nsE45ZQ2oiLfED22gsdZsph1EY0PizMN8Q0Ag/ISdX3a6manQiuLanhJ0WyLO9ow
FBUle7T3l8iW+Kutdpq2OpAP52i+KET+EB8zVqlzbeywlfTZbOpT98ZMe9WyRqMp
JEGGmMBVvxb8jItG3Yj1h3aX+hA1kDoVmmS7nzNKQ0CnCuK/RkG+C5VIRR696Lps
VUEgfw8N3bNzuKLmXUZ+g7CK+7LiDBDVCKemfUDDkE3dImNsLUTr2MpE73PVzH1X
CFIrbPNfjBD8MdMtIBmdbp3Nz37J0bIge5FUnq0jQhgdwh9dxdPYqSyi8VA79FE=
=EC6Z
-----END PGP SIGNATURE-----
