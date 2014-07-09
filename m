Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaGIUfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:35:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:62201 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbaGIUfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:35:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,633,1400050800"; 
   d="scan'208";a="455118454"
From: Andi Kleen <andi@firstfloor.org>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, Ewout van Bekkum <ewout@google.com>
Subject: Re: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP and CMCI reports.
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-5-git-send-email-hskinnemoen@google.com>
Date: Wed, 09 Jul 2014 13:35:28 -0700
In-Reply-To: <1404925766-32253-5-git-send-email-hskinnemoen@google.com>
	(Havard Skinnemoen's message of "Wed, 9 Jul 2014 10:09:24 -0700")
Message-ID: <87a98inucv.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Havard Skinnemoen <hskinnemoen@google.com> writes:

> machine_check_poll() was modified to use spin_lock_irqsave independently
> per bank when a valid MCE is found to prevent duplicated MCE reports by
> the CMCI and polling methods. In the common case no MCE will be found,
> so the lock is not acquired until a valid MCE is found. The status is
> reread after the lock is acquired in case the MCE was already handled by
> a different thread. A unique spinlock is used per bank number, so
> contention should be mostly limited to non-shared banks.

This doesn't make sense. Banks are either owned by CMCI or by poll,
not by both. If you have true duplicates the bug must be somewhere else.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
