Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965975AbaGRRgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:36:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:22648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965869AbaGRRgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:36:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,686,1400050800"; 
   d="scan'208";a="575297803"
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 09/13] perf tools: Add perf download to download event files
References: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
	<1405540969-18975-10-git-send-email-jolsa@kernel.org>
	<20140717104704.GB9571@gmail.com>
Date: Fri, 18 Jul 2014 10:35:59 -0700
In-Reply-To: <20140717104704.GB9571@gmail.com> (Ingo Molnar's message of "Thu,
	17 Jul 2014 12:47:04 +0200")
Message-ID: <87ha2e4lj4.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> writes:
>
> We want these description files to be in the perf source code, 
> somewhere in tools/perf/live-config/arch/x86/ or so, and installed 
> during 'make install' - i.e. part of perf project and installed in 
> ~/.debug or ~/.perf or so.

I don't think that's a good idea. It would recreate all the 
problems oprofile has with out of date event lists. Already
proven to not work well.

>
> Those files could be refreshed via 'perf download' and could be 
> accessible via kernel.org as well, 'perf download' should pick up 
> these files from Linus's latest git repository (via the HTTP 
> namespace).

I have doubts a gitweb server is a good way to distribute potentially
high volume / high access data.

However getting a more neutral space is fine.

It would be fine to put it elsewhere on kernel.org.
I can ask for a space.

Otherwise I will just remove the auto URL from the tool, 
so the perf project does not need to endorse any particular
event lists.

Let me know what you prefer. I'll assume the "remove the URL"
variant is the default option.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
