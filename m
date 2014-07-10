Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaGJHqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:46:46 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35704 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaGJHqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:46:44 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-1a-53be44e18c61
Message-id: <53BE4398.6020509@samsung.com>
Date: Thu, 10 Jul 2014 11:41:12 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 11/21] mm: slub: share slab_err and
 object_err functions
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1404905415-9046-12-git-send-email-a.ryabinin@samsung.com>
 <alpine.DEB.2.11.1407090928530.1384@gentwo.org>
In-reply-to: <alpine.DEB.2.11.1407090928530.1384@gentwo.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t/xy7oPXfYFG2w5pmXxe+9MVos569ew
	WSyfM5fJYsLDNnaLld3NbBbbn71lsljZ+YDVYtPja6wWf3btYLK4vGsOm8W9Nf9ZLW5f5rW4
	dGABk0XLvgtMFm2f/7Fa7Ft5HshaspHJYvGR28wW755NZrbYvGkqs8WPDY9ZHUQ9Wpp72Dz2
	Hy7y2DnrLrvHgk2lHptWdbJ5bPo0id2j6+0VJo93586xe5yY8ZvFY/OSeo+PT2+xeLzfd5XN
	48yCI+wenzfJBfBFcdmkpOZklqUW6dslcGUc2/yIseA6S8Xr1z9YGhhvMXcxcnJICJhIdM94
	yQ5hi0lcuLeerYuRi0NIYCmjROP3d8wQTjOTxKHnd1i6GDk4eAW0JJ6cEANpYBFQlfj7ZivY
	IDYBPYl/s7azgdiiAhESB/qesYLYvAKCEj8m32MBsUWA6q/PPA22gFngMqtE94urYEXCAvES
	nRe+QS3bwihxd9lZsJM4BWwkTnyYALaBWUBHYn/rNDYIW15i85q3zBMYBWYhWTILSdksJGUL
	GJlXMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoTE8ZcdjIuPWR1iFOBgVOLh1ajdHSzEmlhW
	XJl7iFGCg1lJhHeb3b5gId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYxptbO2hCTZv3rEs23p0b3R
	8jqMs9e6rBE/8GOh1p1r95P7mjKFfhufcnBx4Ez5GTG3fYrSq5vPG1SXfzHe1P9m47KJx7of
	vGX8n3hGP3R/k+inHhWpedOzy5fttdw4Of7FlCyhmGUTIyK2eu4X3C5yq+AswyIWDycdzRNd
	EbHhGybvKmc+8t9YiaU4I9FQi7moOBEA6cam2sECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/14 18:29, Christoph Lameter wrote:
> On Wed, 9 Jul 2014, Andrey Ryabinin wrote:
> 
>> Remove static and add function declarations to mm/slab.h so they
>> could be used by kernel address sanitizer.
> 
> Hmmm... This is allocator specific. At some future point it would be good
> to move error reporting to slab_common.c and use those from all
> allocators.
> 

I could move declarations to kasan internals, but it will look ugly too.
I also had an idea about unifying SLAB_DEBUG and SLUB_DEBUG at some future.
I can't tell right now how hard it will be, but it seems doable.

