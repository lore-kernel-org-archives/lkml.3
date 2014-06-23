Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbaFWP62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:58:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:2674 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbaFWP61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:58:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,530,1400050800"; 
   d="scan'208";a="561950309"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Liang\, Kan" <kan.liang@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kleen\, Andi" <andi.kleen@intel.com>
Subject: Re: [PATCH 1/2] perf: ignore LBR and offcore_rsp.
References: <37D7C6CF3E00A74B8858931C1DB2F0770148F513@SHSMSX103.ccr.corp.intel.com>
	<20140623092917.GQ19860@laptop.programming.kicks-ass.net>
Date: Mon, 23 Jun 2014 08:56:44 -0700
In-Reply-To: <20140623092917.GQ19860@laptop.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Mon, 23 Jun 2014 11:29:17 +0200")
Message-ID: <878uon8vr7.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

>
> So I really hate this patch, it makes the code hideous. Also, its a
> death by a thousand cuts adding endless branches in this code.

FWIW compared to the cost of a RDMSR (which is a very complex operation
for the CPU) the cost of a predicted branch is nearly in the noise.

>
> Also, the offcore part is retarded, just make sure extra_reg isn't set.
>
> As to the LBR, just make it so that we avoid calling the LBR code to
> begin with; ideally without adding extra code to fast paths.

You mean check once at initialization time.

I'm not sure that would handle all cases unfortunately.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
