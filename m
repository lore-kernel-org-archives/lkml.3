Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab3GAPqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:46:55 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:33166 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250Ab3GAPqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:46:54 -0400
Date: Mon, 1 Jul 2013 15:46:52 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/slab: Fix drain freelist excessively
In-Reply-To: <1372069394-26167-1-git-send-email-liwanp@linux.vnet.ibm.com>
Message-ID: <0000013f9aea494f-7a5fe6c7-47d2-42a9-bbe6-5dbc85dab0a5-000000@email.amazonses.com>
References: <1372069394-26167-1-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013, Wanpeng Li wrote:

> The drain_freelist is called to drain slabs_free lists for cache reap,
> cache shrink, memory hotplug callback etc. The tofree parameter is the
> number of slab objects to free instead of the number of slabs to free.

Well its intended to be the number of slabs to free. The patch does not
fix the callers that pass the number of slabs.

I think the best approach would be to fix the callers that pass # of
objects. Make sure they pass # of slabs.

