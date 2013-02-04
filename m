Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3BDRpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:45:03 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:49816 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3BDRpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:45:01 -0500
Date: Mon, 4 Feb 2013 09:44:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: David Teigland <teigland@redhat.com>, akpm@linux-foundation.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] idr: fix a subtle bug in idr_get_next()
Message-ID: <20130204174455.GP27963@mtj.dyndns.org>
References: <1359163872-1949-11-git-send-email-tj@kernel.org>
 <20130128155723.GC16789@redhat.com>
 <20130129151317.GA11609@redhat.com>
 <20130130212417.GJ24014@redhat.com>
 <20130131235320.GN6824@mtj.dyndns.org>
 <20130201001841.GP6824@mtj.dyndns.org>
 <20130201174443.GC3812@redhat.com>
 <20130201180028.GC31863@mtj.dyndns.org>
 <20130202231048.GA3940@mtj.dyndns.org>
 <510F2D86.5050408@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510F2D86.5050408@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Li.

On Mon, Feb 04, 2013 at 11:39:50AM +0800, Li Zefan wrote:
> > Fix it by ensuring proceeding to the next slot doesn't carry over the
> > unaligned offset - ie. use round_up(id + 1, slot_distance) instead of
> > id += slot_distance.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> Don't we need to cc stable?

I thought we didn't have idr_remove() inside idr_for_each_entry() in
kernel, which isn't true.  drbd already does that, so yeah, we need to
cc stable.

Thanks.

-- 
tejun
