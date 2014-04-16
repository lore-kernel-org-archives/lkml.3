Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaDPRrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:47:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57268 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbaDPRrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:47:41 -0400
Date: Wed, 16 Apr 2014 19:47:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140416174733.GQ26782@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1404151729230.17264@vincent-weaver-1.um.maine.edu>
 <20140416141514.GS11182@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404161326380.19325@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404161337350.19325@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 01:43:49PM -0400, Vince Weaver wrote:
> On Wed, 16 Apr 2014, Vince Weaver wrote:
> 
> > On Wed, 16 Apr 2014, Peter Zijlstra wrote:
> > 
> > > Does the below make any difference? I've only ran it through some light
> > > testing to make sure it didn't insta-explode on running.
> > > 
> > > (perf stat make -j64 -s in fact)
> > 
> > I'm running with your patch now and so far so good.
> 
> spoke too soon, just got this with your patch applied
> (I wasn't running ftrace so no trace with this one):
> 
> [ 1555.756490] Slab corruption (Not tainted): kmalloc-2048 start=ffff88011879a000, len=2048
> [ 1555.765699] 040: 6b 6b 6b 6b 6b 6b 6b 6b 88 a7 97 ce 00 88 ff ff  kkkkkkkk........
> [ 1555.774684] Next obj: start=ffff88011879a800, len=2048
> [ 1555.780396] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [ 1555.789150] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk

Awww, bugger. OK more staring tomorrow. Thanks for trying.
