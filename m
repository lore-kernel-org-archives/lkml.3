Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031135AbaLLR1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:27:45 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:44718 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbaLLR1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:27:44 -0500
Date: Fri, 12 Dec 2014 12:27:39 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 4/5] workqueue: update NUMA affinity for the node lost CPU
Message-ID: <20141212172739.GD20020@htj.dyndns.org>
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
 <1418379595-6281-5-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418379595-6281-5-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 06:19:54PM +0800, Lai Jiangshan wrote:
> We fixed the major cases when the numa mapping is changed.
> 
> We still have the assumption that when the node<->cpu mapping is changed
> the original node is offline, and the current code of memory-hutplug also
> prove this.
> 
> This assumption might be changed in future and the orig_node is still online
> in some cases.  And in these cases, the cpumask of the pwqs of the orig_node
> still contains the onlining CPU which is a CPU of another node, and the worker
> may run on the onlining CPU (aka run on the wrong node).
> 
> So we drop this assumption and make the code calls wq_update_unbound_numa()
> to update the affinity in this case.

This is seriously obfuscating.  I really don't think meddling with
existing pools is a good idea.  The foundation those pools were
standing are gone.  Drain and discard the pools.  Please don't try to
retro-fit it to new foundations.

Thanks.

-- 
tejun
