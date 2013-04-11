Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3DKUAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:00:17 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:37113 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab3DKUAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:00:11 -0400
Date: Thu, 11 Apr 2013 13:00:05 -0700
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
Message-ID: <20130411200005.GB11956@mtj.dyndns.org>
References: <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
 <20130409195259.GL6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
 <20130409210735.GR6320@redhat.com>
 <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
 <20130410192427.GA14911@redhat.com>
 <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
 <20130410235009.GI17641@mtj.dyndns.org>
 <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
 <20130411195203.GA11956@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411195203.GA11956@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 12:52:03PM -0700, Tejun Heo wrote:
> If this becomes an actual bottleneck, the right thing to do is making
> css ref per-cpu.  Please stop messing around with refcounting.

If you think this kind of hackery is acceptable, you really need to
re-evaluate your priorities in making engineering decisions.  In
tightly coupled code, maybe, but you're trying to introduce utterly
broken error-prone thing as a generic block layer API.  I mean, are
you for real?

-- 
tejun
