Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab3FYQzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:55:32 -0400
Received: from fbr03.mfg.siteprotect.com ([64.26.60.138]:60367 "EHLO
	fbr03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3FYQz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:55:28 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2013 12:55:28 EDT
Date: Tue, 25 Jun 2013 12:46:42 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Runzhen Wang <runzhen@linux.vnet.ibm.com>
cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, paulus@samba.org, acme@redhat.com,
        Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        vincent.weaver@maine.edu, Stephane Eranian <eranian@google.com>,
        sukadev@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/2] perf tools: Make Power7 events available for
 perf
In-Reply-To: <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1306251240440.25443@pianoman.cluster.toy>
References: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com> <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020201.51C9C94E.01C5,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun 2013, Runzhen Wang wrote:

> This patch makes all the POWER7 events available in sysfs.
> 
> ...
>
> $ size arch/powerpc/perf/power7-pmu.o
>    text	   data	    bss	    dec	    hex	filename
>    3073	   2720	      0	   5793	   16a1	arch/powerpc/perf/power7-pmu.o
> 
> and after the patch is applied, it is:
> 
> $ size arch/powerpc/perf/power7-pmu.o
>    text	   data	    bss	    dec	    hex	filename
>   15950	  31112	      0	  47062	   b7d6	arch/powerpc/perf/power7-pmu.o

So if I'm reading this right, there's 45k of overhead for just one cpu 
type?

What happens if we do this on x86?

If we have similar for p6/p4/core2/nehalem/ivb/snb/amd10h/amd15h/amd16h/knb
that's 450k of event defintions in the kernel.  And may I remind everyone 
that you can't compile perf_event support as a module, nor can you 
unconfigure it on x86 (it's always built in, no option to disable).

I'd like to repeat my unpopular position that we just link perf against 
libpfm4 and keep event tables in userspace where they belong.

Vince

