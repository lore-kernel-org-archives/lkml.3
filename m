Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3CTRSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:18:53 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:44985 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab3CTRSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:18:52 -0400
Date: Wed, 20 Mar 2013 10:18:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/21] workqueue: add missing POOL_FREEZING
Message-ID: <20130320171833.GA28968@htj.dyndns.org>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
 <1363721306-2030-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363721306-2030-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 03:28:01AM +0800, Lai Jiangshan wrote:
> When we create a new pool via get_unbound_pool() when freezing.
> the pool->flags' POOL_FREEZING is incorrect.
> 
> Fix it by adding POOL_FREEZING if workqueue_freezing.
> (wq_mutex is already held for accessing workqueue_freezing.)
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Ah, you're absolutely right.  What was I thinking adding
CONFIG_FREEZER around workqueue_freezing.  I'll popping that one and
applying this one.  Thanks for catching this.

-- 
tejun
