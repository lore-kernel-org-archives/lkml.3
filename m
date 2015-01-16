Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbbAPEDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 23:03:47 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:28078 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752983AbbAPEDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 23:03:46 -0500
Date: Thu, 15 Jan 2015 23:04:09 -0500
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
Message-ID: <20150115230409.2b37c071@grimm.local.home>
In-Reply-To: <20150115225130.00c0c99a@grimm.local.home>
References: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com>
	<20150115171634.685237a4.akpm@linux-foundation.org>
	<20150115203045.00e9fb73@grimm.local.home>
	<alpine.DEB.2.11.1501152126300.13976@gentwo.org>
	<20150115225130.00c0c99a@grimm.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 22:51:30 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> I haven't done benchmarks in a while, so perhaps accessing the %gs
> segment isn't as expensive as I saw it before. I'll have to profile
> function tracing on my i7 and see where things are slow again.

I just ran it on my i7, and yeah, the %gs access isn't much worse than
any of the other instructions. I had an old box that recently died that
I did my last benchmarks on, so that was probably why it made such a
difference.

-- Steve

