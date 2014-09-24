Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaIXKdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:33:21 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:63693 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaIXKdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:33:20 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 3.17-rc4 v2 0/2] trace: kdb: Bug fixes for ftdump
Date: Wed, 24 Sep 2014 11:32:59 +0100
Message-Id: <1411554781-16751-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410360247-13791-1-git-send-email-daniel.thompson@linaro.org>
References: <1410360247-13791-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset makes it possible to use kdb's ftdump command without
panicing, crashing or livelocking.

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

