Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3AUXNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:13:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:15905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab3AUXNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:13:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,510,1355126400"; 
   d="scan'208";a="250432233"
Message-ID: <50FDCB8C.40208@linux.intel.com>
Date: Mon, 21 Jan 2013 15:13:16 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/13 -next] tracing: Remove the extra 4 bytes of padding
 in events
References: <20130121211403.337052956@goodmis.org> <20130121211729.357828882@goodmis.org>
In-Reply-To: <20130121211729.357828882@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/21/2013 1:14 PM, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
>
> Due to a userspace issue with PowerTop v1, which hardcoded
> the offset of event fields that it was using, it broke when
> we removed the Big Kernel Lock counter from the event header.
>
>   (commit e6e1e2593 "tracing: Remove lock_depth from event entry")
>
> Because this broke userspace, it was determined that we must
> keep those 4 bytes around.
>
>   (commit a3a4a5acd "Regression: partial revert "tracing: Remove lock_depth from event entry"")
>
> This unfortunately wastes space in the ring buffer. 4 bytes per
> event, where a lot of events are just 24 bytes. That's 16% of the
> buffer wasted. A million events will add 4 megs of white space
> into the buffer.
>
> It was later noticed that PowerTop v1 could not work on systems
> where the kernel was 64 bit but the userspace was 32 bits.
> The reason was because the offsets are different between the
> two and the hard coded offset of one would not work with the other.
>
> With PowerTop v2, it implemented the same interface that both
> perf and trace-cmd use. That is, it reads the format file of
> the event to find the offsets of the fields it needs. This fixes
> the problem with running powertop on a 32 bit userspace running
> on a 64 bit kernel. It also no longer requires the 4 byte padding.
>
> As PowerTop v2 has been out for a while, and is included in all
> major distributions, it is time that we can safely remove the
> 4 bytes of padding. Users of PowerTop v1 should upgrade to
> PowerTop v2.
>
> Cc: Arjan van de Ven <arjan@linux.intel.com>

this only impacts the users of the 2.0beta series (which, while arguably staying around for too long, is now very very obsolete and
replaced by the final in all distros that I'm aware of)


Acked-By: Arjan van de Ven <arjan@linux.intel.com>

