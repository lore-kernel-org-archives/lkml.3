Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaAUOQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:16:29 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:55715 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaAUOQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:16:24 -0500
Date: Tue, 21 Jan 2014 15:16:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@kernel.org>, Gaurav Jain <gjain@fb.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf tools: Fix JIT profiling on heap
Message-ID: <20140121141621.GC4559@gmail.com>
References: <20140116143749.GA21526@ghostprotocols.net>
 <CEFDA8E4.2D359%gjain@fb.com>
 <87sisn6ojf.fsf@sejong.aot.lge.com>
 <20140117143404.GB3207@ghostprotocols.net>
 <87iotd7ucn.fsf@sejong.aot.lge.com>
 <20140121135552.GD18027@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121135552.GD18027@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> > Right.  But in this case we cannot determine whether a symbol in 
> > the /tmp/perf-... file is a function or variable.
> 
> That is why we would then need to have separate /tmp/perf-... files, 
> disambiguated by an extension, one for text addresses, another for 
> data ones.
> 
> Or change the format to match /proc/kallsyms, which probably is what 
> we should've done from day one...

Yeah. Using the same format would be lovely. The parser could try to 
detect the new one and could fall back to the old format?

> Detecting the format change would be trivial, as we would find 3 
> tokens in the new format, instead of the current 2.

Yeah!

Thanks,

	Ingo
