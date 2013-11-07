Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab3KGPCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:02:52 -0500
Received: from omr-d08.mx.aol.com ([205.188.109.207]:61671 "EHLO
	omr-d08.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3KGPCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:02:49 -0500
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Nov 2013 10:02:49 EST
To: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Subject: IPIP6 Linux Kernel Implementation
X-MB-Message-Source: WebUI
X-MB-Message-Type: User
MIME-Version: 1.0
From: Pietro Paolini <pulsarpietro@aol.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
X-Mailer: AOL Webmail 38172-STANDARD
Message-Id: <8D0A9E071C6D495-108C-DE6F@webmail-m208.sysops.aol.com>
X-Originating-IP: [185.15.248.65]
Date: Thu, 7 Nov 2013 09:54:50 -0500 (EST)
x-aol-global-disposition: G
x-aol-sid: 3039ac1d338a527ba9ba5e30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I am writing you regarding the implementation of the IPIP6 tunnel
contained in the Linux Kernel which I am trying to configure in order
to obtain a DS-Lite (IPIP6) compliant tunnel on a router running a
linux OS kernel version 2.6.33.

This my network topology :

lan --> tun1 --> eth0

where the MTU of all links is 1500.

My problem comes up when the packet size of the incoming IPv4 datagram
on my LAN interface is close to the MTU (1496 byte) : then the packet
is "lost" in the file ip6_tunnel.c module at this point :

linux-2.6.33.5/net/ipv6/ip6_tunnel.c
function ip6_tnl_xmit2()
{
....
        mtu = dst_mtu(dst) - sizeof (*ipv6h);
        if (skb->len > mtu) {              --> 1496 > 1460 <--
                *pmtu = mtu;
                err = -EMSGSIZE;
                goto tx_err_dst_release;
        }
....
}

As I understand, I could be wrong of course,  IPv6 fragmentation is not
handled in that module and packets bigger then the mtu - sizeof(IPv6)
are discarded; I am wondering if I can find a workaround in order to
solve this problem as in some way use the IPv6 stack which I assume
handles fragmentation - I could be again wrong - or implement it in the
ip6_tunnel.c module.

I am not an experienced kernel developer then is important for me
understand if I am in the right direction and Linux kernel really does
not provide this feature in a IPIP6 tunnel or if I am wrong; I need to
have that for the implementation of a DS-Lite tunnel which as defined
in the RFC6333 Section 5.3 requires IPv6 packet fragmentation.

Thanks a lot,
Pietro.
