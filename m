Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab3FERgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:36:22 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:56118 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019Ab3FERgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:36:19 -0400
Date: Wed, 5 Jun 2013 10:36:14 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Robin Dong <sanbai@taobao.com>, linux-kernel@vger.kernel.org,
        Zhu Yanhai <gaoyang.zyh@taobao.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <taoma.tm@gmail.com>, kent.overstreet@gmail.com
Subject: Re: [RFC v1] add new io-scheduler to use cgroup on high-speed device
Message-ID: <20130605173614.GB10693@mtj.dyndns.org>
References: <1370398171-25173-1-git-send-email-sanbai@taobao.com>
 <20130605030337.GO14916@htj.dyndns.org>
 <20130605135512.GB16339@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605135512.GB16339@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Wed, Jun 05, 2013 at 09:55:12AM -0400, Vivek Goyal wrote:
> I think it will be hard to cover all the use cases. There is a reason
> why CFQ got so complicated and bulky because it tried to cover all the
> use cases and provide service differentiation among workloads. blk-cgroup
> will try to do the same thing at group level. All these question will
> arise when to idle, how much to idle, how much device queue depth we
> should drive to keep service differention better, how much outstanding
> IO from each group we should allow in the queue.

Yes but that's because we were trying to serve disks with rotating
platters.  I don't think we can use the same thing for disks and
non-rotational devices.  For the latter, things get a lot simpler.
Note that even the current blk-throttle doesn't care about the
underlying device at all.  We can do the same thing for proportional
control in a hopefully better and scalable way of course.

> And all of this affects what kind of service differentation you see
> on different devices for different workloads.
> 
> I think generic implementation can be written with the goal of trying to
> make it work with faster flash devices (which will typically use blk-mq).
> And for slower disks, one can continue to use CFQ's cgroup implementation.

Yeap.  Pretty much the same feeling here.

> On a side note, it would be nice if we handle problem of managing buffered
> writes using cgroup first. Otherwise there are very few practical
> scenarios where proportional IO thing can be used.

Indeed.  It's currently below unified hierarchy in my todo list but if
you wanna tackle it, I'll be happy to help.

Thanks.

-- 
tejun
