Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab3LQCUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 21:20:45 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61061 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751112Ab3LQCUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 21:20:44 -0500
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
Date: Tue, 17 Dec 2013 03:34 +0100
Message-ID: <8951916.gd5Uu6GpK1@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131214203121.GB4020@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org> <52AB9509.1080004@nigelcunningham.com.au> <20131214203121.GB4020@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 14, 2013 03:31:21 PM Tejun Heo wrote:
> Hello, Nigel.
> 
> On Sat, Dec 14, 2013 at 10:15:21AM +1100, Nigel Cunningham wrote:
> > My understanding is that the point is ensuring that - particularly
> > in the case of hibernation - we don't cause filesystem corruption by
> > writing one thing while writing the image and then doing something
> > else (without knowledge of what happened while the image was being
> > written) while reading the image or after restoring it.
> 
> So, all this is about hibernation?

No, it isn't.  [I guess it was originally, but it has not been the case
for a very long time.]  It is about getting user space interactions (all of
the sysfs/ioctl/mmap/read/write/you-name-it thingies user space can do to
devices) when we're calling device suspend/resume routines.  The reason is
that otherwise all of them would have had to do a "oh, are we suspending by
the way?" check pretty much on every code path that can be triggered by
user space.

And I'd appreciate it if people didn't repeat the nonsense about possible
filesystem corruption.  The freezing of tasks doesn't prevent that from
happening (which is easy to demonstrate by artificially fail restore from
hibernation multiple times in a row).

> Does that mean that it's safe to
> unfreeze before invoking resume?

No, it isn't.

Thanks,
Rafael

