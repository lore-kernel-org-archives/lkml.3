Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbaE3Oba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:31:30 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:44502 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856AbaE3Ob3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:31:29 -0400
Date: Fri, 30 May 2014 09:31:26 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 1/8] memcg: cleanup memcg_cache_params refcnt usage
In-Reply-To: <3c02e9f973fcce5691fbf4b6d33665174326c4d5.1401457502.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1405300931140.11943@gentwo.org>
References: <cover.1401457502.git.vdavydov@parallels.com> <3c02e9f973fcce5691fbf4b6d33665174326c4d5.1401457502.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014, Vladimir Davydov wrote:

> Currently, we count the number of pages allocated to a per memcg cache
> in memcg_cache_params->nr_pages. We only use this counter to find out if
> the cache is empty and can be destroyed. So let's rename it to refcnt
> and make it count not pages, but slabs so that we can use atomic_inc/dec
> instead of atomic_add/sub in memcg_charge/uncharge_slab.

Acked-by: Christoph Lameter <cl@linux.com>
