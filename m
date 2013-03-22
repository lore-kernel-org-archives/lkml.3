Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab3CVKf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:35:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34926 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab3CVKf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:35:27 -0400
Date: Fri, 22 Mar 2013 11:35:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AMD RAS improvements for v3.10
Message-ID: <20130322103519.GC30807@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

please pull the two improvements below; not urgent stuff, can go into
tip/x86/ras for 3.10.

Thanks.

The following changes since commit a937536b868b8369b98967929045f1df54234323:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/ras_for_next

for you to fetch changes up to bafcdd3b6cb86035cdb0511450961edcdc084c27:

  x86, MCE, AMD: Use MCG_CAP MSR to find out number of banks on AMD (2013-03-22 11:25:01 +0100)

----------------------------------------------------------------
Basically, the main reason for this is virtualization but it is also
correct, at the same time, to read out the number of supported banks
from hardware instead of having hardcoded defines. Which means it is a
nice cleanup for baremetal too.

----------------------------------------------------------------
Boris Ostrovsky (2):
      x86, MCE, AMD: Replace shared_bank array with is_shared_bank() helper
      x86, MCE, AMD: Use MCG_CAP MSR to find out number of banks on AMD

 arch/x86/kernel/cpu/mcheck/mce_amd.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
