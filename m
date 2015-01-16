Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbbAPD6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 22:58:04 -0500
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:38018 "EHLO
	resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756108AbbAPD6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 22:58:01 -0500
Date: Thu, 15 Jan 2015 21:57:58 -0600 (CST)
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
In-Reply-To: <20150115225130.00c0c99a@grimm.local.home>
Message-ID: <alpine.DEB.2.11.1501152155480.14236@gentwo.org>
References: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com> <20150115171634.685237a4.akpm@linux-foundation.org> <20150115203045.00e9fb73@grimm.local.home> <alpine.DEB.2.11.1501152126300.13976@gentwo.org>
 <20150115225130.00c0c99a@grimm.local.home>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I get:
>
> 		mov    %gs:0x18(%rax),%rdx
>
> Looks to me that %gs is used.

%gs is used as a segment prefix. That does not add significant cycles.
Retrieving the content of %gs and loading it into another register would
be expensive in terms of cpu cycles.

