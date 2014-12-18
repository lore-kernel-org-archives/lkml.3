Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaLRRsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:48:15 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47111 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaLRRsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:48:14 -0500
Date: Thu, 18 Dec 2014 12:48:11 -0500 (EST)
Message-Id: <20141218.124811.1240082913671950177.davem@davemloft.net>
To: andreas@gaisler.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH] sparc32: destroy_context() and switch_mm() needs to
 disable interrupts.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418905403-11154-1-git-send-email-andreas@gaisler.com>
References: <1418905403-11154-1-git-send-email-andreas@gaisler.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Dec 2014 09:48:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>
Date: Thu, 18 Dec 2014 13:23:23 +0100

> Load balancing can be triggered in the critical sections protected by
> srmmu_context_spinlock in destroy_context() and switch_mm() and can hang
> the cpu waiting for the rq lock of another cpu that in turn has called
> switch_mm hangning on srmmu_context_spinlock leading to deadlock.
> 
> So, disable interrupt while taking srmmu_context_spinlock in
> destroy_context() and switch_mm() so we don't deadlock.
> 
> See also commit 77b838fa1ef0 ("[SPARC64]: destroy_context() needs to disable
> interrupts.")
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Looks good, applied, thanks Andreas.
