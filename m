Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaJUEMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:12:13 -0400
Received: from fbr04.mfg.siteprotect.com ([64.26.60.139]:39199 "EHLO
	fbr04.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaJUEML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:12:11 -0400
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Oct 2014 00:12:11 EDT
Date: Tue, 21 Oct 2014 00:06:54 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Andy Lutomirski <luto@amacapital.net>
cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 0/5] CR4 handling improvements
In-Reply-To: <cover.1413323611.git.luto@amacapital.net>
Message-ID: <alpine.DEB.2.10.1410210003300.5251@pianoman.cluster.toy>
References: <cover.1413323611.git.luto@amacapital.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020205.5445DBC9.01D3,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2014, Andy Lutomirski wrote:

> This little series tightens up rdpmc permissions.  With it applied,
> rdpmc can only be used if a perf_event is actually mmapped.  For now,
> this is only really useful for seccomp.

So just to be difficult...

I am aware of at least one group who is doing low-latency performance
measures using rdpmc on Linux.

They start the counters manually by poking the MSRs directly (bypassing 
perf_event_open()).

They use rdpmc, grateful for the fact that currently CR4 is set up so they 
can do this w/o patching the kernel.

These patches of course would break this use case...

Vince
