Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbaGQKvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:51:48 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:34836 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081AbaGQKvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:51:42 -0400
Date: Thu, 17 Jul 2014 12:51:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 09/13] perf tools: Add perf download to download event
 files
Message-ID: <20140717105135.GA10147@gmail.com>
References: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
 <1405540969-18975-10-git-send-email-jolsa@kernel.org>
 <20140717104704.GB9571@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717104704.GB9571@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> this bit needs more discussion:
> 
> * Jiri Olsa <jolsa@kernel.org> wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Add a downloader to automatically download the right
> > files from a download site.
> 
> 'A download site' is way too vague and detached from the perf project.
> 
> > +	echo "Downloading models file"
> > +	URLBASE=${URLBASE:-https://download.01.org/perfmon}
> 
> We want these description files to be in the perf source code, 
> somewhere in tools/perf/live-config/arch/x86/ or so, and installed 
> during 'make install' - i.e. part of perf project and installed in 
> ~/.debug or ~/.perf or so.
> 
> Those files could be refreshed via 'perf download' and could be 
> accessible via kernel.org as well, 'perf download' should pick up 
> these files from Linus's latest git repository (via the HTTP 
> namespace).

So basically instead of the above URI, we want these files to be 
refreshed from:

    http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/tools/perf/live-config/

Thanks,

	Ingo
