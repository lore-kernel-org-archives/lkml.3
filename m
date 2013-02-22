Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab3BVLQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 06:16:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50272 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3BVLQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 06:16:12 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <51275364.3010908@jp.fujitsu.com>
Date: Fri, 22 Feb 2013 20:15:48 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] slub: correctly bootstrap boot caches
References: <1361529030-17462-1-git-send-email-glommer@parallels.com>
In-Reply-To: <1361529030-17462-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/02/22 19:30), Glauber Costa wrote:
> After we create a boot cache, we may allocate from it until it is bootstraped.
> This will move the page from the partial list to the cpu slab list. If this
> happens, the loop:
> 
> 	list_for_each_entry(p, &n->partial, lru)
> 
> that we use to scan for all partial pages will yield nothing, and the pages
> will keep pointing to the boot cpu cache, which is of course, invalid. To do
> that, we should flush the cache to make sure that the cpu slab is back to the
> partial list.
> 
> Although not verified in practice, I also point out that it is not safe to scan
> the full list only when debugging is on in this case. As unlikely as it is, it
> is theoretically possible for the pages to be full. If they are, they will
> become unreachable. Aside from scanning the full list, we also need to make
> sure that the pages indeed sit in there: the easiest way to do it is to make
> sure the boot caches have the SLAB_STORE_USER debug flag set.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Reported-by:  Steffen Michalke <StMichalke@web.de>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
You're quick :) the issue is fixed in my environ.

Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu,com>


