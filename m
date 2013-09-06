Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3IFP6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:58:22 -0400
Received: from a10-63.smtp-out.amazonses.com ([54.240.10.63]:53976 "EHLO
	a10-63.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753005Ab3IFP6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:58:20 -0400
Date: Fri, 6 Sep 2013 15:58:18 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH 3/4] slab: introduce byte sized index for the
 freelist of a slab
In-Reply-To: <1378447067-19832-4-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000140f3fed229-f49b95d4-7087-476f-b2c9-37846749aad6-000000@email.amazonses.com>
References: <1378447067-19832-1-git-send-email-iamjoonsoo.kim@lge.com> <1378447067-19832-4-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.06-54.240.10.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Sep 2013, Joonsoo Kim wrote:

> Currently, the freelist of a slab consist of unsigned int sized indexes.
> Most of slabs have less number of objects than 256, since restriction
> for page order is at most 1 in default configuration. For example,
> consider a slab consisting of 32 byte sized objects on two continous
> pages. In this case, 256 objects is possible and these number fit to byte
> sized indexes. 256 objects is maximum possible value in default
> configuration, since 32 byte is minimum object size in the SLAB.
> (8192 / 32 = 256). Therefore, if we use byte sized index, we can save
> 3 bytes for each object.

Ok then why is the patch making slab do either byte sized or int sized
indexes? Seems that you could do a clean cutover?


As you said: The mininum object size is 32 bytes for slab. 32 * 256 =
8k. So we are fine unless the page size is > 8k. This is true for IA64 and
powerpc only I believe. The page size can be determined at compile time
and depending on that page size you could then choose a different size for
the indexes. Or the alternative is to increase the minimum slab object size.
A 16k page size would require a 64 byte minimum allocation. But thats no
good I guess. byte sized or short int sized index support would be enough.

> This introduce one likely branch to functions used for setting/getting
> objects to/from the freelist, but we may get more benefits from
> this change.

Lets not do that.
