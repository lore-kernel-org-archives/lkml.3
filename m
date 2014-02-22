Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbaBVALQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 19:11:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaBVALP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 19:11:15 -0500
Date: Fri, 21 Feb 2014 16:11:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: <mhocko@suse.cz>, <rientjes@google.com>, <penberg@kernel.org>,
        <cl@linux.com>, <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -mm v3 2/7] memcg, slab: cleanup memcg cache creation
Message-Id: <20140221161114.3025c658da0429b7ae9d4985@linux-foundation.org>
In-Reply-To: <210fa2501be4cbb7f7caf6ca893301f124c92a67.1392879001.git.vdavydov@parallels.com>
References: <cover.1392879001.git.vdavydov@parallels.com>
	<210fa2501be4cbb7f7caf6ca893301f124c92a67.1392879001.git.vdavydov@parallels.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014 11:22:04 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:

> This patch cleanups the memcg cache creation path as follows:
>  - Move memcg cache name creation to a separate function to be called
>    from kmem_cache_create_memcg(). This allows us to get rid of the
>    mutex protecting the temporary buffer used for the name formatting,
>    because the whole cache creation path is protected by the slab_mutex.
>  - Get rid of memcg_create_kmem_cache(). This function serves as a proxy
>    to kmem_cache_create_memcg(). After separating the cache name
>    creation path, it would be reduced to a function call, so let's
>    inline it.

This patch makes a huge mess when it hits linux-next's e61734c5
("cgroup: remove cgroup->name").  In the vicinity of
memcg_create_kmem_cache().  That isn't the first mess e61734c5 made :(

I think I got it all fixed up - please check the end result in
http://ozlabs.org/~akpm/stuff/.

