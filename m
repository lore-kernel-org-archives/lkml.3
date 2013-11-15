Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab3KOPGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:06:40 -0500
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:48426 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751190Ab3KOPGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:06:33 -0500
Date: Fri, 15 Nov 2013 10:08:45 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@kernel.org>
cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, David Ahern <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [BUG] perf stat: explicit grouping yields unexpected results
In-Reply-To: <20131115063457.GB12442@gmail.com>
Message-ID: <alpine.DEB.2.02.1311151007340.15200@pianoman.cluster.toy>
References: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com> <20131115063457.GB12442@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A02020A.52863878.0118,ss=1,re=0.100,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Nov 2013, Ingo Molnar wrote:
> 
> Btw., does the kernel side currently support discovery of such 
> impossible group scheduling constraints at group setup time? If not 
> then it probably should and it should reject them straight away.

It does not, or at least I'm pretty sure it can't if the NMI watchdog is 
enabled (Stephane, are you doing your tests with NMI watchdog disabled?)

This is a big problem with PAPI.  If the NMI watchdog is enabled you can't 
tell if a group will fail until the first read, the kernel can't tell you 
at setup time.

Vince
