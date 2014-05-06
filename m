Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaEFS6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:58:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34389 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbaEFS6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:58:31 -0400
Date: Tue, 6 May 2014 20:58:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v4 00/16] perf, persistent: Add persistent events
Message-ID: <20140506185826.GF25013@pd.tnic>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
 <20140506123907.GV32718@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140506123907.GV32718@rric.localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 02:39:07PM +0200, Robert Richter wrote:
> I rather would change the ioctl to
> 
>  id = ioctl(PERF_EVENT_IOC_SET_PERSIST, arg);
> 
>  arg != 0:	create persistent event (unclaim)
>  arg == 0:	delete persistent event (claim)
> 
> This has the advantage that the naming is better and arg can be used
> as parameter (e.g. event id to share a namespace).

Yep, this is better than the CLAIM/UNCLAIM thing.

> The unclaim ioctl *creates* a buffer with 512kB default size. The
> reopening process must mmap with the same buffer size. This is a
> problem as in this implementation the buffer size is fix and can not
> be adjusted.

Why do we need it to be adjustable?

> We could let create the process the buffers and make the
> event persistent including the current buffers.
> 
> Variable buffer size is a must,

Yeah, why? I'm just asking for my own understanding.

> so the reopening process also must be
> able to detect buffer size. Mmap buffer size could be detected by
> mmap'ing only the header page, reading the buffer size from the header
> and then remapping the buffer with adjusted size.
> 
> It would be good to have a perf tool option -P that puts events in
> persistent state instead of starting a command:
> 
>  # perf record -e ... -a -P <namespace>		# create pers. events
>  # perf record -e persistent/<namespace>/ -a	# read existing buffers
>  # perf record -e persistent/<namespace>/ -a -k	# read and kill existing events
> 
> Note that no args for a command are given.

Yep, looks sane to me.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
