Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaLYUOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 15:14:12 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:63437 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaLYUOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 15:14:09 -0500
Date: Thu, 25 Dec 2014 15:14:06 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/5] workqueue: fixup existing pool->node
Message-ID: <20141225201406.GB22951@htj.dyndns.org>
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
 <1418379595-6281-4-git-send-email-laijs@cn.fujitsu.com>
 <20141212172546.GC20020@htj.dyndns.org>
 <548E3825.9020204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548E3825.9020204@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 09:23:49AM +0800, Lai Jiangshan wrote:
> The pwqs of the old node's cpumask do be discarded. But the pools of the old
> node's cpumask maybe recycle. For example, a new workqueue's affinity is set to
> the old node's cpumask before the pool is dead. Any old pool can long live.

Hah?  Why can't it just be unhashed so that it can't be looked up for
new pwqs anymore?

-- 
tejun
