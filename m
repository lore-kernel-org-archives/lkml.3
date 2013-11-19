Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab3KSG6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 01:58:40 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:42474 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3KSG6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 01:58:39 -0500
Date: Tue, 19 Nov 2013 07:58:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
Message-ID: <20131119065835.GB32367@gmail.com>
References: <20131113113439.GI21461@twins.programming.kicks-ass.net>
 <52864ED1.1080607@gmail.com>
 <20131118090117.GE3866@twins.programming.kicks-ass.net>
 <20131118094036.GA26251@gmail.com>
 <877gc5utkf.fsf@sejong.aot.lge.com>
 <528AB229.6030603@gmail.com>
 <87wqk5t9yd.fsf@sejong.aot.lge.com>
 <528ACA41.4030202@gmail.com>
 <87ob5ht962.fsf@sejong.aot.lge.com>
 <528ACDE7.3050107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528ACDE7.3050107@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> This is mmap'ed output, not the ring buffers or its stack. As the 
> output file grows, new pages are needed and those are allocated on 
> access via page faults. The ftruncate only extends the file size, it 
> does not allocate pages at that time.

Hm, doesn't MAP_POPULATE prefault pages in this case as well? 
Prefaulting would avoid the most obvious page fault driven feedback 
loops and it would probably be faster as well, because it avoids all 
the pagefaults ...

Thanks,

	Ingo
