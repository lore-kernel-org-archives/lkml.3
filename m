Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3HLBXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 21:23:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:18650 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3HLBXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 21:23:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,858,1367996400"; 
   d="scan'208";a="385408607"
From: Andi Kleen <andi@firstfloor.org>
To: Karim Yaghmour <karim.yaghmour@opersys.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        mingo@elte.hu
Subject: Re: Reading perf counters at ftrace trace boundaries
References: <5208263D.2080205@opersys.com>
Date: Sun, 11 Aug 2013 18:23:10 -0700
In-Reply-To: <5208263D.2080205@opersys.com> (Karim Yaghmour's message of "Sun,
	11 Aug 2013 21:03:09 -0300")
Message-ID: <87haevog75.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karim Yaghmour <karim.yaghmour@opersys.com> writes:

> Wondering if there's a way for reading perf counters in the kernel. I'd
> like to read/record perf counters on ftrace function tracing
> entries/exits to provide a rundown of the value of various counters on
> function call boundaries.

KVM does it, see arch/x86/kvm/pmu.c. Essentially it would be doing RDPMC.

But the overhead will be likely very high, some sampling approach
is likely better.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
