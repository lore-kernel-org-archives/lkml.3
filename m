Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaBETxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 14:53:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58134 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaBETxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:53:12 -0500
Date: Wed, 5 Feb 2014 20:53:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: junk@eslaf.co.uk, alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf,x86,p6: Add userspace RDPMC quirk for P6
Message-ID: <20140205195305.GM2936@laptop.programming.kicks-ass.net>
References: <20140205102718.GF3229@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1402051415190.16225@pianoman.cluster.toy>
 <20140205192012.GL2936@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.02.1402051427210.16596@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402051427210.16596@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 02:29:36PM -0500, Vince Weaver wrote:
> from the document you linked it looks like it was fixed by the Pentium 
> Pro stepping sB1 (6.1.9).

OK, I'll add a boot_cpu_data.x86_mask >= 0xB1 test.

> Has someone actually hit this bug?  People used PAPI/perfctr on these 
> machines for years, and it uses rdpmc by default so I would think it would 
> show up if it were an issue.  I should check the perfctr code to see if it 
> had some sort of check.

Yeah, the reporter had a boot fail due to this.
