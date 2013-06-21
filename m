Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946243Ab3FUWz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 18:55:56 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:41310 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946172Ab3FUWzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 18:55:55 -0400
Date: Sat, 22 Jun 2013 00:55:41 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: "opensource@tigusoft.pl" <opensource@tigusoft.pl>
Cc: linux-kernel@vger.kernel.org, security@debian.org
Subject: Re: hanging, and possible exploit/ddos from LAN for RTL and other
 cards (watchdog netdev)
Message-ID: <20130621225541.GA29801@electric-eye.fr.zoreil.com>
References: <201306160933.45961.opensource@tigusoft.pl>
 <20130616163921.GA28368@electric-eye.fr.zoreil.com>
 <201306211603.53725.opensource@tigusoft.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306211603.53725.opensource@tigusoft.pl>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

opensource@tigusoft.pl <opensource@tigusoft.pl> :
> On Sunday 16 June 2013 18:39:21 Francois Romieu wrote:
> 
> Thank you for feedback. We provide XID, IRQ and additional info below.

Executive summary:
1. affected Realtek nics are 8168evl (XID 0c900800) and an old PCI
   (XID 18000000)
2. failing marvell nic resorts to a proprietary fglrx tainted kernel
   on a computer with several graphic cards

(2) is nothing I am thrilled to spend time on, especially in a
clusterfucked openbsd-tor-bitcoin-grsecurity-backport-from-hell
technical context.

b423e9ae49d78ea3f53b131c8d5a6087aed16fd6 must be applied if tx
checksumming is enabled on your 8168evl (see 'ethtool -k eth0').
b423e9ae49d78ea3f53b131c8d5a6087aed16fd6 is still pending inclusion
in -stable so it can only be found in current -git.

[...]
>  * We plan to connect -eth-tcpdump-eth- boxes between some computers and LAN
>  * We plan to swap electrical devices: switches, even cables to exclude this

No overclocking nor outdated gigabyte EP45xyz motherboard bioses ?

[...]
> --- possible solutions ------------------------------------
> #1 the patch rtl8169-fix1a-3.2.46.patch below  (NO. not working)

As expected: 8168evl is RTL_GIGA_MAC_VER_34.

> #2 kernel cmdline "pcie_aspm=off"  (not tested enough)
> #3 kernel cmdline "clocksource=acpi_pm" (not tested enough)
> 
> Since rearranging the network as in <info1> below, the hang of
> trident-mainboard-based computer no longer hangs entire network
> easily, so we wait for the freezing of computers to reoccur.

8168 may go into a mac pause frame frenzy if it fails.

[...]
> - when 2nd card was plugged in (usb0) it instantly was unhanging the computer 
> same as replugging eth0 cable would, and seemed to immunize it from hanging

Ok.

[...]
>         r8169 0000:02:00.0: eth4: unable to load firmware patch 
> rtl_nic/rtl8168e-3.fw (-2)

You can give it a try.

-- 
Ueimor
