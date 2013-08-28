Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3H1TRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:17:30 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:61902 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab3H1TR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:17:28 -0400
Date: Wed, 28 Aug 2013 12:17:39 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@gentwo.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH-v4 1/6] idr: Percpu ida
Message-ID: <20130828191739.GD8032@kmo-pixel>
References: <1377634306-13981-1-git-send-email-nab@linux-iscsi.org>
 <1377634306-13981-2-git-send-email-nab@linux-iscsi.org>
 <20130827134314.7e9f8b792023eba41b4ea93d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827134314.7e9f8b792023eba41b4ea93d@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 01:43:14PM -0700, Andrew Morton wrote:
> On Tue, 27 Aug 2013 20:11:41 +0000 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > Percpu frontend for allocating ids. With percpu allocation (that works),
> > it's impossible to guarantee it will always be possible to allocate all
> > nr_tags - typically, some will be stuck on a remote percpu freelist
> > where the current job can't get to them.
> > 
> > We do guarantee that it will always be possible to allocate at least
> > (nr_tags / 2) tags - this is done by keeping track of which and how many
> > cpus have tags on their percpu freelists. On allocation failure if
> > enough cpus have tags that there could potentially be (nr_tags / 2) tags
> > stuck on remote percpu freelists, we then pick a remote cpu at random to
> > steal from.
> > 
> > Note that there's no cpu hotplug notifier - we don't care, because
> > steal_tags() will eventually get the down cpu's tags. We _could_ satisfy
> > more allocations if we had a notifier - but we'll still meet our
> > guarantees and it's absolutely not a correctness issue, so I don't think
> > it's worth the extra code.
> 
> Except for one silly trivial thing, all of my August 20 review comments
> were ignored.  You didn't even bother replying to the email.

Sorry! I remember seeing that email now, but somehow I completely missed
all the review comments after the first one. Mea culpa!
