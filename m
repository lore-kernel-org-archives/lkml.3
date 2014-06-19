Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbaFSQP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:15:58 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:58103 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663AbaFSQP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:15:57 -0400
Date: Thu, 19 Jun 2014 12:15:53 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: use "pool->cpu < 0" to stand for an unbound
 pool
Message-ID: <20140619161553.GI26904@htj.dyndns.org>
References: <1401780714-12127-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401780714-12127-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 03:31:45PM +0800, Lai Jiangshan wrote:
> There is a piece of sanity checks code in the put_unbound_pool().
> The meaning of this code is "if it is not an unbound pool, it will complain
> and return" IIUC. But the code uses "pool->flags & POOL_DISASSOCIATED"
> imprecisely due to a non-unbound pool may also have this flags.
> 
> We should use "pool->cpu < 0" to stand for an unbound pool, so we covert the
> code to it.
> 
> There is no strictly wrong if we still keep "pool->flags & POOL_DISASSOCIATED"
> here, but it is just a noise if we keep it:
>   1) we focus on "unbound" here, not "[dis]association".
>   2) "pool->cpu < 0" already implies "pool->flags & POOL_DISASSOCIATED".
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.17.

Thansk.

-- 
tejun
