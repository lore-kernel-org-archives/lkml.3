Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaJ1UXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:23:00 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:57257 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaJ1UW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:22:58 -0400
Date: Tue, 28 Oct 2014 16:22:55 -0400
From: Tejun Heo <tj@kernel.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org >> Linux Kernel Mailing List" 
	<linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: blk-mq vs cpu hotplug performance (due to percpu_ref_put
 performance)
Message-ID: <20141028202255.GB8205@htj.dyndns.org>
References: <544FF00B.8050403@de.ibm.com>
 <20141028200055.GA8205@htj.dyndns.org>
 <544FFAA7.1060705@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544FFAA7.1060705@de.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:20:55PM +0100, Christian Borntraeger wrote:
> I have not verified this, but I guess what happens is:
> hotplug
> -> notify
> -> blk_mq_queue_reinit_notify
> -> blk_mq_queue_reinit
> -> blk_mq_freeze_queue
> -> percpu_ref_kill
> -> percpu_ref_kill_and_confirm
> -> __percpu_ref_switch_to_atomic
> -> call_rcu_sched  

But call_rcu_sched() wouldn't show up as latency.  It's an async call
unlike synchronize_*().

Thanks.

-- 
tejun
