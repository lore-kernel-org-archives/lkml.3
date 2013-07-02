Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab3GBOPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 10:15:45 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:50696 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335Ab3GBOPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:15:44 -0400
Date: Tue, 2 Jul 2013 14:15:42 +0000
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
In-Reply-To: <51d218df.a77d440a.3cfe.ffffe64aSMTPIN_ADDED_BROKEN@mx.google.com>
Message-ID: <0000013f9fbd247d-8de715f1-e0dc-47fb-8f06-af6c061044be-000000@email.amazonses.com>
References: <1372291059-9880-1-git-send-email-liwanp@linux.vnet.ibm.com> <0000013f9b8d6897-d2399224-d203-4dc5-a700-90dea9be7536-000000@email.amazonses.com> <51d218df.a77d440a.3cfe.ffffe64aSMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.02-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jul 2013, Wanpeng Li wrote:

> Before patch:
> Active / Total Slabs (% used) : 59018 / 59018 (100.0%)
>
> After patch:
> Active / Total Slabs (% used) : 11086 / 11153 (99.4%)

Yes I saw that.

> These numbers are dump from slabtop for monitor slub, before patch Active / Total
> Slabs are always 100%, this is not truth since empty slabs present. However, the
> slab allocator can caculate its Active / Total Slabs correctly and its value is
> less than 100.0%. By comparison, slub is more efficient than slab through slabtop
> observation, however, it is not truth since slub uncorrectly calculate its
> Active / Total Slabs.

I always thought about the "empty" slabs to be active since they are used
for allocation and frees like the other partial slabs.

