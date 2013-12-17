Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab3LQMgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:36:49 -0500
Received: from mail-gg0-f181.google.com ([209.85.161.181]:44045 "EHLO
	mail-gg0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab3LQMgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:36:47 -0500
Date: Tue, 17 Dec 2013 07:36:43 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system
 is frozen
Message-ID: <20131217123643.GE29989@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131213185237.GD27070@htj.dyndns.org>
 <20131213204034.GE27070@htj.dyndns.org>
 <2427190.pZk9AIZAjc@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2427190.pZk9AIZAjc@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Tue, Dec 17, 2013 at 03:38:05AM +0100, Rafael J. Wysocki wrote:
> On Friday, December 13, 2013 03:40:34 PM Tejun Heo wrote:
> > Hello,
> > 
> > So, this is the laughable workaround that I came up with.  Seriously,
> > this is tragic.  :(
> > 
> > Thanks.
> > 
> > ------- 8< -------
> > Freezable kthreads and workqueues are fundamentally problematic in
> > that they effectively introduce a big kernel lock widely used in the
> > kernel and have already been the culprit of several deadlock
> > scenarios.  This is the latest occurrence.
> 
> OK, so I'm too tired now to go through all that, but I'll look at it tomorrow.
> 
> The rule of thumb is to get rid of freezable kernel threads in the first
> place if possible anyway if they are causing problems to happen.

Yes, that'd be awesome.  In fact, getting rid of all kernel freezables
in non-low-level-drivers would be a great step forward.  That said, we
need something easily backportable so I think we probably need this
bandaid for immediate fix for now.

Thanks.

-- 
tejun
