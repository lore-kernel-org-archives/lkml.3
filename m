Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab3AQVWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:22:23 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:57410 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293Ab3AQVWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:22:21 -0500
Date: Thu, 17 Jan 2013 21:22:18 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        RT <linux-rt-users@vger.kernel.org>, Clark Williams <clark@redhat.com>,
        John Kacur <jkacur@gmail.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: Re: [RFC][PATCH] slub: Check for page NULL before doing the node_match
 check
In-Reply-To: <1358446258.23211.32.camel@gandalf.local.home>
Message-ID: <0000013c4a64146b-68cd6f7d-f7e2-460b-9ee5-d931714ce062-000000@email.amazonses.com>
References: <1358446258.23211.32.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013, Steven Rostedt wrote:

> Anyway, looking at where this crashed, it seems that the page variable
> can be NULL when passed to the node_match() function (which does not
> check if it is NULL). When this happens we get the above panic.
>
> As page is only used in slab_alloc() to check if the node matches, if
> it's NULL I'm assuming that we can say it doesn't and call the
> __slab_alloc() code. Is this a correct assumption?

c->page should only be NULL when c->freelist == NULL but obviously there
are race conditions where c->freelist may not have been zapped but c->page
was.

