Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab3DAUko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:40:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757501Ab3DAUkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:40:43 -0400
Date: Mon, 1 Apr 2013 22:40:23 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 6/9] perf sort: Add 'addr' sort key
Message-ID: <20130401204022.GB1022@krava.redhat.com>
References: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
 <1364816125-12212-7-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364816125-12212-7-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 08:35:22PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> New addr sort key provides a way to sort the entries by the symbol
> addresses.  It can be helpful to figure out symbol resolution problem
> when a dso cannot do it properly as well as finding hotpath in a dso
> and/or a function.

maybe it's just the recent mem profiling patches, but wouldn't
it be better to use 'ip' instead of 'addr'?

also it's following code getting the data:
...
        if (sample_type & PERF_SAMPLE_IP)
                data->ip = perf_instruction_pointer(regs);
...

same for the "perf sort: Add 'addr_to/from' sort key" patch

jirka
