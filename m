Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120AbaFSRw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:52:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:20029 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295AbaFSRw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:52:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,508,1400050800"; 
   d="scan'208";a="558105555"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra 5A <peterz@infradead.org>
Cc: "Liang\, Kan" <kan.liang@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kleen\, Andi" <andi.kleen@intel.com>
Subject: Re: [PATCH 1/2] perf: ignore LBR and offcore_rsp.
References: <37D7C6CF3E00A74B8858931C1DB2F0770148F513@SHSMSX103.ccr.corp.intel.com>
	<20140618155916.GZ6758@twins.programming.kicks-ass.net>
	<87lhsu8arx.fsf@tassilo.jf.intel.com>
Date: Thu, 19 Jun 2014 10:52:52 -0700
In-Reply-To: <87lhsu8arx.fsf@tassilo.jf.intel.com> (Andi Kleen's message of
	"Wed, 18 Jun 2014 09:04:02 -0700")
Message-ID: <87ha3g947f.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:
>>
>>>     Signed-off-by: Kan Liang <kan.liang@intel.com>
>>
>> And here I thought that Andi was of the opinion that if you set CPUID to
>> indicate a particular CPU you had better also handle all its MSRs.
>
> Yes, philosophically that would be the right way,
> but we needed a short term fix to stop things from crashing, and that
> was the simplest.

I should add there is another reason for this patch now,
and doing it in perf instead of somewhere else
(this should probably go into the description).

With PT on enabling LBR can #GP. So perf needs to handle
this case without crashing. This can happen independently
of any hypervisors.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
