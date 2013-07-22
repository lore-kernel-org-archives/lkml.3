Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab3GVPFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:05:15 -0400
Received: from mail-gh0-f170.google.com ([209.85.160.170]:40570 "EHLO
	mail-gh0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab3GVPFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:05:13 -0400
Date: Mon, 22 Jul 2013 12:05:06 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf record/top: handle ENODEV on default cycles event
Message-ID: <20130722150506.GC2157@ghostprotocols.net>
References: <1374190079-28507-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374190079-28507-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 18, 2013 at 05:27:59PM -0600, David Ahern escreveu:
> Some systems (e.g., VMs on qemu-0.13 with the default vcpu model) report
> an unsupported CPU model:
> 
> Performance Events: unsupported p6 CPU model 2 no PMU driver, software events only.
> 
> Subsequent invocations of perf fail with:
> 
> The sys_perf_event_open() syscall returned with 19 (No such device) for event (cycles).
> /bin/dmesg may provide additional information.
> No CONFIG_PERF_EVENTS=y kernel support configured?
> 
> Add ENODEV to the list of errno's to fallback to cpu-clock.

Thanks, applied.

- Arnaldo
