Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab3J3POw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:14:52 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:42784 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab3J3POv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:14:51 -0400
In-Reply-To: <20131030112526.GI16117@laptop.programming.kicks-ass.net>
References: <12083.1382486094@ale.ozlabs.ibm.com> <20131023141948.GB3566@localhost.localdomain> <20131025173749.GG19466@laptop.lan> <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com> <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com> <20131028132634.GO19466@laptop.lan> <20131028163418.GD4126@linux.vnet.ibm.com> <20131028201735.GA15629@redhat.com> <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com> <20131030092725.GL4126@linux.vnet.ibm.com> <20131030112526.GI16117@laptop.programming.kicks-ass.net>
Subject: Re: perf events ring buffer memory barrier on powerpc
X-KeepSent: F6C78E48:E477DB1E-42257C14:0050F9B3;
 type=4; name=$KeepSent
To: Peter Zijlstra <peterz@infradead.org>
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFF6C78E48.E477DB1E-ON42257C14.0050F9B3-42257C14.0051AC6D@il.ibm.com>
From: Victor Kaplansky <VICTORK@il.ibm.com>
Date: Wed, 30 Oct 2013 16:52:05 +0200
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5|July 31, 2013) at
 30/10/2013 17:06:07
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103015-3548-0000-0000-000006FEFE7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote on 10/30/2013 01:25:26 PM:

> Also, I'm not entirely sure on C, that too seems like a dependency, we
> simply cannot read the buffer @tail before we've read the tail itself,
> now can we? Similarly we cannot compare tail to head without having the
> head read completed.

No, this one we cannot omit, because our problem on consumer side is not
with @tail, which is written exclusively by consumer, but with @head.

BTW, it is why you also don't need ACCESS_ONCE() around @tail, but only
around
@head read.

-- Victor

