Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaLYURk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 15:17:40 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:65003 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaLYURj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 15:17:39 -0500
Date: Thu, 25 Dec 2014 15:17:35 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 4/5] workqueue: update NUMA affinity for the node lost CPU
Message-ID: <20141225201735.GD22951@htj.dyndns.org>
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
 <1418379595-6281-5-git-send-email-laijs@cn.fujitsu.com>
 <20141212172739.GD20020@htj.dyndns.org>
 <548E3948.7040105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548E3948.7040105@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 09:28:40AM +0800, Lai Jiangshan wrote:
> > The foundation those pools were standing are gone.
> 
> This statement is not true unless we write some code to force them,
> dequeue them from the unbound_pool_hash, for example.

Yeah, that's the obvious thing to do.  Those pools are dead.  Take
them off the namespace and drain the existing usages.

-- 
tejun
