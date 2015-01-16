Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbbAPEH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 23:07:27 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:12435 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754277AbbAPEHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 23:07:25 -0500
Date: Thu, 15 Jan 2015 23:07:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 1/2] mm/slub: optimize alloc/free fastpath by
 removing preemption on/off
Message-ID: <20150115230749.5d73ad49@grimm.local.home>
In-Reply-To: <alpine.DEB.2.11.1501152155480.14236@gentwo.org>
References: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com>
	<20150115171634.685237a4.akpm@linux-foundation.org>
	<20150115203045.00e9fb73@grimm.local.home>
	<alpine.DEB.2.11.1501152126300.13976@gentwo.org>
	<20150115225130.00c0c99a@grimm.local.home>
	<alpine.DEB.2.11.1501152155480.14236@gentwo.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 21:57:58 -0600 (CST)
Christoph Lameter <cl@linux.com> wrote:

> > I get:
> >
> > 		mov    %gs:0x18(%rax),%rdx
> >
> > Looks to me that %gs is used.
> 
> %gs is used as a segment prefix. That does not add significant cycles.
> Retrieving the content of %gs and loading it into another register
> would be expensive in terms of cpu cycles.

OK, maybe that's what I saw in my previous benchmarks. Again, that was
a while ago.

-- Steve
