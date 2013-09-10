Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3IJNpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:45:38 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:55141 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab3IJNph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:45:37 -0400
Date: Tue, 10 Sep 2013 09:45:33 -0400
From: Tejun Heo <tj@kernel.org>
To: Libin <huawei.libin@huawei.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, wangyijing@huawei.com,
        guohanjun@huawei.com
Subject: Re: [PATCH] workqueue: remove redundant
 timer_stats_timer_set_start_info() call
Message-ID: <20130910134533.GB7275@htj.dyndns.org>
References: <1378794927-4396-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378794927-4396-1-git-send-email-huawei.libin@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 02:35:27PM +0800, Libin wrote:
> From: Li Bin <huawei.libin@huawei.com>
> 
> There is a redundant call for timer_stats_timer_set_start_info(),
> because it is the responsibility of the 'timer add' function:
> 
> add_timer_on()
> |- timer_stats_timer_set_start_info()
> 
> add_timer()
> |- mod_timer()
> 	|- __mod_timer()
> 		|- timer_stats_timer_set_start_info()
> 
> So the calling here is redundant, remove it.

I think it's intentional to record the caller's address so that timers
from delayed_work items can be distinguished.

Thanks.

-- 
tejun
