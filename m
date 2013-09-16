Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab3IPKdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 06:33:35 -0400
Received: from postout1.mail.lrz.de ([129.187.255.137]:38525 "EHLO
	postout1.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab3IPKde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 06:33:34 -0400
From: "Morales, Alejandra" <alejandra.morales@tum.de>
To: Oliver Neukum <oliver@neukum.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Doubts on IO requests in USB subsystem
Thread-Topic: Doubts on IO requests in USB subsystem
Thread-Index: Ac6tNIxdeqg8/IyVTFGPG7NXqAfNbwANfR4AAVc9W4I=
Date: Mon, 16 Sep 2013 10:33:31 +0000
Message-ID: <9E3F9C2076C45D4783F09B90D5BE77CE18E667@BADWLRZ-SWMBX13.ads.mwn.de>
References: <9E3F9C2076C45D4783F09B90D5BE77CE189C61@BADWLRZ-SWMBX13.ads.mwn.de>,<1378744818.1381.4.camel@linux-fkkt.site>
In-Reply-To: <1378744818.1381.4.camel@linux-fkkt.site>
Accept-Language: en-US, es-ES
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4ca0:2001:40:2d1a:f573:1bbf:1ff2]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/9/9 Oliver Neukum <oliver@neukum.org>
>
> Your prime suspect is the detection of medium change which was
> moved into the kernel in 3.2 or so. It can be disabled by sysfs.
> Generally the notion that a certain task originates a read or write
> on a block device is iffy. Read-ahead and shared data structures
> make it impossible to accurately tell.
>
> USB storage devices are notorious for setting the removable bit
> even if they have no removable medium.
>

Thanks for the answer Oliver. Unfortunately it doesn't seem to be the
medium change detection what is causing these requests, since the
removable bit is disabled and the polling period is set to -1:

morales@nonzerodesk:~$ udevadm info --query all --path /sys/block/sdc/ --attribute-walk

looking at device '/devices/pci0000:00/0000:00:1a.7/usb1/1-3/1-3:1.0/host11/target11:0:0/11:0:0:0/block/sdc':
    KERNEL=="sdc"
    SUBSYSTEM=="block"
    DRIVER==""
    ATTR{range}=="16"
    ATTR{ext_range}=="256"
    ATTR{removable}=="0"
    ATTR{ro}=="0"
    ATTR{size}=="1953525168"
    ATTR{alignment_offset}=="0"
    ATTR{discard_alignment}=="0"
    ATTR{capability}=="50"
    ATTR{stat}=="   12805     1970   102691    23528   747334     2557  5999128  3340096        0  1963084  3362880"
    ATTR{inflight}=="       0        0"
    ATTR{events}==""
    ATTR{events_async}==""
    ATTR{events_poll_msecs}=="-1"


Regards
- Alejandra