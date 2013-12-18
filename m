Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab3LRLIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:08:13 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:34096 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3LRLIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:08:12 -0500
Date: Wed, 18 Dec 2013 06:08:07 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH v2] libata, freezer: avoid block device removal while
 system is frozen
Message-ID: <20131218110807.GA3808@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131213204034.GE27070@htj.dyndns.org>
 <20131217125042.GF29989@htj.dyndns.org>
 <3253153.CIRSLE6KOu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3253153.CIRSLE6KOu@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Rafael.

On Wed, Dec 18, 2013 at 02:04:35AM +0100, Rafael J. Wysocki wrote:
> > +	 * The core suspend/resume path is fundamentally broken due to
> > +	 * freezable kthreads and workqueue and may deadlock if a block
> > +	 * device gets removed while resume is in progress.  I don't know
> > +	 * what the solution is short of removing freezable kthreads and
> > +	 * workqueues altogether.
> 
> Do you mean the block device core or the SCSI core or something else?  It would
> be good to clarify that here to avoid confusion.

Will clarify.

> > +	 * The following is an ugly hack to avoid kicking off device
> > +	 * removal while freezer is active.  This is a joke but does avoid
> > +	 * this particular deadlock scenario.
> > +	 *
> > +	 * https://bugzilla.kernel.org/show_bug.cgi?id=62801
> > +	 * http://marc.info/?l=linux-kernel&m=138695698516487
> > +	 */
> > +	while (pm_freezing)
> > +		msleep(100);
> 
> Why is the sleep time 100 ms exactly?  And why does it matter?

Just a number I pulled out of my ass.

> For example, what would change if it were 10 ms?

Yeah, 10ms is my favorite human-visible polling duration too (because
it's slow enough not to cause overhead issues while fast enough to be
mostly unnoticeable to humans).  This one doesn't really matter
because the operation's latency isn't something which the user would
wait for actively.  That said, yeah, why not, I'll change it to 10ms.

Thanks.

-- 
tejun
