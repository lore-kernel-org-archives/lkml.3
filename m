Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaAXW6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 17:58:55 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:60362 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaAXW6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 17:58:53 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>
Date: Fri, 24 Jan 2014 14:58:45 -0800
Message-ID: <8761p9rnq2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+iz+2hxFL0ABbmGmXJdOBnZRtcfHF+Auc=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0695]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [GIT PULL] user namespaces work for 3.14-rc1
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the for-linus branch from the git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

   HEAD: f58437f1f9161847c636e4fed5569ed5b908af36 MIPS: VPE: Remove vpe_getuid and vpe_getgid

The work to convert the kernel to use kuid_t and kgid_t has been
finished since 3.12 so it is time to remove the scaffolding that allowed
the work to progress incrementally.

The first patch on this branch just removes the scaffolding, ensuring we
will always get compile errors if people accidentally try the userspace
and the kernel uid and gid types.  The second patch an overlooked and
unused chunk of mips code that that fails to build after the first
patch.

The code hasn't been in linux-next for long (as I was out of it and could
not sheppared the cold properly) but the patch has been around for a
long time just waiting for the day when I had finished the uid/gid
conversions.  Putting the code in linux-next did find the compile
failure on mips so I took the time to get that fix reviewed and
included.  Beyond that I am not too worried about errors because all
these two patches do is delete a modest amount of code.

Eric


Eric W. Biederman (2):
      userns:  userns: Remove UIDGID_STRICT_TYPE_CHECKS
      MIPS: VPE: Remove vpe_getuid and vpe_getgid

 arch/mips/include/asm/vpe.h |    2 --
 arch/mips/kernel/vpe.c      |   28 ----------------------------
 include/linux/posix_acl.h   |    3 ---
 include/linux/projid.h      |   15 ---------------
 include/linux/uidgid.h      |   22 ----------------------
 init/Kconfig                |   11 -----------
 6 files changed, 0 insertions(+), 81 deletions(-)


