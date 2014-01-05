Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaAEAT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 19:19:28 -0500
Received: from wildsau.enemy.org ([193.170.194.34]:46778 "EHLO
	wildsau.enemy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbaAEAT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 19:19:27 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Jan 2014 19:19:27 EST
Date: Sun, 5 Jan 2014 01:13:53 +0100 (CET)
From: Herbert Rosmanith <lkml@wildsau.enemy.org>
To: linux-kernel@vger.kernel.org
Subject: 3.11.10: rtl8192cu device name, kernel crash
Message-ID: <alpine.LNX.2.00.1401050108340.14069@wildsau.enemy.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hello list,

this afternoon I bought a new usb/wlan adapter, which identifies 
itself as:

    # lsusb
    ...
    Bus 001 Device 017: ID 0bda:8178 Realtek Semiconductor Corp. RTL8192CU 802.11n WLAN Adapter

the first thing I noticed is that the device name is renamed:

    [ 4444.688299] systemd-udevd[3090]: renamed network interface wlan1 to wlp0s29f7u4u4u2

Excellent! I always hated that userfriendly and easy to remember names like "wlan1".
Finally I have a more sophisticated name, "wlp0s29f7u4u4u2" that strictly follows
The Tao Of Terribly Silly Device Naming.

Additionally, iwconfig and ifconfig cannot decide upon the device name.
While iwconfig sees "wlp0s29f7u4u4u2", ifconfig is a bit short-sighted and 
only sees "wlp0s29f7".
The problem is that none of the two devicenames can be used for configuring it:

    # dhclient -d wlp0s29f7
    ...
    SIOCSIFADDR: No such device
    wlp0s29f7: ERROR while getting interface flags: No such device
    wlp0s29f7: ERROR while getting interface flags: No such device
    Bind socket to interface: No such device

    and:

     # dhclient -d wlp0s29f7u4u4u2
     ...
     Bind socket to interface: No such device

Renaming "wlp0s29f7u4u4u2" back to "wlan1" will make the adapter known to
dhclient/ifconfig (finally udev can do something useful), but not without
crashing the system in between: I added the mac-addr. to the
persistent-net udev-rules, did a /etc/init.d/udev restart,
and removed the adapter from the usb hub. Instantly, the system froze, I had to
push the power button to get it back. This was the 2nd time the system
crashed, the first time on the console: it was some kernel panic. As the system
didn't react anymore, I did not bother to write down the lengthy panic message.

By the way, kernel version is 3.11.10.
As the device is handled by the rtl8192cu module, which is not in the 
staging directory, it is considered stable, isn't it?

cheers,
herp

