Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbaIKNHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:07:19 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40431 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbaIKNHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:07:15 -0400
Message-ID: <54119D26.6060000@cantab.net>
Date: Thu, 11 Sep 2014 14:01:26 +0100
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xen.org" <Xen-devel@lists.xen.org>
Subject: [GIT PULL] xen: bug fixes for 3.17-rc4
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

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.17-b-rc4-tag

xen: bug fixes for 3.17-rc4

- - Fix for PVHVM suspend/resume and migration
- - Don't pointlessly retry certain ballooning ops
- - Fix gntalloc when grefs have run out.
- - Fix PV boot if KSALR is enable or very large modules are used.

Thanks.

David

 arch/x86/include/asm/pgtable_64.h |    1 +
 arch/x86/xen/mmu.c                |   27 ++++++++++++---------------
 drivers/xen/balloon.c             |    4 ++--
 drivers/xen/gntalloc.c            |   16 +++++++---------
 drivers/xen/manage.c              |    7 -------
 5 files changed, 22 insertions(+), 33 deletions(-)

David Vrabel (3):
      xen/balloon: cancel ballooning if adding new memory failed
      xen/gntalloc: fix oops after runnning out of grant refs
      xen/gntalloc: safely delete grefs in add_grefs() undo path

Ross Lagerwall (1):
      xen/manage: Always freeze/thaw processes when suspend/resuming

Stefan Bader (1):
      x86/xen: don't copy bogus duplicate entries into kernel page tables
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iQEcBAEBAgAGBQJUEZ0mAAoJEFxbo/MsZsTRHlsH/ib9FwgIyUy8D3oUaIe39CmJ
6epyIN7XKvAH+h8XrF3TYQ03JrfnswS7x4cb4vKG6mU2wnRcEO4stLVdcMKbOQV5
IP3LOoslDjlWcVycOfBoxBcyGTrzxj7CS3u4Bj8dnyLp9m0iK5xr9kw94ynUiRRA
oy6Gae7y0XSgQfJ540ip4fC/N0AsC/FoThv0RtNvZ0csEcftXslTSYOUS5hHdTUm
EbFfcTKrsS3rkW6kvo3Xn7+NsFtUxamiBEA4LyInc/HaEi06iQO8+06aXjsia9Uj
ptOU+fJvnip+KWFWmbb683NZvclLrewRSd1ZuNQGh6DnkwbZCi4KsmCYk2wo61w=
=pjw1
-----END PGP SIGNATURE-----
