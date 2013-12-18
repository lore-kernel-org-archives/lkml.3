Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab3LRAKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 19:10:40 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61752 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751493Ab3LRAKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 19:10:39 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system is frozen
Date: Wed, 18 Dec 2013 01:23:57 +0100
Message-ID: <18258432.12ryrov20c@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131217123643.GE29989@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org> <2427190.pZk9AIZAjc@vostro.rjw.lan> <20131217123643.GE29989@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 17, 2013 07:36:43 AM Tejun Heo wrote:
> Hello, Rafael.
> 
> On Tue, Dec 17, 2013 at 03:38:05AM +0100, Rafael J. Wysocki wrote:
> > On Friday, December 13, 2013 03:40:34 PM Tejun Heo wrote:
> > > Hello,
> > > 
> > > So, this is the laughable workaround that I came up with.  Seriously,
> > > this is tragic.  :(
> > > 
> > > Thanks.
> > > 
> > > ------- 8< -------
> > > Freezable kthreads and workqueues are fundamentally problematic in
> > > that they effectively introduce a big kernel lock widely used in the
> > > kernel and have already been the culprit of several deadlock
> > > scenarios.  This is the latest occurrence.
> > 
> > OK, so I'm too tired now to go through all that, but I'll look at it tomorrow.
> > 
> > The rule of thumb is to get rid of freezable kernel threads in the first
> > place if possible anyway if they are causing problems to happen.
> 
> Yes, that'd be awesome.  In fact, getting rid of all kernel freezables
> in non-low-level-drivers would be a great step forward.

Agreed.

> That said, we need something easily backportable so I think we probably need
> this bandaid for immediate fix for now.

Well, we need something, but I have a couple of concerns about this particular
patch (I'll reply to it with comments shortly).

Thanks,
Rafael

