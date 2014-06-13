Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaFMQen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:34:43 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:39473 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbaFMQem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:34:42 -0400
Date: Fri, 13 Jun 2014 11:34:39 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Vladimir Davydov <vdavydov@parallels.com>, akpm@linux-foundation.org,
        rientjes@google.com, penberg@kernel.org, hannes@cmpxchg.org,
        mhocko@suse.cz, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v2 8/8] slab: make dead memcg caches discard free
 slabs immediately
In-Reply-To: <20140612065345.GD19918@js1304-P5Q-DELUXE>
Message-ID: <alpine.DEB.2.10.1406131133380.913@gentwo.org>
References: <cover.1402060096.git.vdavydov@parallels.com> <27a202c6084d6bb19cc3e417793f05104b908ded.1402060096.git.vdavydov@parallels.com> <20140610074317.GE19036@js1304-P5Q-DELUXE> <20140610100313.GA6293@esperanza> <alpine.DEB.2.10.1406100925270.17142@gentwo.org>
 <20140610151830.GA8692@esperanza> <20140611212431.GA16589@esperanza> <20140612065345.GD19918@js1304-P5Q-DELUXE>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Joonsoo Kim wrote:

> BTW, I have a question about cache_reap(). If there are many kmemcg
> users, we would have a lot of slab caches and just to traverse slab
> cache list could take some times. Is it no problem?

Its a big problem and one of the reasons that SLUB was developed. Cache
reaping caused noticable random delays to processing which was
significantly impacting HPC loads of SGI.


