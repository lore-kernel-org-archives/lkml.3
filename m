Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3JVDsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 23:48:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10233 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab3JVDsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 23:48:54 -0400
X-IronPort-AV: E=Sophos;i="4.93,545,1378828800"; 
   d="scan'208";a="8822783"
Message-ID: <5265F5E6.3000604@cn.fujitsu.com>
Date: Tue, 22 Oct 2013 11:49:58 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: Kim <jaegeuk.kim@samsung.com>,
        f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] f2fs: introduce f2fs_kmem_cache_alloc to hide the unfailed
 kmem cache allocation
References: <5264D6C7.9000202@cn.fujitsu.com>
In-Reply-To: <5264D6C7.9000202@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/22 11:46:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/22 11:46:23,
	Serialize complete at 2013/10/22 11:46:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2013 03:24 PM, Gu Zheng wrote:
> +static inline void *f2fs_kmem_cache_alloc(struct kmem_cache *cachep,
> +						gfp_t flags)
> +{
> +	void *entry = kmem_cache_alloc(cachep, flags);
> +retry:

retry after kmem_cache_alloc?

> +	if (!entry) {
> +		cond_resched();
> +		goto retry;
> +	}
> +
> +	return entry;
> +}

