Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbbAFXM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 18:12:58 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:60775 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbbAFXM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 18:12:57 -0500
Date: Tue, 6 Jan 2015 18:12:53 -0500
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH block/for-next 4/4] block: implement bio_associate_blkcg()
Message-ID: <20150106231253.GC24106@htj.dyndns.org>
References: <20141117211321.GD23126@htj.dyndns.org>
 <20141117211357.GE23126@htj.dyndns.org>
 <20141117211546.GF23126@htj.dyndns.org>
 <20141117211619.GG23126@htj.dyndns.org>
 <20141120211506.GE11595@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120211506.GE11595@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

Sorry about the delay.

On Thu, Nov 20, 2014 at 04:15:06PM -0500, Vivek Goyal wrote:
> Not sure what can be done about this. May be a notion of per
> block cgroup per device io context and always use that io context
> when bio has cgroup info but not io context info. 

I think the right thing to do here is having a dedicated ioc for
writeback traffic per cgroup and channel writebacks of the cgroup
through there.  We'd be simply extending the current global model into
each group.

Thanks.

-- 
tejun
