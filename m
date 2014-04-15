Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaDOPRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:17:13 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:37788
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752798AbaDOPRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:17:08 -0400
Date: Tue, 15 Apr 2014 10:17:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org,
        mhocko@suse.cz, glommer@gmail.com, penberg@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, devel@openvz.org
Subject: Re: [PATCH -mm 1/4] memcg, slab: do not schedule cache destruction
 when last page goes away
In-Reply-To: <534CD08F.30702@parallels.com>
Message-ID: <alpine.DEB.2.10.1404151016400.11231@gentwo.org>
References: <cover.1397054470.git.vdavydov@parallels.com> <8ea8b57d5264f16ee33497a4317240648645704a.1397054470.git.vdavydov@parallels.com> <20140415021614.GC7969@cmpxchg.org> <534CD08F.30702@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Vladimir Davydov wrote:

> 2) When freeing an object of a dead memcg cache, initiate thorough check
> if the cache is really empty and destroy it then. That could be
> implemented by poking the reaping thread on kfree, and actually does not
> require the schedule_work in memcg_release_pages IMO.

There is already logic in both slub and slab that does that on cache
close.

