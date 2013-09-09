Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab3IILzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:55:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48928 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab3IILze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:55:34 -0400
Date: Mon, 9 Sep 2013 13:55:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 00/25] perf tool: Add support for multiple data file
 storage
Message-ID: <20130909115518.GA26785@twins.programming.kicks-ass.net>
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
 <20130909111749.GP31370@twins.programming.kicks-ass.net>
 <20130909113640.GA16401@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909113640.GA16401@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 01:36:41PM +0200, Jiri Olsa wrote:
> On Mon, Sep 09, 2013 at 01:17:49PM +0200, Peter Zijlstra wrote:
> > On Sun, Sep 01, 2013 at 12:36:11PM +0200, Jiri Olsa wrote:
> This patchset is actually doing 3 essential things:
>   1) adds new perf data format version (v3)
>   2) adds class/object to handle perf data file
>   3) adds record '-M size' option

So the -M thing is where the multiple files stuff comes from, right?
What's the purpose of this? Why would I care how big these files get,
surely filesystems handle 4g+ files these days.

> > The only reason I wanted this is so that each thread can write its own
> > data. The current one file thing is an immense bottle-neck for big
> > machines.
> > 
> 
> I haven't considered the thread based storage yet, but I
> think having the simplified format and centralized file
> handling will only help.

Please do consider it now, it'd suck to have to change the file format
thing yet again.

With both per-thread and size limited your filename generation needs
some extra bits I suppose.
