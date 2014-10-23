Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbaJWNhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:37:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:53261 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbaJWNhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:37:31 -0400
Date: Thu, 23 Oct 2014 10:37:24 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/powerpc: Cache the DWARF debug info
Message-ID: <20141023133724.GE14687@kernel.org>
References: <20141021185610.GA18366@us.ibm.com>
 <20141021190839.GA4160@kernel.org>
 <20141022000958.GB2228@us.ibm.com>
 <20141022081730.GB9860@krava.brq.redhat.com>
 <20141022174659.GA5119@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022174659.GA5119@us.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 22, 2014 at 10:46:59AM -0700, Sukadev Bhattiprolu escreveu:
> Jiri Olsa [jolsa@redhat.com] wrote:
> | > +			goto out;
> | > +		}
> | > +		dso->dwfl = dwfl;
> | 
> | so by this we get powerpc arch code sharing dw handle via dso object,
> | but we have lot of generic code too ;-)
> 
> Well, this applies to powerpc...
> 
> | 
> | could you make this happen for unwind__get_entries.. probably
> | both sharing same generic code I guess
> 
> and unwind_get_entries() applies only to x86 and arm right ? ;-)
> Or at least thats what the config/Makefile says.
 
> I can take a look at unwind_get_entries(), but can you please merge
> this fix for now, since the current performance is bad?

Right, I think the way it is now is a good compromise, i.e. you seem to
be using the right place to cache this, this is restricted to powerpc,
i.e. if leaks or excessive memory usage happens in workloads with lots
of DSOs having dwfl handlers open at the same times happens, it doesn't
affect users in other arches.

Jiri: do you agree?

I'm applying it on my local tree, as I need to change some of those
functions, places where machine and thread are being passed are being
changed to receive just a thread pointer, since the machine where a
thread is can be obtained, after a patch I added on my local tree, can
be obtained from thread->mg->machine.

- Arnaldo
