Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaBETeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 14:34:12 -0500
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:35792 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751175AbaBETeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:34:09 -0500
Date: Wed, 5 Feb 2014 14:37:29 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <peterz@infradead.org>
cc: junk@eslaf.co.uk, alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf,x86,p6: Add userspace RDPMC quirk for P6
In-Reply-To: <alpine.DEB.2.02.1402051427210.16596@pianoman.cluster.toy>
Message-ID: <alpine.DEB.2.02.1402051435540.16859@pianoman.cluster.toy>
References: <20140205102718.GF3229@twins.programming.kicks-ass.net> <alpine.DEB.2.02.1402051415190.16225@pianoman.cluster.toy> <20140205192012.GL2936@laptop.programming.kicks-ass.net> <alpine.DEB.2.02.1402051427210.16596@pianoman.cluster.toy>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020202.52F29230.0168,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Vince Weaver wrote:

> Has someone actually hit this bug?  People used PAPI/perfctr on these 
> machines for years, and it uses rdpmc by default so I would think it would 
> show up if it were an issue.  I should check the perfctr code to see if it 
> had some sort of check.

I can verify the perfctr code does have a case for PPRO errata 26, but it 
only disables things on pentium pros with stepping less than 9.

It also disables rdpmc on original Pentiums due to errata 74 but I don't 
think we have to worry about that one.

Vince
