Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3H1VhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:37:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab3H1Vg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:36:59 -0400
Date: Wed, 28 Aug 2013 14:36:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <kmo@daterainc.com>
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
Message-Id: <20130828143657.9366592fe5eb6f0b09feb732@linux-foundation.org>
In-Reply-To: <20130828212358.GF1357@kmo-pixel>
References: <1376694549-20609-1-git-send-email-nab@linux-iscsi.org>
	<1376694549-20609-2-git-send-email-nab@linux-iscsi.org>
	<20130820143157.f91bf59d16352989b54e431e@linux-foundation.org>
	<20130828195517.GF8032@kmo-pixel>
	<20130828132550.d0ce4d3a4d40ee07e7e8a1c1@linux-foundation.org>
	<20130828210010.GD1357@kmo-pixel>
	<20130828141019.25aff643c87e43ffafdbcb7e@linux-foundation.org>
	<20130828212358.GF1357@kmo-pixel>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 14:23:58 -0700 Kent Overstreet <kmo@daterainc.com> wrote:

> > I found things to be quite the opposite - it took 5 minutes of staring,
> > head-scratching, double-checking and penny-dropping before I was
> > confident that the newly-added code actually has nothing at all to do
> > with the current code.  Putting it in the same file was misleading, and
> > I got misled.
> 
> Ok... and I could see how the fact that it currently _doesn't_ have
> anything to do with the existing code would be confusing...
> 
> Do you think that if/when it's making use of the ida rewrite it'll be
> ok? Or would you still prefer to have it in a new file

I'm constitutionally reluctant to ever assume that any out-of-tree code
will be merged.  Maybe you'll get hit by a bus, and maybe the code
sucks ;)

Are you sure that the two things are so tangled together that they must
live in the same file?  If there's some nice layering between ida and
percpu_ida then perhaps such a physical separation would remain
appropriate?

> (and if so, any preference on the naming?)

percpu_ida.c?
