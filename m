Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab3BGBJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:09:19 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:50857 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3BGBJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:09:18 -0500
Date: Thu, 7 Feb 2013 10:09:14 +0900
From: Simon Horman <horms@verge.net.au>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Julian Anastasov <ja@ssi.bg>, Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org, mgorman@suse.de
Subject: Re: [PATCH 6/7] net: change type of netns_ipvs->sysctl_sync_qlen_max
Message-ID: <20130207010914.GA9070@verge.net.au>
References: <alpine.LFD.2.00.1302061115590.1664@ja.ssi.bg>
 <5112240C.1010105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5112240C.1010105@cn.fujitsu.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 05:36:12PM +0800, Zhang Yanfei wrote:
> 于 2013年02月06日 17:29, Julian Anastasov 写道:
> > 
> > 	Hello,
> > 
> > 	Sorry that I'm writing a private email but I
> > deleted your original message by mistake. Your change
> > of the sysctl_sync_qlen_max from int to long is may be
> > not enough.
> > 
> > 	net/netfilter/ipvs/ip_vs_ctl.c contains
> > proc var "sync_qlen_max" that should be changed to
> > sizeof(unsigned long) and updated with proc_doulongvec_minmax.
> > 
> 
> Thanks for pointing this. I will update this in patch v2.

Hi Zhang,

Thanks for helping to keep IPVS up to date.

It seems to me that include/net/ip_vs.h:sysctl_sync_qlen_max()
and its call site, net/netfilter/ipvs/ip_vs_sync.c:sb_queue_tail()
may also need to be updated.

Could you look at including that in v2 too?
