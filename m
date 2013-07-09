Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3GIRvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 13:51:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3GIRvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 13:51:13 -0400
Date: Tue, 9 Jul 2013 10:51:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, Dave Chinner <david@fromorbit.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: slab shrinkers: BUG at mm/list_lru.c:92
Message-Id: <20130709105141.54ee6e86.akpm@linux-foundation.org>
In-Reply-To: <20130709173407.GA9188@localhost.localdomain>
References: <20130701012558.GB27780@dastard>
	<20130701075005.GA28765@dhcp22.suse.cz>
	<20130701081056.GA4072@dastard>
	<20130702092200.GB16815@dhcp22.suse.cz>
	<20130702121947.GE14996@dastard>
	<20130702124427.GG16815@dhcp22.suse.cz>
	<20130703112403.GP14996@dastard>
	<20130704163643.GF7833@dhcp22.suse.cz>
	<20130708125352.GC20149@dhcp22.suse.cz>
	<20130708140419.d9079dd67111090beb6cef3d@linux-foundation.org>
	<20130709173407.GA9188@localhost.localdomain>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jul 2013 21:34:08 +0400 Glauber Costa <glommer@gmail.com> wrote:

> On Mon, Jul 08, 2013 at 02:04:19PM -0700, Andrew Morton wrote:
> > On Mon, 8 Jul 2013 14:53:52 +0200 Michal Hocko <mhocko@suse.cz> wrote:
> > 
> > > > Good news! The test was running since morning and it didn't hang nor
> > > > crashed. So this really looks like the right fix. It will run also
> > > > during weekend to be 100% sure. But I guess it is safe to say
> > > 
> > > Hmm, it seems I was too optimistic or we have yet another issue here (I
> > > guess the later is more probable).
> > > 
> > > The weekend testing got stuck as well. 
> > > 
> > > The dmesg shows there were some hung tasks:
> > 
> > That looks like the classic "we lost an IO completion" trace.
> > 
> > I think it would be prudent to defer these patches into 3.12.
> Agree.
> 
> Will they still in -mm, or do I have to resend ?

No, I don't intend to drop them from -mm.
