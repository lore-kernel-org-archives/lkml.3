Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaKFMmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:42:17 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47161 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaKFMmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:42:15 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH RESEND 3.18-rc3 v2 0/2] trace: kdb: Bug fixes for ftdump
Date: Thu,  6 Nov 2014 12:41:54 +0000
Message-Id: <1415277716-19419-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411554781-16751-1-git-send-email-daniel.thompson@linaro.org>
References: <1411554781-16751-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset makes it possible to use kdb's ftdump command without
panicing, crashing or livelocking. The ftdump command cannot be used
at all without these changes.

IIRC this patches are still pending Jason's ack.

Changes since v1:

* Fixed use-after-free problems in v1 by adding logic to NULL out
  buffer_iter during free operations.

* Introduced a second patch to fix a live lock when trying to display
  an empty trace buffer.


Daniel Thompson (2):
  trace: kdb: Fix kernel panic during ftdump
  trace: kdb: Fix kernel livelock with empty buffers

 kernel/trace/trace_kdb.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--
1.9.3

