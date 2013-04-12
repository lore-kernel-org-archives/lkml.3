Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3DLAXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 20:23:03 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:60807 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3DLAW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 20:22:58 -0400
Date: Thu, 11 Apr 2013 17:22:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH v2] make dm and dm-crypt forward cgroup context (was:
 dm-crypt parallelization patches)
Message-ID: <20130412002252.GD11956@mtj.dyndns.org>
References: <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
 <20130409210735.GR6320@redhat.com>
 <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
 <20130410192427.GA14911@redhat.com>
 <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
 <20130410235009.GI17641@mtj.dyndns.org>
 <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
 <20130411195203.GA11956@mtj.dyndns.org>
 <20130411200005.GB11956@mtj.dyndns.org>
 <Pine.LNX.4.64.1304111943450.29691@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304111943450.29691@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 08:06:10PM -0400, Mikulas Patocka wrote:
> All that I can tell you is that adding an empty atomic operation 
> "cmpxchg(&bio->bi_css->refcnt, bio->bi_css->refcnt, bio->bi_css->refcnt);" 
> to bio_clone_context and bio_disassociate_task increases the time to run a 
> benchmark from 23 to 40 seconds.

Right, linear target on ramdisk, very realistic, and you know what,
hell with dm, let's just hand code everything into submit_bio().  I'm
sure it will speed up your test case significantly.

If this actually matters, improve it in *sane* way.  Make the refcnts
per-cpu and not use atomic ops.  In fact, we already have proposed
implementation of percpu refcnt which is being used by aio restructure
patches and likely to be included in some form.  It's not quite ready
yet, so please work on something useful like that instead of
continuing this non-sense.

-- 
tejun
