Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533AbaHEIIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:08:35 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:41513 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516AbaHEIIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:08:32 -0400
Date: Tue, 5 Aug 2014 08:12:47 +0000
From: Minchan Kim <minchan@kernel.org>
To: Karel Zak <kzak@redhat.com>
Cc: Sami Kerola <kerolasa@iki.fi>, util-linux@vger.kernel.org,
        Timofey Titovets <nefelim4ag@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: zram: device management utility needed
Message-ID: <20140805081238.GA3700@gmail.com>
References: <1406675682-8402-1-git-send-email-kerolasa@iki.fi>
 <20140805020024.GB27993@bbox>
 <20140805070716.GB12104@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805070716.GB12104@x2.net.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 09:07:16AM +0200, Karel Zak wrote:
> On Tue, Aug 05, 2014 at 11:00:24AM +0900, Minchan Kim wrote:
> > On Wed, Jul 30, 2014 at 12:14:42AM +0100, Sami Kerola wrote:
> > > The zram devices are not created by any sort of equipment appearing in a
> > > bus so an method of creating new or removing existing devices will be
> > > needed.  When the zram module is loaded it should create
> > > /dev/zram-control device, that responds to ioctl() calls[4].  The calls
> > > could be similar with /dev/loop-control[5], that allow adding or removing
> > > specified device, and discover adding a free device.
> > 
> > Normally, dynamic management is good to have, I think but I didn't hear
> > strong requirement for that until now.
> 
> I guess that number of zram devices will be always relatively small
> compare to /dev/loopN devices. It is not unusual that people use
> systems with more than 256 loop devs, so /dev/loop-control makes a lot
> of sense to keep the device management effective and simple.
> 
> > Why don't you change num_device param at module loading time?
> 
> If you have really many loopN devices than create all the nodes at
> boot time means extra overhead (allocate nodes in kernel, events to
> udev, create /dev files etc.).  The ioctl LOOP_CTL_* API also provides
> LOOP_CTL_GET_FREE that returns unused device, so you don't have to
> scan all the /dev/loopN devices to detect a free device.

Thanks for the info!

> 
> > I'd like to hear real scenario from whom are about to using that faeture
> > right now and what's the problem with num_device param.
> 
> Again, I don't think it's so important for zram as for loop devices.
> All depends how people will use zram devices. We will see...

Yeb and we can do it when we see.

> 
>     Karel
> 
> -- 
>  Karel Zak  <kzak@redhat.com>
>  http://karelzak.blogspot.com
