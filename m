Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab3GFFIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 01:08:31 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:42613 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3GFFIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 01:08:30 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: tj@kernel.org, sfr@canb.auug.org.au, andi@firstfloor.org, oleg@redhat.com,
        mingo@redhat.com, nab@linux-iscsi.org, axboe@kernel.dk
Subject: [PATCH v3] lib/idr.c rewrite, percpu ida/tag allocator
Date: Fri,  5 Jul 2013 22:08:11 -0700
Message-Id: <1373087301-23730-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous posting: http://thread.gmane.org/gmane.linux.kernel/1511216

The only real change since the last version is that I've reworked the
new ida implementation to not use one giant allocation - it's still
logically one big arary, but it's implemented as an array of arrays.

With that, it scales up to INT_MAX allocated ids just fine. Benchmarks
are included in that patch.

Patch series is available in my git repo:
git://evilpiepirate.org/~kent/linux-bcache.git idr

Andrew, want to pick this up for 3.12?

