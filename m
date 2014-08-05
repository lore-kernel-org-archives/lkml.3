Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaHECAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 22:00:00 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48672 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaHEB76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:59:58 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 5 Aug 2014 11:00:24 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sami Kerola <kerolasa@iki.fi>
Cc: util-linux@vger.kernel.org, Timofey Titovets <nefelim4ag@gmail.com>,
        Karel Zak <kzak@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: zram: device management utility needed
Message-ID: <20140805020024.GB27993@bbox>
References: <1406675682-8402-1-git-send-email-kerolasa@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406675682-8402-1-git-send-email-kerolasa@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 12:14:42AM +0100, Sami Kerola wrote:
> Hello,
> 
> Not so long ago Timofey has reached both util-linux[1] and kernel[2]
> contributors with intention to make zram device management too.  I think
> the proposal is good, and there should be distribution independent tool
> like that.  Also such command fits fairly well to a scope of util-linux
> package.  But a tool is only as good as kernel support of it is.  This
> mail is a bit about both.
> 
> Existing proposal for zramctl[3], wrote by Timofey, does what I would
> call great starting point.  It can resize zram device, select algorithm,
> and set number of threads.  Unfortunately it cannot create or remove zram
> devices.
> 
> The zram devices are not created by any sort of equipment appearing in a
> bus so an method of creating new or removing existing devices will be
> needed.  When the zram module is loaded it should create
> /dev/zram-control device, that responds to ioctl() calls[4].  The calls
> could be similar with /dev/loop-control[5], that allow adding or removing
> specified device, and discover adding a free device.

Normally, dynamic management is good to have, I think but I didn't hear
strong requirement for that until now.
Why don't you change num_device param at module loading time?
I'd like to hear real scenario from whom are about to using that faeture
right now and what's the problem with num_device param.


> 
> This proposal would not affect the current initialization of the zram
> devices[6].  It would be an addition to manage zram devices after kernel
> module is loaded, of course each device separately and individually.  At
> the moment adding a device requires removing the existing devices[7],
> which can mean data loss, and at least unnecessary hassle when performing
> a device addition task.

If there is any holder of device, we shouldn't destroy the device.
It's doable.

> 
> But before getting too exited and asking for ioctl() allocation, or
> thinking too much about code, does an overall plan like this make sense? 
> Is there an alternative that would be better than /dev/zram-control +
> ioctl()'s?  Any other comments, better proposal, and so on?
> 
> Finally, Hats off to Timofey, you got the ball rolling getting the zram
> devices being dynamic someday in future.

I vote such standard tool to control each zram device's property but need
more thinking about dynamic device adding/removal.

> 
> [1] http://www.spinics.net/lists/util-linux-ng/index.html#09781
> [2] https://lkml.org/lkml/2014/7/17/272
> [3] http://www.spinics.net/lists/util-linux-ng/msg09900.html
> [4] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/ioctl/ioctl-number.txt?id=31dab719fa50cf56d56d3dc25980fecd336f6ca8
> [5] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/block/loop.c?id=31dab719fa50cf56d56d3dc25980fecd336f6ca8#n1757
> [6] such as: modprobe zram num_devices=4
> [7] requires 'rmmod zram' which is not possible if any zram device is busy
> 
> -- 
> Sami Kerola
> http://www.iki.fi/kerolasa/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
