Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaHLNvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 09:51:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbaHLNvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 09:51:06 -0400
Date: Tue, 12 Aug 2014 15:50:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        mingo@kernel.org, peterz@infradead.org
Subject: Re: Implement lbr-as-callgraph v9
Message-ID: <20140812135017.GB13247@krava.brq.redhat.com>
References: <1406827029-7991-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406827029-7991-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 10:17:00AM -0700, Andi Kleen wrote:

SNIP

> v5:
> - Rename functions
> - Fix gtk build problem
> - Fix crash without -g
> - Improve error messages
> - Improve srcline display in various ways
> v6:
> - Port to latest perf/core
> v7:
> - Really port to latest perf/core
> v8:
> - Rebased on 3.16-rc1
> v9: 
> - Forward ported to latest tip/perf/core
> 
> Example output:
> 
>     % perf record -b -g ./tsrc/tcall

Why do we need the '-g' in here.. '-b' should be enough right?
I saw u fill the rest of the backtrace with callchain
data (if needed), but thats not necessary right?


>     [ perf record: Woken up 1 times to write data ]
>     [ perf record: Captured and wrote 0.044 MB perf.data (~1923 samples) ]
>     % perf report --branch-history

When I captured data like you above and run pure 'perf report'
I did not get callchains displayed at all.

Also using 'perf report --branch-history' enables filename:line
suffix for callchain regardless of using '-b' for data capture

jirka
