Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaHFMzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:55:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850AbaHFMzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:55:50 -0400
From: Mel Gorman <mgorman@suse.de>
To: H Peter Anvin <hpa@zytor.com>, Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Galbraith <mgalbraith@suse.de>, Linux-X86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 0/3] Reduce length of the eagerfpu path during x86 context switches
Date: Wed,  6 Aug 2014 13:55:45 +0100
Message-Id: <1407329748-3928-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eager FPU switching is used on CPUs that support xsave on the grounds
that CPUs that support it can optimise the switch with xsaveopt and xrstor
instead of serialising by updating cr0.TS which has serialising semantics.

The path for eagerfpu is fatter than it needs to be because it still
maintains the fpu_counter for lazy FPU switches even though the information
is never used. This patch splits the paths optimises the eagerfpu path a
little. The benefit is marginal, it was just noticed when looking at why
integer-only workloads were spending time saving/restoring FPU states.

 arch/x86/include/asm/fpu-internal.h | 46 +++++++++++++++++++++++++++++--------
 arch/x86/kernel/process_32.c        |  2 +-
 arch/x86/kernel/process_64.c        |  2 +-
 3 files changed, 38 insertions(+), 12 deletions(-)

-- 
1.8.4.5

