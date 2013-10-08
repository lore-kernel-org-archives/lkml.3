Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab3JHK32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:29:28 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40168 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab3JHK3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:29:21 -0400
Date: Tue, 8 Oct 2013 12:29:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [raw v1 0/4] Replace __this_cpu ops with raw_cpu_ops where
 necessary
Message-ID: <20131008102918.GB22639@gmail.com>
References: <0000014194309038-3923fc42-2039-45da-b8fa-2df545112405-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014194309038-3923fc42-2039-45da-b8fa-2df545112405-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> The kernel can detect __this_cpu ops in preemptible contexts after the 
> preemption check patchset that I posted last week.
> 
> Here is a selection of patches to fix false positives caused by the 
> additional checks. So far I have found no bug. Amazing. Looks like there 
> was some prior work done to shake these things out?

You can probably thank -rt/PREEMPT_RT for such efforts - I think Thomas in 
particular has hit a couple of genuine bugs with __this_cpu APIs the hard 
way and then fixed them.

This series, once finished, will allow us to detect such problems cheaper 
and earlier.

Thanks,

	Ingo
