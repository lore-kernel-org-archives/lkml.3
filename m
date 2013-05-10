Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab3EJQvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 12:51:01 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:41718 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab3EJQu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 12:50:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130509115630.GC5111@gamma.logic.tuwien.ac.at>
References: <20130509115630.GC5111@gamma.logic.tuwien.ac.at>
Date: Fri, 10 May 2013 12:50:58 -0400
Message-ID: <CAGnc4p-LRMSQ-3svzXJ-5ZoX8UzjV0Z-GtgJBLitffqexte9sA@mail.gmail.com>
Subject: Re: RTL driver for RTL8191SEvB and/or wpa-supplicant really broken at times
From: Matt Causey <matt.causey@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        hostap@lists.shmoo.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry - reply got bounced because I accidentially replied with HTML
mode enabled.  Re-sending.


On Thu, May 9, 2013 at 7:56 AM, Norbert Preining <preining@logic.at> wrote:
>
> Dear all,
>
> here is a short status report on my experiences with:
>         kernel 3.9.0
>         wpa_supplicant 1.0
>         hardware RTL191SEvB
>         Debian/sid
>
> Short summary: broken to the degree that internet connection is impossible
>
> Sorry for the long mail, I tried to reduce to the essentials only.
>
> Contents:
> =========
> 0) hardware and software description
> 1) during connection permanent break off
> 2) connection seems established according to kernel and NM, but nothing
> works
> 3) if connection is working, ping times are crazy and connection breaks
> down suddenly
> 4) conclusion
>
>
> 0) hardware and software description
> ====================================
> Hardware:
> Lenovo Thinkpad Edge
> WLAN:
> 03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8191SEvB
> Wireless LAN Controller (rev 10)
>         Subsystem: Realtek Semiconductor Co., Ltd. Device e020
>         Flags: bus master, fast devsel, latency 0, IRQ 17
>         I/O ports at 2000 [size=256]
>         Memory at f0500000 (32-bit, non-prefetchable) [size=16K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
>         Capabilities: [70] Express Legacy Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [140] Virtual Channel
>         Capabilities: [160] Device Serial Number 88-55-22-fe-ff-4c-e0-00
>         Kernel driver in use: rtl8192se
>
> Debian unstable up to date
> kernel 3.9.0
> # wpa_supplicant -v
> wpa_supplicant v1.0
> Copyright (c) 2003-2012, Jouni Malinen <j@w1.fi> and contributors
>
> Debian version: 1.0-3+b2
>
> Please note: during all the following experiments at times
> two other computers (iPhone, WinXP) very connected without
> any problems (of course on different IPs).
>
>


So this section seems to indicate that the access point is ignoring
your probe requests:


> ad 1) during connection permanent break off
> ============================================
>
> typical dmesg output:
> many times:
> May  8 20:54:59 tofuschnitzel NetworkManager[4878]: <info> (wlan0):
> supplicant interface state: disconnected -> scanning
> May  8 20:54:59 tofuschnitzel wpa_supplicant[5513]: wlan0: SME: Trying to
> authenticate with 00:3a:9d:b4:54:5a (SSID='norbujp' fr
> eq=2447 MHz)
> kernel: [19070.021021] wlan0: authenticate with 00:3a:9d:b4:54:5a
> NetworkManager[4878]: <info> (wlan0): supplicant interface state: scanning
> -> authenticating
> kernel: [19070.040313] wlan0: send auth to 00:3a:9d:b4:54:5a (try 1/3)
> kernel: [19070.144143] wlan0: send auth to 00:3a:9d:b4:54:5a (try 2/3)
> kernel: [19070.248113] wlan0: send auth to 00:3a:9d:b4:54:5a (try 3/3)
> wpa_supplicant[5513]: wlan0: Trying to associate with 00:3a:9d:b4:54:5a
> (SSID='norbujp' freq=2447 MHz)
> kernel: [19070.286906] wlan0: authenticated
> kernel: [19070.288224] wlan0: associate with 00:3a:9d:b4:54:5a (try 1/3)
> NetworkManager[4878]: <info> (wlan0): supplicant interface state:
> authenticating -> associating
> kernel: [19070.392185] wlan0: associate with 00:3a:9d:b4:54:5a (try 2/3)
> kernel: [19070.496204] wlan0: associate with 00:3a:9d:b4:54:5a (try 3/3)
> kernel: [19070.600253] wlan0: association with 00:3a:9d:b4:54:5a timed out
> NetworkManager[4878]: <info> (wlan0): supplicant interface state:
> associating -> disconnected

If that is happening for your client somehow, wpa_supplicant won't
work well.  :-)

I understand that you have other clients on the same WLAN, but what is
your wireless infrastructure?  The MAC OID of your BSSID comes back as
"NecAcces" - but I'm not familiar with that vendor.  Also, do you have
a WLAN packet capture (from another host nearby on the same channel)?
That would be helpful as well.

--
Matt
