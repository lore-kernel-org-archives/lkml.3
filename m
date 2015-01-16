Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbbAPNlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 08:41:05 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:62535 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbbAPNlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 08:41:03 -0500
Message-ID: <1421415659.11734.131.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH v2 1/2] mm/slub: optimize alloc/free fastpath by
 removing preemption on/off
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Date: Fri, 16 Jan 2015 05:40:59 -0800
In-Reply-To: <20150115230749.5d73ad49@grimm.local.home>
References: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <20150115171634.685237a4.akpm@linux-foundation.org>
	 <20150115203045.00e9fb73@grimm.local.home>
	 <alpine.DEB.2.11.1501152126300.13976@gentwo.org>
	 <20150115225130.00c0c99a@grimm.local.home>
	 <alpine.DEB.2.11.1501152155480.14236@gentwo.org>
	 <20150115230749.5d73ad49@grimm.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-15 at 23:07 -0500, Steven Rostedt wrote:
> On Thu, 15 Jan 2015 21:57:58 -0600 (CST)
> Christoph Lameter <cl@linux.com> wrote:
> 
> > > I get:
> > >
> > > 		mov    %gs:0x18(%rax),%rdx
> > >
> > > Looks to me that %gs is used.
> > 
> > %gs is used as a segment prefix. That does not add significant cycles.
> > Retrieving the content of %gs and loading it into another register
> > would be expensive in terms of cpu cycles.
> 
> OK, maybe that's what I saw in my previous benchmarks. Again, that was
> a while ago.

I made same observation about 3 years ago, on old cpus.


