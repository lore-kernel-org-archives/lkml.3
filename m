Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3KSLuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:50:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35796 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3KSLuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:50:06 -0500
Date: Tue, 19 Nov 2013 12:49:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
Message-ID: <20131119114959.GE3694@twins.programming.kicks-ass.net>
References: <20131118090117.GE3866@twins.programming.kicks-ass.net>
 <20131118094036.GA26251@gmail.com>
 <877gc5utkf.fsf@sejong.aot.lge.com>
 <528AB229.6030603@gmail.com>
 <87wqk5t9yd.fsf@sejong.aot.lge.com>
 <528ACA41.4030202@gmail.com>
 <87ob5ht962.fsf@sejong.aot.lge.com>
 <528ACDE7.3050107@gmail.com>
 <20131119065835.GB32367@gmail.com>
 <20131119114810.GK3866@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119114810.GK3866@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 12:48:10PM +0100, Peter Zijlstra wrote:
> And that does indeed seem to side-step the perf sw pagefault event, but
> that is arguably a perf bug.

To clarify; mm/memory.c:handle_mm_fault() is where the VM counts its
generic PGFAULT event, but our perf sw event is in the arch fault
handler.

So they count different but related things.
