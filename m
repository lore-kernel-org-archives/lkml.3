Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab3BVPIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 10:08:47 -0500
Received: from mx0.parallels.com ([199.115.104.20]:34492 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab3BVPIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 10:08:42 -0500
Message-ID: <51278A12.4000504@parallels.com>
Date: Fri, 22 Feb 2013 19:09:06 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] slub: correctly bootstrap boot caches
References: <1361529030-17462-1-git-send-email-glommer@parallels.com> <0000013d026b4e5f-1b3deecb-7e37-4476-a27b-3a7db8c1f0a8-000000@email.amazonses.com>
In-Reply-To: <0000013d026b4e5f-1b3deecb-7e37-4476-a27b-3a7db8c1f0a8-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 07:00 PM, Christoph Lameter wrote:
> On Fri, 22 Feb 2013, Glauber Costa wrote:
> 
>> Although not verified in practice, I also point out that it is not safe to scan
>> the full list only when debugging is on in this case. As unlikely as it is, it
>> is theoretically possible for the pages to be full. If they are, they will
>> become unreachable. Aside from scanning the full list, we also need to make
>> sure that the pages indeed sit in there: the easiest way to do it is to make
>> sure the boot caches have the SLAB_STORE_USER debug flag set.
> 
> SLAB_STORE_USER typically increases the size of the managed object. It is
> not available when slab debugging is not compiled in. There is no list of
> full slab objects that is maintained in the non debug case and if the
> allocator is compiled without debug support also the code to manage full
> lists will not be present.
> 
> Only one or two kmem_cache item is allocated in the bootstrap code and so
> far the size of the objects was signficantly smaller than page size. So
> the slab pages will be on the partial lists. Why are your slab management
> structures so large that a page can no longer contain multiple objects?
> 
They are not.

As I've mentioned in the description, the real bug is from partial slabs
being temporarily in the cpu_slab during a recent allocation and
therefore unreachable through the partial list.

I've just read the code, and it seemed to me that theoretically that
could happen. I agree with you that this is an unlikely scenario and if
you prefer I can resend the patch without that part.

Would that be preferable ?

