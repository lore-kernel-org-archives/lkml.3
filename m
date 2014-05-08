Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaEHMf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:35:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:40933 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbaEHMf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:35:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="508353055"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
In-Reply-To: <20140507152640.GR30445@twins.programming.kicks-ass.net>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com> <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com> <20140507152640.GR30445@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 08 May 2014 15:34:17 +0300
Message-ID: <87wqdwzbxy.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> So the aux_head/tail values should also be in the file space and not
> start at 0 again, similar for the offsets in the AUX record.

Thinking some more about it: if we keep aux_{offset,size} in userpg,
then it would make sense to have aux_{head,tail} run from 0 to infinity
similar to data_{head,tail}, especially considering that neither data_*
nor aux_* pointers are file offsets anyway.

Regards,
--
Alex
