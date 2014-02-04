Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaBDUuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:50:54 -0500
Received: from qmta07.westchester.pa.mail.comcast.net ([76.96.62.64]:35674
	"EHLO qmta07.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440AbaBDUuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:50:51 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Feb 2014 15:50:51 EST
Date: Tue, 4 Feb 2014 14:44:43 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, rientjes@google.com, penberg@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: fix false-positive lockdep warning in
 free_partial()
In-Reply-To: <1391517397-6142-1-git-send-email-vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1402041444140.11222@nuc>
References: <1391517397-6142-1-git-send-email-vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014, Vladimir Davydov wrote:

> Although this cannot actually result in a race, because on cache
> destruction there should not be any concurrent frees or allocations from
> the cache, let's add spin_lock/unlock to free_partial() just to keep
> lockdep happy.

Please add a comment that says this in the source so we know why this was
added.
