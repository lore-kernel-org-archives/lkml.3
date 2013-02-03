Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3BCRxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 12:53:49 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:44041 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab3BCRxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 12:53:46 -0500
Date: Sun, 3 Feb 2013 09:53:47 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Randy Dunlap <rdunlap@infradead.org>
cc: Tejun Heo <tj@kernel.org>, David Teigland <teigland@redhat.com>,
        akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        eric paris <eparis@redhat.com>
Subject: Re: [PATCH] idr: fix a subtle bug in idr_get_next()
In-Reply-To: <510DC830.70707@infradead.org>
Message-ID: <alpine.LNX.2.00.1302030949280.1437@eggly.anvils>
References: <1359163872-1949-1-git-send-email-tj@kernel.org> <1359163872-1949-11-git-send-email-tj@kernel.org> <20130128155723.GC16789@redhat.com> <20130129151317.GA11609@redhat.com> <20130130212417.GJ24014@redhat.com> <20130131235320.GN6824@mtj.dyndns.org>
 <20130201001841.GP6824@mtj.dyndns.org> <20130201174443.GC3812@redhat.com> <20130201180028.GC31863@mtj.dyndns.org> <20130202231048.GA3940@mtj.dyndns.org> <20130202231135.GB3940@mtj.dyndns.org> <510DC830.70707@infradead.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Feb 2013, Randy Dunlap wrote:
> On 02/02/13 15:11, Tejun Heo wrote:
> > On Sat, Feb 02, 2013 at 03:10:48PM -0800, Tejun Heo wrote:
> >> Fix it by ensuring proceeding to the next slot doesn't carry over the
> >> unaligned offset - ie. use round_up(id + 1, slot_distance) instead of
> >> id += slot_distance.
> >>
> >> Signed-off-by: Tejun Heo <tj@kernel.org>
> >> Reported-by: David Teigland <teigland@redhat.com>
> >> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > David, can you please test whether the patch makes the skipped
> > deletion bug go away?
> > 
> > Thanks!
> 
> Hugh, did you update the idr test suite or the radix-tree test suite?

Sorry, not the answer you want: it was the radix-tree test harness, rtth,
that I updated a year ago (but then lib/radix-tree.c changed again).

Hugh

> 
> Is there an idr test suite or module?  I have a kernel module source file
> named idr_test.c by Eric Paris.
> 
> thanks,
> 
> -- 
> ~Randy
