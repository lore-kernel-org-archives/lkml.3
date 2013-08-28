Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab3H1VAC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:00:02 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39493 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab3H1U77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 16:59:59 -0400
Date: Wed, 28 Aug 2013 14:00:10 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@gentwo.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] percpu ida: Switch to cpumask_t, add some comments
Message-ID: <20130828210010.GD1357@kmo-pixel>
References: <1376694549-20609-1-git-send-email-nab@linux-iscsi.org>
 <1376694549-20609-2-git-send-email-nab@linux-iscsi.org>
 <20130820143157.f91bf59d16352989b54e431e@linux-foundation.org>
 <20130828195517.GF8032@kmo-pixel>
 <20130828132550.d0ce4d3a4d40ee07e7e8a1c1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828132550.d0ce4d3a4d40ee07e7e8a1c1@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 01:25:50PM -0700, Andrew Morton wrote:
> On Wed, 28 Aug 2013 12:55:17 -0700 Kent Overstreet <kmo@daterainc.com> wrote:
> 
> > Fixup patch, addressing Andrew's review feedback:
> 
> Looks reasonable.
> 
> >  lib/idr.c           | 38 +++++++++++++++++++++-----------------
> 
> I still don't think it should be in this file.
> 
> You say that some as-yet-unmerged patches will tie the new code into
> the old ida code.  But will it do it in a manner which requires that
> the two reside in the same file?

Not require, no - but it's just intimate enough with my ida rewrite that
I think it makes sense; it makes some use of stuff that should be
internal to the ida code.

Mostly just sharing the lock though, since I got rid of the ida
interfaces that don't do locking, but percpu ida needs a lock that also
covers what ida needs.

It also makes use of a ganged allocation interface, but there's no real
reason ida can't expose that, it's just unlikely to be useful to
anything but percpu ida.

The other reason I think it makes sense to live in idr.c is more for
users of the code; as you pointed out as far as the user's perspective
percpu ida isn't doing anything fundamentally different from ida, so I
think it makes sense for the code to live in the same place as a
kindness to future kernel developers who are trying to find their way
around the various library code.
