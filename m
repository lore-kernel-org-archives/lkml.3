Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab3H0UnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:43:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab3H0UnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:43:17 -0400
Date: Tue, 27 Aug 2013 13:43:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@gentwo.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH-v4 1/6] idr: Percpu ida
Message-Id: <20130827134314.7e9f8b792023eba41b4ea93d@linux-foundation.org>
In-Reply-To: <1377634306-13981-2-git-send-email-nab@linux-iscsi.org>
References: <1377634306-13981-1-git-send-email-nab@linux-iscsi.org>
	<1377634306-13981-2-git-send-email-nab@linux-iscsi.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013 20:11:41 +0000 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> Percpu frontend for allocating ids. With percpu allocation (that works),
> it's impossible to guarantee it will always be possible to allocate all
> nr_tags - typically, some will be stuck on a remote percpu freelist
> where the current job can't get to them.
> 
> We do guarantee that it will always be possible to allocate at least
> (nr_tags / 2) tags - this is done by keeping track of which and how many
> cpus have tags on their percpu freelists. On allocation failure if
> enough cpus have tags that there could potentially be (nr_tags / 2) tags
> stuck on remote percpu freelists, we then pick a remote cpu at random to
> steal from.
> 
> Note that there's no cpu hotplug notifier - we don't care, because
> steal_tags() will eventually get the down cpu's tags. We _could_ satisfy
> more allocations if we had a notifier - but we'll still meet our
> guarantees and it's absolutely not a correctness issue, so I don't think
> it's worth the extra code.

Except for one silly trivial thing, all of my August 20 review comments
were ignored.  You didn't even bother replying to the email.

