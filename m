Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbbAMLe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:34:26 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38871 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbbAMLeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:34:22 -0500
Message-ID: <54B502AF.6060209@cantab.net>
Date: Tue, 13 Jan 2015 11:34:07 +0000
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xenproject.org>
Subject: [GIT PULL] xen: bug fixes for 3.19-rc4
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.19-rc4-tag

xen: bug fixes for 3.19-rc4

- - Several critical linear p2m fixes that prevented some hosts from
  booting.

Thanks.

David

 arch/x86/xen/enlighten.c    |   22 ++++++++++++++++++-
 arch/x86/xen/p2m.c          |   20 ++++++++---------
 arch/x86/xen/setup.c        |   42 +++++++++++++++++------------------
 arch/x86/xen/time.c         |   18 +++++----------
 include/xen/interface/nmi.h |   51 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 107 insertions(+), 46 deletions(-)

Boris Ostrovsky (2):
      x86/xen: Remove unnecessary BUG_ON(preemptible()) in xen_setup_timer()
      x86/xen: Free bootmem in free_p2m_page() during early boot

David Vrabel (2):
      x86/xen: don't count how many PFNs are identity mapped
      x86/xen: add extra memory for remapped frames during setup

Jan Beulich (1):
      x86/xen: properly retrieve NMI reason

Juergen Gross (4):
      xen: correct error for building p2m list on 32 bits
      xen: correct race in alloc_p2m_pmd()
      xen: use correct type for physical addresses
      xen: check for zero sized area when invalidating memory

Vitaly Kuznetsov (1):
      x86/xen: avoid freeing static 'name' when kasprintf() fails
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJUtQKvAAoJEFxbo/MsZsTR4VgH/ici+0ZkcYTBmBgFv+qflEx0
8xHDj95Pw2y+6Pd7hcbZGyPjR3YEL5wXUIRUsDuQUxvcwY1Tu1nCHbcbxTz7beX6
A+yboAb0f+lLTge3POHhHGoNMcmMZI+80hAq8WaJEjk2JPJM+HFT5koexUraukLg
/LofEWwExcf5t+Ve09UJ5EyX7MAmZqBIrmzkJ+J5KT1qDMaq6gT1TM8Ys5Xa8HJ0
+/YLy04QTH1CJyIHUWomfWwYs6SNh/QuOyXmLMpeCSXqwrbXRdEA9cjze+vr53oD
pu+czGVaArfsXFtS1Y/h7h7iGHlKt4CRfMa4O1R/FctLJjfp4F2ReurDixPkgXg=
=72Zr
-----END PGP SIGNATURE-----
