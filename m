Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763314Ab3ECS56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 14:57:58 -0400
Received: from mail-ye0-f170.google.com ([209.85.213.170]:48064 "EHLO
	mail-ye0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763256Ab3ECS54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 14:57:56 -0400
Date: Fri, 3 May 2013 11:57:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Message-ID: <20130503185751.GA22860@mtj.dyndns.org>
References: <20130502175701.GL19814@mtj.dyndns.org>
 <20130502181747.GH30020@redhat.com>
 <20130502182933.GN19814@mtj.dyndns.org>
 <20130502184514.GI30020@redhat.com>
 <20130502184953.GP19814@mtj.dyndns.org>
 <20130502190732.GK30020@redhat.com>
 <CAOS58YOk7G=dBG1v5Ed2z3biMMyKkkutp30vH5XC72z0_Z85cw@mail.gmail.com>
 <20130502193139.GL30020@redhat.com>
 <20130502231307.GT19814@mtj.dyndns.org>
 <20130503175652.GB6062@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130503175652.GB6062@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 01:56:52PM -0400, Vivek Goyal wrote:
> > Yeah, I think that's what *should* be happening but not what I'm
> > seeing.  I'm seeing ~15% penalty.
> 
> What test are you running. I am running a simple dd with directIO and
> I am not seeing any penalty.

Combination of dd and a test program that I've been using for some
while which can generate concurrent direct random IOs.  Attaching the
source code for the latter.

> # set limit to 1000000 bytes/second both in parent and child cgroup
> # dd if=/dev/vdb of=/dev/null iflag=direct
> 
> I will capture blktrace and analyze it though to understand better
> what's happening.

Try using larger block size.  It looks like dispatch windows being
reset depending on timing is hurting the overall bandwidth.  It
becomes pronounced with larger IOs.

Thanks.

-- 
tejun
