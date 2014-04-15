Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbaDOOG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:06:59 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:65099 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbaDOOGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:06:55 -0400
Date: Tue, 15 Apr 2014 10:06:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Message-ID: <20140415140650.GI1863@htj.dyndns.org>
References: <20140413013209.GC26252@mtj.dyndns.org>
 <20140414180824.GB9552@redhat.com>
 <20140414193214.GC16835@htj.dyndns.org>
 <20140415135359.GA13033@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415135359.GA13033@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 15, 2014 at 09:53:59AM -0400, Vivek Goyal wrote:
> But looks like that you are targetting that one can have multiple
> hierarchies. One of those will be unified hierarchy with new contstraints.
> Other hierarchies can be old type hierarchies. Do I understand it right?

Yeap, for backward compatibility.

> So you want all the debug knobs to be enabled by  DEBUG_BLK_CGROUP option as
> well as using a kernel command line? But I thought that in general
> people are not supposed to set CONFIG_DEBUG_BLK_CGROUP=y. It brings in
> unnecessary overhead. Those who are doing development and trying to debug
> things only those can enable above config option.
> 
> But anyway, I am fine with hiding these files behind a command line
> parameter too.

It's easy to enable the config option and there's nothing clearly
indicating those knobs expose internal details and volatile in nature.
Once userland develops dependency on them, we get locked into it
whether we intended or not.  Debug features should be very clearly
marked as such.

> > Yeah, thought about keeping them consistent but would that really
> > matter?  Having internal consistency in cfq seems more important to
> > me.
> 
> I think from a user's perspective it really matters. If I see two knobs
> in a cgroup, say throttle.io_service_bytes and cfq.io_service_bytes, it
> is much more intuitive.
>
> So I feel that we should aim for having consistent names in CFQ and
> throttling. If one understands one knob at one layer, it is intuitive
> to figure out what same knob means at other layer.
> 
> And, thankfully, we have only two stats at throttling layer.
> 
> blkio.throttle.io_serviced
> blkio.throttle.io_service_bytes
> 
> Though names are little longer, but they look fine to me. They are
> intuitive. So I can't see a strong reason to change those names
> at CFQ layer.
> 
> blkio.cfq.io_serviced
> blkio.cfq.io_service_bytes

But then do we name other stat knobs similarly too?

 blkio.cfq.io_service_sectors
 blkio.cfq.io_service_bytes
 blkio.cfq.io_serviced
 blkio.cfq.io_merged

I don't know.  The names look outright stupid to me.  If we don't do
the above, then we have internal inconsistencies among cfq knob names
which gotta be worse then cfq / throttl inconsistency.  It's not a
perfect situation no matter what we do.  As long as each knob is
clearly documented, I don't think these inconsistencies are big deal,
so let's just clean up cfq names as we need to add prefix anyway.

Thanks.

-- 
tejun
