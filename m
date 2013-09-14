Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3INGSY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 02:18:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:43653 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab3INGSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 02:18:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,902,1371106800"; 
   d="scan'208";a="401571615"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/intel: Clean-up/reduce PEBS code
References: <tip-8q6y4davda9aawwv5yxe7klp@git.kernel.org>
Date: Fri, 13 Sep 2013 23:18:21 -0700
In-Reply-To: <tip-8q6y4davda9aawwv5yxe7klp@git.kernel.org> (tip-bot for Peter
	Zijlstra's message of "Thu, 12 Sep 2013 11:04:44 -0700")
Message-ID: <87mwng53ki.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Peter Zijlstra <tipbot@zytor.com> writes:
> +
> +	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
> +	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
>  
>  	ds->pebs_index = ds->pebs_buffer_base;
>  
> +	n = (top - at) / x86_pmu.pebs_record_size;


This adds a full slow division to the PEBS hot path.

Does not seem like a improvement to me.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
