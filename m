Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbbAPDaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 22:30:16 -0500
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:41191 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753656AbbAPDaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 22:30:14 -0500
Date: Thu, 15 Jan 2015 21:30:12 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 2/2] mm: don't use compound_head() in
 virt_to_head_page()
In-Reply-To: <20150115171646.8fec31e2.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.11.1501152128460.13976@gentwo.org>
References: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com> <1421307633-24045-2-git-send-email-iamjoonsoo.kim@lge.com> <20150115171646.8fec31e2.akpm@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015, Andrew Morton wrote:

> And perhaps some explanation here as to why virt_to_head_page() can
> safely use compound_head_fast().  There's an assumption here that
> nobody will be dismantling the compound page while virt_to_head_page()
> is in progress, yes?  And this assumption also holds for the calling
> code, because otherwise the virt_to_head_page() return value is kinda
> meaningless.

I think this assumption is pretty natural to make. A coupound_head that
works well while dismantling a compound page should be marked specially
and Joonsoo's definition should be the standard.


