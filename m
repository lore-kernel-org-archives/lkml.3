Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaHYKsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:48:12 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:61190 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaHYKsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:48:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140820034116.GA3407@sucs.org>
References: <20140819123655.GC12160@sucs.org>
	<8dcf334714c44eeda54ecb129479719b@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	<20140820034116.GA3407@sucs.org>
Date: Mon, 25 Aug 2014 12:48:08 +0200
Message-ID: <CAFLxGvx5_JSb7sRPXY01d+eNJ4p4fk=MySGyui91KNbdyLyQ_g@mail.gmail.com>
Subject: Re: [hyperv] BUG at drivers/hv/channel.c:462 while changing MTU
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 via


On Wed, Aug 20, 2014 at 5:41 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Aug 20 04:04:41 ubuntuhv kernel: [    9.230399] random: nonblocking pool is initialized
> Aug 20 04:04:41 ubuntuhv kernel: [   10.338487] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
> Aug 20 04:04:41 ubuntuhv kernel: [   11.099094] hv_storvsc vmbus_0_1: cmd 0x85 scsi status 0x2 srb status 0x6
> Aug 20 04:04:41 ubuntuhv kernel: [   11.099901] hv_storvsc vmbus_0_1: cmd 0x85 scsi status 0x2 srb status 0x6
> Aug 20 04:04:43 ubuntuhv kernel: [   12.999830] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x01, buttons: 0/0
> Aug 20 03:55:47 ubuntuhv kernel: [   13.003659] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
> Aug 20 03:57:28 ubuntuhv kernel: [  113.711832] hv_netvsc vmbus_0_14: net device safe to remove
> Aug 20 03:57:28 ubuntuhv kernel: [  113.713882] hv_netvsc: hv_netvsc channel opened successfully
> Aug 20 03:57:29 ubuntuhv kernel: [  114.961312] hv_netvsc vmbus_0_14: Send section size: 6144, Section count:2560
> Aug 20 03:57:29 ubuntuhv kernel: [  114.962711] hv_netvsc vmbus_0_14: Device MAC 00:15:5d:6f:02:af link state up
> Aug 20 03:57:34 ubuntuhv kernel: [  120.027718] hv_netvsc vmbus_0_14: net device safe to remove
> Aug 20 03:57:34 ubuntuhv kernel: [  120.030047] hv_netvsc: hv_netvsc channel opened successfully
> Aug 20 03:57:34 ubuntuhv kernel: [  120.035422] hv_netvsc vmbus_0_14 eth0: unable to establish receive buffer's gpadl
> Aug 20 03:57:34 ubuntuhv kernel: [  120.039778] hv_netvsc vmbus_0_14 eth0: unable to connect to NetVSP - 4
> Aug 20 03:57:34 ubuntuhv kernel: [  120.039818] ------------[ cut here ]------------
> Aug 20 03:57:34 ubuntuhv kernel: [  120.039832] kernel BUG at drivers/hv/channel.c:504!

This is one is also a rude BUG_ON:
        ret = vmbus_post_msg(msg, sizeof(struct vmbus_channel_close_channel));

        BUG_ON(ret != 0);

vmbus_post_msg() hv_post_message() can easily return !0.
i.e. if this kmalloc() fails:
        addr = (unsigned long)kmalloc(sizeof(struct aligned_input), GFP_ATOMIC);
        if (!addr)
                return -ENOMEM;

-- 
Thanks,
//richard
