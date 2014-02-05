Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaBET0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 14:26:15 -0500
Received: from smtpauth02.mfg.siteprotect.com ([64.26.60.136]:60451 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274AbaBET0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:26:11 -0500
Date: Wed, 5 Feb 2014 14:29:36 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <peterz@infradead.org>
cc: junk@eslaf.co.uk, alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf,x86,p6: Add userspace RDPMC quirk for P6
In-Reply-To: <20140205192012.GL2936@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1402051427210.16596@pianoman.cluster.toy>
References: <20140205102718.GF3229@twins.programming.kicks-ass.net> <alpine.DEB.2.02.1402051415190.16225@pianoman.cluster.toy> <20140205192012.GL2936@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020202.52F29053.000F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Peter Zijlstra wrote:

> On Wed, Feb 05, 2014 at 02:16:43PM -0500, Vince Weaver wrote:
> > On Wed, 5 Feb 2014, Peter Zijlstra wrote:
> > 
> > > P6 class machines can die hard when PCE gets enabled due to CPU
> > > errata. The safe way it so disable it by default and keep it disabled.
> > > 
> > > See errata 26:
> > 
> > so you take an errata applicable to a subset of Pentium Pro steppings and 
> > apply it to the whole p6 line (which includes the whole way up to Pentium 
> > III)?
> > 
> > Or am I missing something in the documentation you link to?
> 
> I forgot it went all the way to P-III, let me try and find the other
> erratas.

from the document you linked it looks like it was fixed by the Pentium 
Pro stepping sB1 (6.1.9).

Has someone actually hit this bug?  People used PAPI/perfctr on these 
machines for years, and it uses rdpmc by default so I would think it would 
show up if it were an issue.  I should check the perfctr code to see if it 
had some sort of check.

Vince
