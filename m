Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbbAPD1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 22:27:20 -0500
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:35410 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781AbbAPD1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 22:27:18 -0500
Date: Thu, 15 Jan 2015 21:27:14 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 1/2] mm/slub: optimize alloc/free fastpath by removing
 preemption on/off
In-Reply-To: <20150115203045.00e9fb73@grimm.local.home>
Message-ID: <alpine.DEB.2.11.1501152126300.13976@gentwo.org>
References: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com> <20150115171634.685237a4.akpm@linux-foundation.org> <20150115203045.00e9fb73@grimm.local.home>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015, Steven Rostedt wrote:

> profiling function tracing I discovered that accessing preempt_count
> was actually quite expensive, even just to read. But it may not be as
> bad since Peter Zijlstra converted preempt_count to a per_cpu variable.
> Although, IIRC, the perf profiling showed the access to the %gs
> register was where the time consuming was happening, which is what
> I believe per_cpu variables still use.

The %gs register is not used since the address of the per cpu area is
available as one of the first fields in the per cpu areas.

