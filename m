Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3EIMDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:03:45 -0400
Received: from dovecot.logic.tuwien.ac.at ([128.130.175.61]:37438 "EHLO
	mail.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3EIMDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:03:43 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 May 2013 08:03:42 EDT
Date: Thu, 9 May 2013 20:56:30 +0900
From: Norbert Preining <preining@logic.at>
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        hostap@lists.shmoo.com
Subject: RTL driver for RTL8191SEvB and/or wpa-supplicant really broken at
	times
Message-ID: <20130509115630.GC5111@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

here is a short status report on my experiences with:
	kernel 3.9.0
	wpa_supplicant 1.0
	hardware RTL191SEvB
	Debian/sid

Short summary: broken to the degree that internet connection is impossible

Sorry for the long mail, I tried to reduce to the essentials only.

Contents:
=========
0) hardware and software description
1) during connection permanent break off
2) connection seems established according to kernel and NM, but nothing works
3) if connection is working, ping times are crazy and connection breaks down suddenly
4) conclusion


0) hardware and software description
====================================
Hardware:
Lenovo Thinkpad Edge
WLAN:
03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless LAN Controller (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. Device e020
	Flags: bus master, fast devsel, latency 0, IRQ 17
	I/O ports at 2000 [size=256]
	Memory at f0500000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Legacy Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Virtual Channel
	Capabilities: [160] Device Serial Number 88-55-22-fe-ff-4c-e0-00
	Kernel driver in use: rtl8192se

Debian unstable up to date
kernel 3.9.0
# wpa_supplicant -v
wpa_supplicant v1.0
Copyright (c) 2003-2012, Jouni Malinen <j@w1.fi> and contributors

Debian version: 1.0-3+b2

Please note: during all the following experiments at times
two other computers (iPhone, WinXP) very connected without
any problems (of course on different IPs).


ad 1) during connection permanent break off
============================================

typical dmesg output:
many times:
May  8 20:54:59 tofuschnitzel NetworkManager[4878]: <info> (wlan0): supplicant interface state: disconnected -> scanning
May  8 20:54:59 tofuschnitzel wpa_supplicant[5513]: wlan0: SME: Trying to authenticate with 00:3a:9d:b4:54:5a (SSID='norbujp' fr
eq=2447 MHz)
kernel: [19070.021021] wlan0: authenticate with 00:3a:9d:b4:54:5a
NetworkManager[4878]: <info> (wlan0): supplicant interface state: scanning -> authenticating
kernel: [19070.040313] wlan0: send auth to 00:3a:9d:b4:54:5a (try 1/3)
kernel: [19070.144143] wlan0: send auth to 00:3a:9d:b4:54:5a (try 2/3)
kernel: [19070.248113] wlan0: send auth to 00:3a:9d:b4:54:5a (try 3/3)
wpa_supplicant[5513]: wlan0: Trying to associate with 00:3a:9d:b4:54:5a (SSID='norbujp' freq=2447 MHz)
kernel: [19070.286906] wlan0: authenticated
kernel: [19070.288224] wlan0: associate with 00:3a:9d:b4:54:5a (try 1/3)
NetworkManager[4878]: <info> (wlan0): supplicant interface state: authenticating -> associating
kernel: [19070.392185] wlan0: associate with 00:3a:9d:b4:54:5a (try 2/3)
kernel: [19070.496204] wlan0: associate with 00:3a:9d:b4:54:5a (try 3/3)
kernel: [19070.600253] wlan0: association with 00:3a:9d:b4:54:5a timed out
NetworkManager[4878]: <info> (wlan0): supplicant interface state: associating -> disconnected

after several of these I get one of the following:
kernel: [19073.340075] wlan0: associated
kernel: [19073.340155] cfg80211: Calling CRDA for country: JP
NetworkManager[4878]: <info> (wlan0): supplicant interface state: associating -> 4-way handshake
kernel: [19073.347635] cfg80211: Regulatory domain changed to country: JP
kernel: [19073.347643] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
kernel: [19073.347648] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
kernel: [19073.347652] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
kernel: [19073.347656] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm)
...
dbus[4074]: [system] Activating service name='org.freedesktop.PackageKit' (using servicehelper)
dbus[4074]: [system] Successfully activated service 'org.freedesktop.PackageKit'
kernel: [19077.405951] wlan0: deauthenticated from 00:3a:9d:b4:54:5a (Reason: 2)
wpa_supplicant[5513]: wlan0: WPA: 4-Way Handshake failed - pre-shared key may be incorrect
wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
kernel: [19077.416143] cfg80211: Calling CRDA to update world regulatory domain
NetworkManager[4878]: <info> (wlan0): supplicant interface state: 4-way handshake -> disconnected
NetworkManager[4878]: <info> Activation (wlan0/wireless): disconnected during association, asking for new key.

