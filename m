Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaG2XO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:14:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56272 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaG2XOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:14:55 -0400
From: Sami Kerola <kerolasa@iki.fi>
To: util-linux@vger.kernel.org, Timofey Titovets <nefelim4ag@gmail.com>,
        Karel Zak <kzak@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: kerolasa@iki.fi, linux-kernel@vger.kernel.org
Subject: zram: device management utility needed
Date: Wed, 30 Jul 2014 00:14:42 +0100
Message-Id: <1406675682-8402-1-git-send-email-kerolasa@iki.fi>
X-Mailer: git-send-email 2.0.3
Organization: lastminute.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Not so long ago Timofey has reached both util-linux[1] and kernel[2]
contributors with intention to make zram device management too.  I think
the proposal is good, and there should be distribution independent tool
like that.  Also such command fits fairly well to a scope of util-linux
package.  But a tool is only as good as kernel support of it is.  This
mail is a bit about both.

Existing proposal for zramctl[3], wrote by Timofey, does what I would
call great starting point.  It can resize zram device, select algorithm,
and set number of threads.  Unfortunately it cannot create or remove zram
devices.

The zram devices are not created by any sort of equipment appearing in a
bus so an method of creating new or removing existing devices will be
needed.  When the zram module is loaded it should create
/dev/zram-control device, that responds to ioctl() calls[4].  The calls
could be similar with /dev/loop-control[5], that allow adding or removing
specified device, and discover adding a free device.

This proposal would not affect the current initialization of the zram
devices[6].  It would be an addition to manage zram devices after kernel
module is loaded, of course each device separately and individually.  At
the moment adding a device requires removing the existing devices[7],
which can mean data loss, and at least unnecessary hassle when performing
a device addition task.

But before getting too exited and asking for ioctl() allocation, or
thinking too much about code, does an overall plan like this make sense? 
Is there an alternative that would be better than /dev/zram-control +
ioctl()'s?  Any other comments, better proposal, and so on?

Finally, Hats off to Timofey, you got the ball rolling getting the zram
devices being dynamic someday in future.

[1] http://www.spinics.net/lists/util-linux-ng/index.html#09781
[2] https://lkml.org/lkml/2014/7/17/272
[3] http://www.spinics.net/lists/util-linux-ng/msg09900.html
[4] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/ioctl/ioctl-number.txt?id=31dab719fa50cf56d56d3dc25980fecd336f6ca8
[5] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/block/loop.c?id=31dab719fa50cf56d56d3dc25980fecd336f6ca8#n1757
[6] such as: modprobe zram num_devices=4
[7] requires 'rmmod zram' which is not possible if any zram device is busy

-- 
Sami Kerola
http://www.iki.fi/kerolasa/
