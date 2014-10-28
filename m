Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaJ1UBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:01:00 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:59685 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaJ1UA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:00:59 -0400
Date: Tue, 28 Oct 2014 16:00:55 -0400
From: Tejun Heo <tj@kernel.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org >> Linux Kernel Mailing List" 
	<linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: blk-mq vs cpu hotplug performance (due to percpu_ref_put
 performance)
Message-ID: <20141028200055.GA8205@htj.dyndns.org>
References: <544FF00B.8050403@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544FF00B.8050403@de.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Oct 28, 2014 at 08:35:39PM +0100, Christian Borntraeger wrote:
> when going from 3.17 to 3.18-rc2 cpu hotplug become horrible slow on some KVM guests on s390
> 
> I was able to bisect this to
> 
> commit 9eca80461a45177e456219a9cd944c27675d6512
> ("Revert "blk-mq, percpu_ref: implement a kludge for SCSI blk-mq stall during probe")

That removes the earlier kludge to avoid the RCU delay so RCU
latencies are expected to show up right after; however, the following
patches implement proper fix for the problem and the latencies
shouldn't be visible afterwards.

So, 17497acbdce9 ("blk-mq, percpu_ref: start q->mq_usage_counter in
atomic mode") should remove the latencies again.  It doesn't?

Thanks.

-- 
tejun
