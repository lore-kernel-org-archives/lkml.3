Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaG3DXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:23:39 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:45516 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaG3DXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:23:38 -0400
Date: Tue, 29 Jul 2014 23:23:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2 V2] workqueue: use dedicated creater kthread for
 all pools
Message-ID: <20140730032334.GA15787@htj.dyndns.org>
References: <20140729021643.GA22241@mtj.dyndns.org>
 <1406625376-19177-1-git-send-email-laijs@cn.fujitsu.com>
 <20140729150459.GE4791@htj.dyndns.org>
 <53D83D33.80101@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D83D33.80101@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, Jul 30, 2014 at 08:32:51AM +0800, Lai Jiangshan wrote:
> > Why?  Just sleep and retry?  What's the point of requeueing?
> 
> Accepted your comments except this one which may need to discuss
> for an additional round.  Requeueing passes the retry to the
> kthread_worker and gives a change to the other pools which are also
> creating worker.

But why is that a good idea?  The fact that creation of a worker for a
specific pool is completely coincidental.  The failed pool itself
isn't inherently blameable.  It was just unlucky and moving onto a
different pool doesn't improve the chance of success in any way.  The
only thing requeueing achieves is punishing the unlucky one by putting
it at the back of the queue while adding complexity.

> This patch will be deferred until 3.19 due to some unbound patches
> are ready soon.

We're too late for this merge window anyway.  This is a pretty
pervasive change after all.

Thanks.

-- 
tejun
