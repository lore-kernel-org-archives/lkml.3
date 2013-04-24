Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab3DXIXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:23:13 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:58715 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056Ab3DXIXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:23:08 -0400
Message-ID: <5177965D.9090406@linux.vnet.ibm.com>
Date: Wed, 24 Apr 2013 16:22:53 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: linuxppc-dev@lists.ozlabs.org, gang.chen@asianux.com
CC: linux-kernel@vger.kernel.org, benh <benh@kernel.crashing.org>,
        paulus@samba.org, mikey@neuling.org, matt@ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        sfr@canb.auug.org.au
Subject: "attempt to move .org backwards" still show up
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042408-5490-0000-0000-00000356E772
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I get an error message when I compile the source code in Power7 platform
use the newest upstream kernel.

[root@feng linux]# make -j60
CHK include/generated/uapi/linux/version.h
CHK include/generated/utsrelease.h
CC scripts/mod/devicetable-offsets.s
GEN scripts/mod/devicetable-offsets.h
HOSTCC scripts/mod/file2alias.o
CALL scripts/checksyscalls.sh
HOSTLD scripts/mod/modpost
CHK include/generated/compile.h
CALL arch/powerpc/kernel/systbl_chk.sh
CALL arch/powerpc/kernel/prom_init_check.sh
AS arch/powerpc/kernel/head_64.o
arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:258: Error: attempt to move .org
backwards
make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1
make: *** [arch/powerpc/kernel] Error 2
make: *** Waiting for unfinished jobs....

and I see this should be fixed by the commit:
087aa036eb79f24b856893190359ba812b460f45

But it still failed in my P7 machine.

the kernel source code info:
git tree : git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
[root@feng linux]# git log
commit 824282ca7d250bd7c301f221c3cd902ce906d731
Merge: f83b293 3b5e50e
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon Apr 22 15:00:59 2013 -0700

Merge branch 'upstream' of
git://git.linux-mips.org/pub/scm/ralf/upstream-linus

Pull MIPS fix from Ralf Baechle:
"Revert the change of the definition of PAGE_MASK which was prettier
but broke a few relativly rare platforms"

* 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus:
Revert "MIPS: page.h: Provide more readable definition for PAGE_MASK."

commit 3b5e50edaf500f392f4a372296afc0b99ffa7e70
Author: Ralf Baechle <ralf@linux-mips.org>
Date: Mon Apr 22 17:57:54 2013 +0200

[root@feng linux]# git branch
* master
[root@feng linux]# git diff
[root@feng linux]#

Thant means I have done nothing with the kernel

Thanks
Mike

