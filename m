Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3AZK34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 05:29:56 -0500
Received: from mout.gmx.net ([212.227.17.20]:55210 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199Ab3AZK3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 05:29:53 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18Zv19TynEZI2RpeoSrsTArcq/Uje6zbRIOdZnQvF
	cBYf98s8JzK3AO
Message-ID: <5103B01D.5070303@gmx.de>
Date: Sat, 26 Jan 2013 11:29:49 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130111 Thunderbird/17.0.2
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: How to find an unused TAP device with kernel 3.8 ?
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With kernel 3.8. I just realized that all pre-defined TAP devices are
RUNNING even if no virtual linux system is using it. Now I'm wondering
whether this is a new feature of the upcoming kernel, a bug of the old -
and how I can avoid that.

Background : When I start a user mode linux instance, I currently grep
for the next free tap device in this way :

Code:	
for t in $(ifconfig | grep "^tap" | cut -f1 -d:)
do
   ethtool $t | grep -q 'Link detected: no'
   if [[ $? -eq 0 ]]; then
      NET="tuntap,$t"
      break
   fi
done

but this doesn't work now anymore.

Here is the diff in dmesg

$ diff 3.7.1 3.8.0-rc1+ | grep UP

< br0: flags=4355<UP,BROADCAST,PROMISC,MULTICAST>  mtu 1500
> br0: flags=4419<UP,BROADCAST,RUNNING,PROMISC,MULTICAST>  mtu 1500

< tap0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
> tap0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500


more details : http://forums.gentoo.org/viewtopic-p-7211498.html#7211498


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
