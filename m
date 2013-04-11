Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3DKTwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:52:11 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:34037 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3DKTwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:52:10 -0400
Date: Thu, 11 Apr 2013 12:52:03 -0700
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
Message-ID: <20130411195203.GA11956@mtj.dyndns.org>
References: <20130409181031.GC6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
 <20130409195259.GL6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
 <20130409210735.GR6320@redhat.com>
 <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
 <20130410192427.GA14911@redhat.com>
 <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
 <20130410235009.GI17641@mtj.dyndns.org>
 <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 03:49:20PM -0400, Mikulas Patocka wrote:
> If the bi_css pointer points to a structure that is shared between 
> processes, using atomic instruction causes cache line boucing - it doesn't 
> cost a few instructions, it costs 2-3 hundreds cycles.
> 
> I modified the patch to use new flag BIO_DROP_CGROUP_REFCOUNT to note that 
> the refcount must be decremented - if the flag is set, refcounts must be 
> decremented when bio is destroyed, if it is not set, references are 
> borrowed from upper layer bio.
> 
> It is less bug-prone than the previous patch.

If this becomes an actual bottleneck, the right thing to do is making
css ref per-cpu.  Please stop messing around with refcounting.

NACK.

-- 
tejun
