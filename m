Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbaEPPGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:06:04 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:51331
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932159AbaEPPGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:06:02 -0400
Date: Fri, 16 May 2014 10:05:59 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: hannes@cmpxchg.org, mhocko@suse.cz, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC 1/3] slub: keep full slabs on list for per memcg
 caches
In-Reply-To: <20140516130629.GE32113@esperanza>
Message-ID: <alpine.DEB.2.10.1405161003250.32249@gentwo.org>
References: <cover.1399982635.git.vdavydov@parallels.com> <bc70b480221f7765926c8b4d63c55fb42e85baaf.1399982635.git.vdavydov@parallels.com> <alpine.DEB.2.10.1405141114040.16512@gentwo.org> <20140515063441.GA32113@esperanza> <alpine.DEB.2.10.1405151011210.24665@gentwo.org>
 <20140516130629.GE32113@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014, Vladimir Davydov wrote:

> But w/o ref-counting how can we make sure that all kfrees to the cache
> we are going to re-parent have been completed so that it can be safely
> destroyed? An example:

Keep the old structure around until the counter of slabs (partial, full)
of that old structure is zero? Move individual slab pages until you reach
zero.

One can lock out frees by setting c->page = NULL, zapping the partial list
and taking the per node list lock.

