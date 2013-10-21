Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3JULZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 07:25:48 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:54233 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab3JULZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 07:25:46 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 0/2] percpu: remove this_cpu_xor()
Date: Mon, 21 Oct 2013 13:25:35 +0200
Message-Id: <1382354737-59872-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.3.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102111-4966-0000-0000-0000073EA546
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While optimizing and testing s390's this_cpu ops I realized that
this_cpu_xor() generates broken code ("or" instead of "xor").

Since there is not a single user in the whole kernel tree it seems
to be a good opportunity to simply remove it instead of fixing it.

These two patches only remove the generic and x86 variant. It doesn't
touch s390 since it would only generate a merge conflict later on.
I will take care of s390 anyway if the consensus is that it should be
removed.

Heiko Carstens (2):
  percpu: remove this_cpu_xor() implementation
  x86: remove this_cpu_xor() implementation

 arch/x86/include/asm/percpu.h |  8 --------
 include/linux/percpu.h        | 32 --------------------------------
 2 files changed, 40 deletions(-)

-- 
1.8.3.4

