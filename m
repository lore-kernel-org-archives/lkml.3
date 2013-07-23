Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab3GWFcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 01:32:21 -0400
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:43159 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751244Ab3GWFcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 01:32:20 -0400
Date: Tue, 23 Jul 2013 01:33:04 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, michael@ellerman.id.au,
        runzhen@linux.vnet.ibm.com, runzhew@clemson.edu,
        xiaoguangrong@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        tglx@linutronix.de
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf tools: Make Power7 events available for
 perf
In-Reply-To: <tip-cfe0d8ba14a1d98245b371e486c68f37eba1ca52@git.kernel.org>
Message-ID: <alpine.DEB.2.02.1307230129350.18266@pianoman.cluster.toy>
References: <1372407297-6996-3-git-send-email-runzhen@linux.vnet.ibm.com> <tip-cfe0d8ba14a1d98245b371e486c68f37eba1ca52@git.kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020202.51EE1563.0217,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jul 2013, tip-bot for Runzhen Wang wrote:

> perf tools: Make Power7 events available for perf
> 
> This patch makes all the POWER7 events available in sysfs.  So we can
> instead specify these as:
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


so we're really going down this road?

If x86 follows this precedent we're going to end up with 300k+ of
event names in the kernel.  And as a reminder, perf_event cannot
be disabled on x86, nor can it be compiled as a module.  So that would
be 300k of event names in every kernel for everyone, even those not using 
perf.

This belongs in userspace.

Vince

