Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaKDSkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:40:51 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:58657 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbaKDSks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:40:48 -0500
Date: Tue, 4 Nov 2014 19:40:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        David Ahern <dsahern@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] perf: Userspace event
Message-ID: <20141104184031.GM10501@worktop.programming.kicks-ass.net>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
 <1415060918-19954-3-git-send-email-pawel.moll@arm.com>
 <87ppd35vbk.fsf@sejong.aot.lge.com>
 <1415119331.24819.19.camel@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415119331.24819.19.camel@arm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 04:42:11PM +0000, Pawel Moll wrote:
> 
> 1. I'm wrong and the record doesn't have to be padded to make it 8 bytes
> aligned. Then I can drop the additional size field.

No, you're right, we're supposed to stay 8 byte aligned.

> 2. I could impose a limitation on the prctl API that the data size must
> be 8 bytes aligned. Bad idea in my opinion, I'd rather not.

Agreed.

> 3. The additional size (for the data part) field stays. Notice that
> PERF_SAMPLE_RAW has it as well :-)

Right, with binary data there is no other day. With \0 terminated
strings there won't be a problem, but I think we decided we wanted to
allow any binary blow.
