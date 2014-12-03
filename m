Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbaLCAmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:42:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaLCAmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:42:50 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 0/2] Improve documentation of FADV_DONTNEED behaviour
Date: Wed,  3 Dec 2014 00:42:45 +0000
Message-Id: <1417567367-9298-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Partial page discard requests are ignored and the documentation on why this
is correct behaviour sucks. A readahead patch looked like a "regression" to
a random IO storage benchmark because posix_fadvise() was used incorrectly
to force IO requests to go to disk. In reality, the benchmark sucked but
it was non-obvious why. Patch 1 updates the kernel comment in case someone
"fixes" either readahead or fadvise for inappropriate reasons. Patch 2
updates the relevant man page on the rough off chance that application
developers do not read kernel source comments.

-- 
2.1.2

