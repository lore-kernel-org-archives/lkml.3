Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbaHEGJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 02:09:03 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:32836 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbaHEGJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 02:09:02 -0400
Date: Tue, 5 Aug 2014 08:08:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 05/33] perf record: Allow the user to disable time stamps
Message-ID: <20140805060856.GA9453@gmail.com>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
 <1407169064-25625-6-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407169064-25625-6-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 

This patch looks dangerous and misleading to me.

> Time stamps are always implicitely enabled for record currently.  The
> old --time/-T option is a nop.
> 
> Allow the user to disable timestamps by using --no-time
> 
> This can cause some minor misaccounting (by missing mmaps), but
> significantly lowers the size of perf.data

I'm not any big change in size:

 -rw------- 1 mingo mingo 384768 Aug  5 08:01 perf.data.timestamps
 -rw------- 1 mingo mingo 336952 Aug  5 08:00 perf.data.notimestamps

That's a ~14% reduction - it's certainly noticeable but not 
earth-shattering.

And what is called 'minor misaccounting' in the description is 
actually a potentially broken profile that people might rely on.

So the patch description misleads twice: by exaggerating the 
advantages and also by downplaying the disadvantages.

So either remove the --time option altogether, or fix its 
'misaccounting' so that the profile can be relied on.

Thanks,

	Ingo
