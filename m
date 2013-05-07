Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3EGO2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:28:53 -0400
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:51007 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908Ab3EGO2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:28:51 -0400
Date: Tue, 7 May 2013 14:28:49 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <201305071938.DAC81273.HOSJOFFOQLtMFV@I-love.SAKURA.ne.jp>
Message-ID: <0000013e7f651028-9a57bc30-4148-4aba-a0e6-737b83bf2458-000000@email.amazonses.com>
References: <0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com> <201305040348.CIF81716.OStQOHFJMFLOVF@I-love.SAKURA.ne.jp> <0000013e6bd7a766-8473586c-7937-4129-bad1-a4198acdddcf-000000@email.amazonses.com>
 <201305040915.AID02071.FHVQJtOFOMOLSF@I-love.SAKURA.ne.jp> <0000013e7a18153d-4b59eaf6-0fcd-4eec-b357-31d3d40baa7d-000000@email.amazonses.com> <201305071938.DAC81273.HOSJOFFOQLtMFV@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.07-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 May 2013, Tetsuo Handa wrote:

> > These are exclusively from the module load. So the kernel seems to be
> > clean of large kmalloc's ?
> >
> There are modules (e.g. TOMOYO) which do not check for KMALLOC_MAX_SIZE limit
> and expect kmalloc() larger than KMALLOC_MAX_SIZE bytes to return NULL.

Dont do that. Please fix these things. The slab allocators are for small
allocations not large ones like these. There are page allocator functions
that allow higher order allocations if contiguous memory is needed and
there is vmalloc that makes it safe. We  recently added a CMA allocator
specifically for these large contiguous physical allocations.

> As far as I know, such modules sequentially double the buffer size. Therefore,
> as long as request for KMALLOC_MAX_SIZE * 2 bytes returns NULL, they won't
> trigger oops by requesting for KMALLOC_MAX_SIZE * 8 bytes.

Please use vmalloc for these large allocs.

