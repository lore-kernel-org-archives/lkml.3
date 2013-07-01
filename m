Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab3GASpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:45:07 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:42579 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754652Ab3GASpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:45:05 -0400
Date: Mon, 1 Jul 2013 18:45:03 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/slub: Fix slub calculate active slabs
 uncorrectly
In-Reply-To: <1372291059-9880-1-git-send-email-liwanp@linux.vnet.ibm.com>
Message-ID: <0000013f9b8d6897-d2399224-d203-4dc5-a700-90dea9be7536-000000@email.amazonses.com>
References: <1372291059-9880-1-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.01-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013, Wanpeng Li wrote:

> Enough slabs are queued in partial list to avoid pounding the page allocator
> excessively. Entire free slabs are not discarded immediately if there are not
> enough slabs in partial list(n->partial < s->min_partial). The number of total
> slabs is composed by the number of active slabs and the number of entire free
> slabs, however, the current logic of slub implementation ignore this which lead
> to the number of active slabs and the number of total slabs in slabtop message
> is always equal. This patch fix it by substract the number of entire free slabs
> in partial list when caculate active slabs.

What do you mean by "active" slabs? If this excludes the small number of
empty slabs that could be present then indeed you will not have that
number. But why do you need that?

The number of total slabs is the number of partial slabs, plus the number
of full slabs plus the number of percpu slabs.
