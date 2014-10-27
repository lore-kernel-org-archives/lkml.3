Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaJ0NUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:20:54 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:48887 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJ0NUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:20:52 -0400
Date: Mon, 27 Oct 2014 09:20:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] workqueue: extend wq_pool_mutex to also protect
 pwq-installation
Message-ID: <20141027132047.GE4436@htj.dyndns.org>
References: <1412740423-20782-1-git-send-email-laijs@cn.fujitsu.com>
 <1412740423-20782-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412740423-20782-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, Oct 08, 2014 at 11:53:32AM +0800, Lai Jiangshan wrote:
> Athough pwq-installation without wq_pool_mutex held is not bug,
> but it is not good design, it is better to make the pwq-allocation and installation
> are in the (same) wq_pool_mutex.

WHY?  Why is that not a good design and why is extending the locking a
better thing to do?  Can you elaborate the reasoning here?

> And since the pwq-allocation and installation are in the same wq_pool_mutex,
> get_online_cpus() will not be needed for this reason, and it will be remove
> in later patch.

So, if this enables further cleanup, it's fine, but please just stick
to those reasons.  You do this a lot.  You wanna do A because of B but
the changelog often doesn't mention that at all and just goes "This is
bad so change this to be better" without any proper reasoning.  If you
want to do A to achieve B later, just say so.

Thanks.

-- 
tejun
