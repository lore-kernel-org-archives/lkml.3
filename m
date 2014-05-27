Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaE0O1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:27:45 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:55346 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaE0O1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:27:39 -0400
Date: Tue, 27 May 2014 10:27:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueue: always pass cascading responsibility to
 the next flusher
Message-ID: <20140527142736.GD22767@htj.dyndns.org>
References: <1401105501-13307-1-git-send-email-laijs@cn.fujitsu.com>
 <20140527142443.GC22767@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527142443.GC22767@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 10:24:43AM -0400, Tejun Heo wrote:
> So, I think hiding latencies which can easily in millisecs range is
> important.  It isn't a performance optimization.  It almost becomes a
> correctness issue when the problem is severely hit and the amount of

Another way to think about it is considering flushing an event
notification mechanism.  Doing the above can reliably induce tens of
millisecs of latency in event delivery on the right combination of
work items and flush patterns, which isn't acceptable.  We sure still
can fail to such state when the flush color space is exhausted but
this is a lot easier to trigger.

Thanks.

-- 
tejun
