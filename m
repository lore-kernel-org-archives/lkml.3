Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaE0Oig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:38:36 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:34932 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037AbaE0Oib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:38:31 -0400
Date: Tue, 27 May 2014 09:38:28 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: hannes@cmpxchg.org, mhocko@suse.cz, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC 3/3] slub: reparent memcg caches' slabs on memcg
 offline
In-Reply-To: <20140523195728.GA21344@esperanza>
Message-ID: <alpine.DEB.2.10.1405270937270.14154@gentwo.org>
References: <20140519152437.GB25889@esperanza> <alpine.DEB.2.10.1405191056580.22956@gentwo.org> <537A4D27.1050909@parallels.com> <alpine.DEB.2.10.1405210937440.8038@gentwo.org> <20140521150408.GB23193@esperanza> <alpine.DEB.2.10.1405211912400.4433@gentwo.org>
 <20140522134726.GA3147@esperanza> <alpine.DEB.2.10.1405221422390.15766@gentwo.org> <20140523152642.GD3147@esperanza> <alpine.DEB.2.10.1405231241250.22913@gentwo.org> <20140523195728.GA21344@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2014, Vladimir Davydov wrote:

> > If you look at the end of unfreeze_partials() you see that we release
> > locks and therefore enable preempt before calling into the page allocator.
>
> Yes, we release the node's list_lock before calling discard_slab(), but
> we don't enable irqs, which are disabled in put_cpu_partial(), just
> before calling it, so we call the page allocator with irqs off and
> therefore preemption disabled.

Ok that is something that could be fixed.
