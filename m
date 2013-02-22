Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab3BVQLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 11:11:37 -0500
Received: from mx0.parallels.com ([199.115.104.20]:36609 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775Ab3BVQLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 11:11:33 -0500
Message-ID: <512798CC.2080501@parallels.com>
Date: Fri, 22 Feb 2013 20:11:56 +0400
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
References: <1361529030-17462-1-git-send-email-glommer@parallels.com> <0000013d026b4e5f-1b3deecb-7e37-4476-a27b-3a7db8c1f0a8-000000@email.amazonses.com> <51278A12.4000504@parallels.com> <0000013d028eec8e-012456de-9b98-4bcb-9427-2fbee58ecc74-000000@email.amazonses.com> <5127928A.20000@parallels.com> <0000013d02ab8230-de441d64-395f-4c87-89e7-3f2cd2209680-000000@email.amazonses.com>
In-Reply-To: <0000013d02ab8230-de441d64-395f-4c87-89e7-3f2cd2209680-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 08:10 PM, Christoph Lameter wrote:
> kmem_cache_node creation runs before PARTIAL and kmem_cache runs
> after. So there would be 2 kmem_cache_node structures allocated. Ok so
> that would use cpu slabs and therefore remove pages from the partial list.
> Pushing that back using the flushing should fix this. But I thought there
> was already code that went through the cpu slabs to address this?

not in bootstrap(), which is quite primitive. (and should remain so)

