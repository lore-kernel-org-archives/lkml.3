Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3HVQwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:52:41 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:52534 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753787Ab3HVQwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:52:40 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Aug 2013 12:52:40 EDT
Date: Thu, 22 Aug 2013 16:47:25 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] slab: overload struct slab over struct page to
 reduce memory usage
In-Reply-To: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000140a6ec66e5-a4d245c0-76b6-4a8b-9cf0-d941ca9e08b0-000000@email.amazonses.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.22-54.240.9.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013, Joonsoo Kim wrote:

> And this patchset change a management method of free objects of a slab.
> Current free objects management method of the slab is weird, because
> it touch random position of the array of kmem_bufctl_t when we try to
> get free object. See following example.

The ordering is intentional so that the most cache hot objects are removed
first.

> To get free objects, we access this array with following pattern.
> 6 -> 3 -> 7 -> 2 -> 5 -> 4 -> 0 -> 1 -> END

Because that is the inverse order of the objects being freed.

The cache hot effect may not be that significant since per cpu and per
node queues have been aded on top. So maybe we do not be so cache aware
anymore when actually touching struct slab.
