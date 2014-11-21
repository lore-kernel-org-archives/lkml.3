Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbaKUQYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:24:43 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59825 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaKUQYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:24:42 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v2 0/2] arm+arm64: perf: Prevent wraparound during overflow
Date: Fri, 21 Nov 2014 16:24:25 +0000
Message-Id: <1416587067-3220-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416412346-8759-1-git-send-email-daniel.thompson@linaro.org>
References: <1416412346-8759-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes problems on arm and arm64 when the PMU counters wrap
around and become larger than the value originally programmed into them.

The problem was observed and fixed on arm but the perf code is,
rather to my surprise, sufficiently similar on arm64 that the fix still
makes sense there too.

v2:

* Remove the redundant cast to s64 (Will Deacon).


Daniel Thompson (2):
  arm: perf: Prevent wraparound during overflow
  arm64: perf: Prevent wraparound during overflow

 arch/arm/kernel/perf_event.c   | 10 ++++++++--
 arch/arm64/kernel/perf_event.c | 10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

--
1.9.3

