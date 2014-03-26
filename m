Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaCZPnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 11:43:41 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:42958
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580AbaCZPnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 11:43:39 -0400
Date: Wed, 26 Mar 2014 10:43:37 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Sasha Levin <sasha.levin@oracle.com>
cc: Michal Hocko <mhocko@suse.cz>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: slub: gpf in deactivate_slab
In-Reply-To: <53321CB6.5050706@oracle.com>
Message-ID: <alpine.DEB.2.10.1403261042360.2057@nuc>
References: <53208A87.2040907@oracle.com> <5331A6C3.2000303@oracle.com> <20140325165247.GA7519@dhcp22.suse.cz> <alpine.DEB.2.10.1403251205140.24534@nuc> <5331B9C8.7080106@oracle.com> <alpine.DEB.2.10.1403251308590.26471@nuc> <53321CB6.5050706@oracle.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014, Sasha Levin wrote:

> I'm not sure if there's anything special about this cache, codewise it's
> created as follows:
>
>
>         inode_cachep = kmem_cache_create("inode_cache",
>                                          sizeof(struct inode),
>                                          0,
>                                          (SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
>                                          SLAB_MEM_SPREAD),
>                                          init_once);
>
>
> I'd be happy to dig up any other info required, I'm just not too sure
> what you mean by options for the cache?

Slab parameters can be change in /sys/kernel/slab/inode. Any debug
parameters active? More information about what was actually going on when
the gpf occured?

