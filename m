Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3BDVi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:38:57 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:47625 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab3BDVi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:38:56 -0500
Date: Mon, 4 Feb 2013 13:38:49 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/13] workqueue: add lock_pool_own_work() and remove
 get_work_pool()
Message-ID: <20130204213849.GE27963@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-11-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-11-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 02:41:33AM +0800, Lai Jiangshan wrote:
> lock_pool_own_work() reuse lock_pool_queued_work() and lock_pool_executing_work()
> to implement "get the correct own pool and lock" logic. It makes all callings
> to lock_pool_own_work()'s mean/logic are more clear.
> 
> get_work_pool() can't get the really pool which owns the work
> and it is not used any more, just remove it.
> 
> Add/Use proper locking API.

I like they're being collected into one interface although the name
seems a bit iffy to me.  Maybe mark the original two functions as
internal to the new locking interface?

Thanks.

-- 
tejun
