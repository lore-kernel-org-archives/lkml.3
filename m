Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab3LRWBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:01:07 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62629 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750961Ab3LRWBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 17:01:05 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        tomaz.solc@tablix.org, aaron.lu@intel.com,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Writeback threads and freezable
Date: Wed, 18 Dec 2013 23:14:24 +0100
Message-ID: <1639602.dY4DbMiF4F@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131218114343.GA4324@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org> <20131218003510.GD20579@dastard> <20131218114343.GA4324@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 18, 2013 06:43:43 AM Tejun Heo wrote:

[...]

> If filesystems need an indication that the underlying device is no
> longer functional, please go ahead and add it, but please keep in mind
> all these are completely asynchronous.  Nothing guarantees you that
> such events would happen in any specific order.  IOW, you can be at
> *ANY* point in your warm unplug path and the device is hot unplugged,
> which essentially forces all the code paths to be ready for the worst,
> and that's exactly why there isn't much effort in trying to separate
> out warm and hot unplug paths.

Yes.  Devices can go away at any point without notice.  Even PCI devices
that have never been assumed to be hot-removable.  Any piece of code in the
kernel needs to be prepared to deal with such situations.

Thanks,
Rafael
