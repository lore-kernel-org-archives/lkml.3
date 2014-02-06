Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaBFQXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:23:04 -0500
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:51069
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbaBFQXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:23:02 -0500
Date: Thu, 6 Feb 2014 10:22:58 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Vladimir Davydov <vdavydov@parallels.com>
cc: penberg@kernel.org, akpm@linux-foundation.org, rientjes@google.com,
        mhocko@suse.cz, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        devel@openvz.org
Subject: Re: [PATCH RFC] slub: do not drop slab_mutex for
 sysfs_slab_{add,remove}
In-Reply-To: <1391702294-27289-1-git-send-email-vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1402061021180.4927@nuc>
References: <1391702294-27289-1-git-send-email-vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014, Vladimir Davydov wrote:

> When creating/destroying a kmem cache, we do a lot of work holding the
> slab_mutex, but we drop it for sysfs_slab_{add,remove} for some reason.
> Since __kmem_cache_create and __kmem_cache_shutdown are extremely rare,
> I propose to simplify locking by calling sysfs_slab_{add,remove} w/o
> dropping the slab_mutex.

The problem is that sysfs does nasty things like spawning a process in
user space that may lead to something wanting to create slabs too. The
module may then hang waiting on the lock ...

I would be very thankful, if you can get that actually working reliably
without deadlock issues.

