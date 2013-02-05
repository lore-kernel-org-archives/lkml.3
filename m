Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab3BEPga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:36:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045Ab3BEPg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:36:27 -0500
Date: Tue, 5 Feb 2013 10:36:14 -0500
From: David Teigland <teigland@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] idr: fix a subtle bug in idr_get_next()
Message-ID: <20130205153614.GA1508@redhat.com>
References: <1359163872-1949-11-git-send-email-tj@kernel.org>
 <20130128155723.GC16789@redhat.com>
 <20130129151317.GA11609@redhat.com>
 <20130130212417.GJ24014@redhat.com>
 <20130131235320.GN6824@mtj.dyndns.org>
 <20130201001841.GP6824@mtj.dyndns.org>
 <20130201174443.GC3812@redhat.com>
 <20130201180028.GC31863@mtj.dyndns.org>
 <20130202231048.GA3940@mtj.dyndns.org>
 <20130202231135.GB3940@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130202231135.GB3940@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 03:11:35PM -0800, Tejun Heo wrote:
> On Sat, Feb 02, 2013 at 03:10:48PM -0800, Tejun Heo wrote:
> > Fix it by ensuring proceeding to the next slot doesn't carry over the
> > unaligned offset - ie. use round_up(id + 1, slot_distance) instead of
> > id += slot_distance.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: David Teigland <teigland@redhat.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> David, can you please test whether the patch makes the skipped
> deletion bug go away?

Yes, I've tested, and it works fine now.
Thanks,
Dave

