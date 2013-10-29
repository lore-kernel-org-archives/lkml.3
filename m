Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab3J2TZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:25:14 -0400
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:38712 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751803Ab3J2TZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:25:12 -0400
Date: Tue, 29 Oct 2013 15:27:05 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <peterz@infradead.org>
cc: Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
In-Reply-To: <20131029103057.GN2490@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1310291524240.6608@pianoman.cluster.toy>
References: <12083.1382486094@ale.ozlabs.ibm.com> <20131023141948.GB3566@localhost.localdomain> <20131025173749.GG19466@laptop.lan> <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com> <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan> <20131028163418.GD4126@linux.vnet.ibm.com> <20131028201735.GA15629@redhat.com> <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com> <20131029102131.GA16117@laptop.programming.kicks-ass.net>
 <20131029103057.GN2490@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020207.52700B97.00D0,ss=1,re=0.100,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Oct 2013, Peter Zijlstra wrote:

> On Tue, Oct 29, 2013 at 11:21:31AM +0100, Peter Zijlstra wrote:
> --- linux-2.6.orig/include/uapi/linux/perf_event.h
> +++ linux-2.6/include/uapi/linux/perf_event.h
> @@ -479,13 +479,15 @@ struct perf_event_mmap_page {
>  	/*
>  	 * Control data for the mmap() data buffer.
>  	 *
> -	 * User-space reading the @data_head value should issue an rmb(), on
> -	 * SMP capable platforms, after reading this value -- see
> -	 * perf_event_wakeup().
> +	 * User-space reading the @data_head value should issue an smp_rmb(),
> +	 * after reading this value.

so where's the patch fixing perf to use the new recommendations?

Is this purely a performance thing or a correctness change?

A change like this a bit of a pain, especially as userspace doesn't really 
have nice access to smb_mb() defines so a lot of cut-and-pasting will 
ensue for everyone who's trying to parse the mmap buffer.

Vince
