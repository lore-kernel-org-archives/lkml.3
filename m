Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3LRVvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:51:23 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55890 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755561Ab3LRVvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:51:21 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: Nigel Cunningham <nigel@nigelcunningham.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system is frozen
Date: Wed, 18 Dec 2013 23:04:40 +0100
Message-ID: <1735137.dNmBz0IqxU@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131218214128.GB8218@mtj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org> <20131218213936.GA8218@mtj.dyndns.org> <20131218214128.GB8218@mtj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 18, 2013 04:41:28 PM Tejun Heo wrote:
> On Wed, Dec 18, 2013 at 04:39:36PM -0500, Tejun Heo wrote:
> > Yeah, we can just rip out the whole freezer support and let the
> > caller's pm notification hooks implement it by doing
> > 
> > 	workqueue_set_max_active(wq, 0);
> > 	flush_workqueue(wq);
> 
> Oops, the above doesn't work but I can trivially add a new interface
> for this.  Something which waits for the max_active to drop below the
> newly set level before returning.
> 
> 	workqueue_set_max_active_and_wait(wq, 0);

If you add that, I can convert the PM workqueue to using it and then
we can go through all of the existing users and make similar changes - or
just make them non-freezable if there's no good reason for freezing those
particular ones.

Thanks,
Rafael

