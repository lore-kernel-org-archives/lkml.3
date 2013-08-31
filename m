Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab3HaDDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 23:03:53 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:52749 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3HaDDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 23:03:51 -0400
Message-ID: <1377918658.32763.311.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] percpu ida: Switch to cpumask_t, add some comments
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <kmo@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@gentwo.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Date: Fri, 30 Aug 2013 20:10:58 -0700
In-Reply-To: <20130828143657.9366592fe5eb6f0b09feb732@linux-foundation.org>
References: <1376694549-20609-1-git-send-email-nab@linux-iscsi.org>
	 <1376694549-20609-2-git-send-email-nab@linux-iscsi.org>
	 <20130820143157.f91bf59d16352989b54e431e@linux-foundation.org>
	 <20130828195517.GF8032@kmo-pixel>
	 <20130828132550.d0ce4d3a4d40ee07e7e8a1c1@linux-foundation.org>
	 <20130828210010.GD1357@kmo-pixel>
	 <20130828141019.25aff643c87e43ffafdbcb7e@linux-foundation.org>
	 <20130828212358.GF1357@kmo-pixel>
	 <20130828143657.9366592fe5eb6f0b09feb732@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-28 at 14:36 -0700, Andrew Morton wrote:
> On Wed, 28 Aug 2013 14:23:58 -0700 Kent Overstreet <kmo@daterainc.com> wrote:
> 
> > > I found things to be quite the opposite - it took 5 minutes of staring,
> > > head-scratching, double-checking and penny-dropping before I was
> > > confident that the newly-added code actually has nothing at all to do
> > > with the current code.  Putting it in the same file was misleading, and
> > > I got misled.
> > 
> > Ok... and I could see how the fact that it currently _doesn't_ have
> > anything to do with the existing code would be confusing...
> > 
> > Do you think that if/when it's making use of the ida rewrite it'll be
> > ok? Or would you still prefer to have it in a new file
> 
> I'm constitutionally reluctant to ever assume that any out-of-tree code
> will be merged.  Maybe you'll get hit by a bus, and maybe the code
> sucks ;)
> 
> Are you sure that the two things are so tangled together that they must
> live in the same file?  If there's some nice layering between ida and
> percpu_ida then perhaps such a physical separation would remain
> appropriate?
> 
> > (and if so, any preference on the naming?)
> 
> percpu_ida.c?

Hi Andrew,

I've folded Kent's two patches from this thread into the -v4 commit, and
moved the logic from idr.[c,h] to percpu_ida.[c,h] as per your above
recommendation.

The cpumask_t changes are working as expected thus far, and will be
going out a -v5 series for you to review -> signoff shortly.

Thank you,

--nab