but it is the correct key! Anyway, then the above game restarts ...

sometimes, after many many many tries, the kernel/NM seems to believe
it got a connection:

2) connection seems established according to kernel and NM, but nothing works
=============================================================================
it starts as before, but then succeeds - in some way:
wpa_supplicant[5513]: wlan0: WPA: Key negotiation completed with 00:3a:9d:b4:54:5a [PTK=CCMP GTK=CCMP]
wpa_supplicant[5513]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:3a:9d:b4:54:5a completed (reauth) [id=0 id_str=]
NetworkManager[4878]: <info> (wlan0): supplicant interface state: 4-way handshake -> completed
NetworkManager[4878]: <info> Activation (wlan0/wireless) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'norbujp'.
NetworkManager[4878]: <info> Activation (wlan0) Stage 3 of 5 (IP Configure Start) scheduled.
NetworkManager[4878]: <info> Activation (wlan0) Stage 3 of 5 (IP Configure Start) started...
NetworkManager[4878]: <info> (wlan0): device state change: config -> ip-config (reason 'none') [50 70 0]
NetworkManager[4878]: <info> Activation (wlan0) Beginning DHCPv4 transaction (timeout in 45 seconds)
NetworkManager[4878]: <info> dhclient started with pid 30807
NetworkManager[4878]: nm_utils_do_sysctl: assertion `path != NULL' failed
NetworkManager[4878]: <info> Activation (wlan0) Beginning IP6 addrconf.
NetworkManager[4878]: <warn> sysctl: failed to open '/proc/sys/net/ipv6/conf/wlan0/disable_ipv6': (2) No such file or directory
NetworkManager[4878]: <warn> sysctl: failed to open '/proc/sys/net/ipv6/conf/wlan0/disable_ipv6': (2) No such file or directory
NetworkManager[4878]: <info> Activation (wlan0) Stage 3 of 5 (IP Configure Start) complete.
dhclient: Internet Systems Consortium DHCP Client 4.2.4
dhclient: Copyright 2004-2012 Internet Systems Consortium.
dhclient: All rights reserved.
dhclient: For info, please visit https://www.isc.org/software/dhcp/
dhclient: 
NetworkManager[4878]: <info> (wlan0): DHCPv4 state changed nbi -> preinit
dhclient: Listening on LPF/wlan0/88:9f:fa:f9:07:28
dhclient: Sending on   LPF/wlan0/88:9f:fa:f9:07:28
dhclient: Sending on   Socket/fallback
dhclient: DHCPREQUEST on wlan0 to 255.255.255.255 port 67
dhclient: DHCPACK from 192.168.0.1
dhclient: bound to 192.168.0.5 -- renewal in 37312 seconds.
NetworkManager[4878]: <info> (wlan0): DHCPv4 state changed preinit -> reboot
NetworkManager[4878]: <info>   address 192.168.0.5
NetworkManager[4878]: <info>   prefix 24 (255.255.255.0)
NetworkManager[4878]: <info>   gateway 192.168.0.1
NetworkManager[4878]: <info>   nameserver '192.168.0.1'
NetworkManager[4878]: <info> Activation (wlan0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
NetworkManager[4878]: <info> Activation (wlan0) Stage 5 of 5 (IPv4 Commit) started...
NetworkManager[4878]: <info> (wlan0): device state change: ip-config -> secondaries (reason 'none') [70 90 0]
NetworkManager[4878]: <info> Activation (wlan0) Stage 5 of 5 (IPv4 Commit) complete.
NetworkManager[4878]: <info> (wlan0): device state change: secondaries -> activated (reason 'none') [90 100 0]
NetworkManager[4878]: <info> Policy set 'Auto norbujp' (wlan0) as default for IPv4 routing and DNS.
NetworkManager[4878]: <info> Activation (wlan0) successful, device activated.
dbus[4074]: [system] Activating service name='org.freedesktop.nm_dispatcher' (using servicehelper)
dbus[4074]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
ntpd[4779]: Listen normally on 5 wlan0 192.168.0.5 UDP 123
ntpd[4779]: peers refreshed
nm-dispatcher.action: Script '/etc/NetworkManager/dispatcher.d/01ifupdown' took too long; killing it.
May  8 20:45:22 tofuschnitzel NetworkManager[4878]: <warn> Dispatcher script timed out: Script '/etc/NetworkManager/dispatcher.d/01ifupdown' timed out.
May  8 20:45:37 tofuschnitzel NetworkManager[4878]: <info> (wlan0): IP6 addrconf timed out or failed.
May  8 20:45:37 tofuschnitzel NetworkManager[4878]: <info> Activation (wlan0) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
May  8 20:45:37 tofuschnitzel NetworkManager[4878]: <info> Activation (wlan0) Stage 4 of 5 (IPv6 Configure Timeout) started...
May  8 20:45:37 tofuschnitzel NetworkManager[4878]: <info> Activation (wlan0) Stage 4 of 5 (IPv6 Configure Timeout) complete.

But although both kernel as well as NM believe that all is fine:
$ ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 88:9f:fa:f9:07:28  
          inet addr:192.168.0.5  Bcast:192.168.0.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:205848 errors:0 dropped:0 overruns:0 frame:0
          TX packets:4519 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:44049656 (42.0 MiB)  TX bytes:750906 (733.3 KiB)
$ iwconfig wlan0
wlan0     IEEE 802.11bgn  ESSID:"norbujp"  
          Mode:Managed  Frequency:2.447 GHz  Access Point: 00:3A:9D:B4:54:5A   
          Bit Rate=150 Mb/s   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
          Power Management:off
          Link Quality=70/70  Signal level=-35 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:6   Missed beacon:0

absolutely nothing works: Examples:
[~] ping 192.168.0.1
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
>From 192.168.0.5 icmp_seq=1 Destination Host Unreachable
>From 192.168.0.5 icmp_seq=2 Destination Host Unreachable
>From 192.168.0.5 icmp_seq=5 Destination Host Unreachable
>From 192.168.0.5 icmp_seq=7 Destination Host Unreachable
>From 192.168.0.5 icmp_seq=39 Destination Host Unreachable
>From 192.168.0.5 icmp_seq=40 Destination Host Unreachable
>From 192.168.0.5 icmp_seq=41 Destination Host Unreachable
>From 192.168.0.5 icmp_seq=42 Destination Host Unreachable
...
--- 192.168.0.1 ping statistics ---
88 packets transmitted, 0 received, +43 errors, 100% packet loss, time 87233ms pipe 4

absolutely nothing goes out - at least it seems so.


Sometimes, though, whoever decided to speak to me, and pings started
to get returned, but then ...

3) if connection is working, ping times are crazy and connection breaks down suddenly
=====================================================================================

pinging my own gateway results in things like:
64 bytes from 192.168.0.1: icmp_req=35 ttl=255 time=119395 ms

or
>From 192.168.0.5 icmp_seq=118 Destination Host Unreachable
>From 192.168.0.5 icmp_seq=119 Destination Host Unreachable
>From 192.168.0.5 icmp_seq=120 Destination Host Unreachable
64 bytes from 192.168.0.1: icmp_req=31 ttl=255 time=91863 ms
64 bytes from 192.168.0.1: icmp_req=32 ttl=255 time=91151 ms
>From 192.168.0.5 icmp_seq=121 Destination Host Unreachable
>From 192.168.0.5 icmp_seq=122 Destination Host Unreachable

or
[~] ping 192.168.0.1
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
64 bytes from 192.168.0.1: icmp_req=3 ttl=255 time=44447 ms
64 bytes from 192.168.0.1: icmp_req=7 ttl=255 time=41123 ms
64 bytes from 192.168.0.1: icmp_req=11 ttl=255 time=55627 ms
64 bytes from 192.168.0.1: icmp_req=14 ttl=255 time=69027 ms
64 bytes from 192.168.0.1: icmp_req=15 ttl=255 time=68046 ms
64 bytes from 192.168.0.1: icmp_req=19 ttl=255 time=75636 ms
64 bytes from 192.168.0.1: icmp_req=24 ttl=255 time=109967 ms
....

big up and down in ping times:
4 bytes from 192.168.0.1: icmp_req=442 ttl=255 time=1.51 ms
64 bytes from 192.168.0.1: icmp_req=443 ttl=255 time=1.61 ms
64 bytes from 192.168.0.1: icmp_req=444 ttl=255 time=2.77 ms
64 bytes from 192.168.0.1: icmp_req=445 ttl=255 time=37.0 ms
64 bytes from 192.168.0.1: icmp_req=446 ttl=255 time=1.53 ms
64 bytes from 192.168.0.1: icmp_req=447 ttl=255 time=469 ms
64 bytes from 192.168.0.1: icmp_req=448 ttl=255 time=116 ms
64 bytes from 192.168.0.1: icmp_req=449 ttl=255 time=1.73 ms
64 bytes from 192.168.0.1: icmp_req=450 ttl=255 time=1.58 ms
64 bytes from 192.168.0.1: icmp_req=451 ttl=255 time=6916 ms
64 bytes from 192.168.0.1: icmp_req=452 ttl=255 time=6632 ms
64 bytes from 192.168.0.1: icmp_req=453 ttl=255 time=5654 ms
64 bytes from 192.168.0.1: icmp_req=454 ttl=255 time=4716 ms
64 bytes from 192.168.0.1: icmp_req=455 ttl=255 time=3896 ms
64 bytes from 192.168.0.1: icmp_req=456 ttl=255 time=2897 ms
64 bytes from 192.168.0.1: icmp_req=457 ttl=255 time=1899 ms
64 bytes from 192.168.0.1: icmp_req=458 ttl=255 time=901 ms
64 bytes from 192.168.0.1: icmp_req=459 ttl=255 time=1.25 ms
64 bytes from 192.168.0.1: icmp_req=460 ttl=255 time=116 ms
64 bytes from 192.168.0.1: icmp_req=461 ttl=255 time=1.48 ms
...
64 bytes from 192.168.0.1: icmp_req=483 ttl=255 time=1.24 ms
64 bytes from 192.168.0.1: icmp_req=485 ttl=255 time=10910 ms
64 bytes from 192.168.0.1: icmp_req=486 ttl=255 time=9913 ms
64 bytes from 192.168.0.1: icmp_req=487 ttl=255 time=8913 ms
64 bytes from 192.168.0.1: icmp_req=488 ttl=255 time=7913 ms
64 bytes from 192.168.0.1: icmp_req=489 ttl=255 time=6913 ms
...
64 bytes from 192.168.0.1: icmp_req=494 ttl=255 time=1915 ms
64 bytes from 192.168.0.1: icmp_req=495 ttl=255 time=915 ms
>From 192.168.0.5 icmp_seq=530 Destination Host Unreachable
>From 192.168.0.5 icmp_seq=531 Destination Host Unreachable
...
>From 192.168.0.5 icmp_seq=581 Destination Host Unreachable
64 bytes from 192.168.0.1: icmp_req=497 ttl=255 time=87064 ms
>From 192.168.0.5 icmp_seq=582 Destination Host Unreachable
...
>From 192.168.0.5 icmp_seq=598 Destination Host Unreachable
64 bytes from 192.168.0.1: icmp_req=498 ttl=255 time=105208 ms
ping: sendmsg: No buffer space available
>From 192.168.0.5 icmp_seq=623 Destination Host Unreachable
...


Looking into the reasons why disconnects happen I see:
[~] grep reason= /var/log/syslog
May  8 20:43:57 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:44:04 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:45:02 tofuschnitzel kernel: [18472.914329] wlan0: deauthenticating from 00:3a:9d:b4:54:5a by local choice (reason=3)
May  8 20:45:02 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
May  8 20:47:34 tofuschnitzel kernel: [18624.597387] wlan0: deauthenticating from 00:3a:9d:b4:54:5a by local choice (reason=3)
May  8 20:47:34 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
May  8 20:48:27 tofuschnitzel kernel: [18677.928400] wlan0: deauthenticating from 00:3a:9d:b4:54:5a by local choice (reason=3)
May  8 20:48:27 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
May  8 20:48:36 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:48:52 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:49:15 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:49:25 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:49:41 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:49:50 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:49:57 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:53:20 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:53:30 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:53:51 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:54:01 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:54:27 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:54:45 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:55:07 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 20:55:36 tofuschnitzel kernel: [19106.844710] wlan0: deauthenticating from 00:3a:9d:b4:54:5a by local choice (reason=3)
May  8 20:55:36 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=3
May  8 21:10:07 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2
May  8 21:10:58 tofuschnitzel kernel: [20029.040231] wlan0: deauthenticating from 00:3a:9d:b4:54:5a by local choice (reason=3)
May  8 21:10:58 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
May  8 21:23:20 tofuschnitzel wpa_supplicant[5513]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:3a:9d:b4:54:5a reason=2


My feeling is also that things like
wpa_supplicant[5513]: wlan0: WPA: Key negotiation completed with 00:3a:9d:b4:54:5a [PTK=CCMP GTK=CCMP]
have a strong effect on the actual connection.


4) conclusion
=============

in the current state, that is release 3.9.0, but the same happened
in earlier kernels, this driver and/or NM is completely useless
at times. At times it just works, at times it does nothing.
In this case, now the 5th day in series ...


Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
