Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab3BBXLn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 18:11:43 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:60758 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3BBXLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 18:11:40 -0500
Date: Sat, 2 Feb 2013 15:11:35 -0800
From: Tejun Heo <tj@kernel.org>
To: David Teigland <teigland@redhat.com>
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] idr: fix a subtle bug in idr_get_next()
Message-ID: <20130202231135.GB3940@mtj.dyndns.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
 <1359163872-1949-11-git-send-email-tj@kernel.org>
 <20130128155723.GC16789@redhat.com>
 <20130129151317.GA11609@redhat.com>
 <20130130212417.GJ24014@redhat.com>
 <20130131235320.GN6824@mtj.dyndns.org>
 <20130201001841.GP6824@mtj.dyndns.org>
 <20130201174443.GC3812@redhat.com>
 <20130201180028.GC31863@mtj.dyndns.org>
 <20130202231048.GA3940@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130202231048.GA3940@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 03:10:48PM -0800, Tejun Heo wrote:
> Fix it by ensuring proceeding to the next slot doesn't carry over the
> unaligned offset - ie. use round_up(id + 1, slot_distance) instead of
> id += slot_distance.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: David Teigland <teigland@redhat.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

David, can you please test whether the patch makes the skipped
deletion bug go away?

Thanks!

-- 
tejun
