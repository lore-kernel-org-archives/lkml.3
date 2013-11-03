Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3KCU7L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 15:59:11 -0500
Received: from gate.crashing.org ([63.228.1.57]:43651 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab3KCU7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 15:59:09 -0500
Message-ID: <1383512261.4776.21.camel@pasglop>
Subject: Re: perf events ring buffer memory barrier on powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Victor Kaplansky <VICTORK@il.ibm.com>
Cc: David Laight <David.Laight@aculab.com>,
        Michael Neuling <mikey@neuling.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Anton Blanchard <anton@samba.org>, paulmck@linux.vnet.ibm.com
Date: Mon, 04 Nov 2013 07:57:41 +1100
In-Reply-To: <OF57D6EF77.CD2E45CE-ON42257C16.005AA6D8-42257C16.005AB961@il.ibm.com>
References: <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
	 <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
	 <20131028132634.GO19466@laptop.lan>
	 <20131028163418.GD4126@linux.vnet.ibm.com>
	 <20131028201735.GA15629@redhat.com>
	 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
	 <20131030092725.GL4126@linux.vnet.ibm.com>
	 <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com>
	 <20131031043258.GQ4126@linux.vnet.ibm.com>
	 <OFDF23985D.1D949148-ON42257C15.002DEB25-42257C15.0036DF93@il.ibm.com>
	 <20131031152543.GC4067@linux.vnet.ibm.com>
	 <OF3CB471BA.BACC7843-ON42257C16.0055EF23-42257C16.0058875B@il.ibm.com>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B73D4@saturn3.aculab.com>
	 <OF57D6EF77.CD2E45CE-ON42257C16.005AA6D8-42257C16.005AB961@il.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 18:30 +0200, Victor Kaplansky wrote:
> "David Laight" <David.Laight@aculab.com> wrote on 11/01/2013 06:25:29 PM:
> > gcc will do unexpected memory accesses for bit fields that are
> > adjacent to volatile data.
> > In particular it may generate 64bit sized (and aligned) RMW cycles
> > when accessing bit fields.
> > And yes, this has caused real problems.
> 
> Thanks, I am aware about this bug/feature in gcc.

AFAIK, this has been fixed in 4.8 and 4.7.3 ... 

Cheers,
Ben.

> -- Victor
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


