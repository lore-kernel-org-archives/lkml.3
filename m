Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbaFIFV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 01:21:57 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:41566 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaFIFVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 01:21:55 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, acme@infradead.org, fweisbec@gmail.com
Subject: Re: [PATCH 9/9] perf, tools, record: Always allow to overide default period v2
References: <1401486615-21374-1-git-send-email-andi@firstfloor.org>
	<1401486615-21374-10-git-send-email-andi@firstfloor.org>
	<1401895987.1673.36.camel@leonhard>
	<20140604165930.GH8876@tassilo.jf.intel.com>
Date: Mon, 09 Jun 2014 14:21:52 +0900
In-Reply-To: <20140604165930.GH8876@tassilo.jf.intel.com> (Andi Kleen's
	message of "Wed, 4 Jun 2014 09:59:30 -0700")
Message-ID: <87d2eid5e7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014 09:59:30 -0700, Andi Kleen wrote:
> I saw samples.
>
> Oh well we can just drop it. The only difference is that the 
> event list cannot set a period then.

I tested with a downloaded event, and it does have samples.  But the
frequency could not be changed even with your patch.

  $ perf record -a -e uops_retired.all -F 4000 sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.327 MB perf.data (~14281 samples) ]

  $ perf evlist -F
  cpu/uops_retired.all/: sample_freq=2000003


>
> It's as broken as before.

At least, it worked well for events don't have a default sample
freq/period which means all but tracepoint events.  For tracepoint
events, it makes little sense to change the default so I decided not to
touch it.  

But with your change, the downloaded events might have a default
freq/period setting now.  So I'd like to make it right.  I'll send a fix
for this right soon.

Thanks,
Namhyung
