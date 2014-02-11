Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaBKCdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 21:33:01 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:45049 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaBKCdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 21:33:00 -0500
Date: Tue, 11 Feb 2014 03:32:58 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Ortwin =?utf-8?B?R2zDvGNr?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: xfrm: is pmtu broken with ESP tunneling?
Message-ID: <20140211023258.GC11150@order.stressinduktion.org>
Mail-Followup-To: Ortwin =?utf-8?B?R2zDvGNr?= <odi@odi.ch>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <52F890D2.2060109@odi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52F890D2.2060109@odi.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, Feb 10, 2014 at 09:41:54AM +0100, Ortwin Glück wrote:
> I am using Openswan to configure an IPSec VPN (using the xfrm/netkey 
> backend). Large HTTP POST requests from the client seem to get stuck, 
> because the outgoing packets are 1530 bytes (before being wrapped into 
> ESP packets). The problem goes away by setting sysctl 
> net.ipv4.ip_no_pmtu_disc=1.

This setting will shrink the path mtu to min_pmtu when a frag needed icmp is
received. It sounds like we calculate the path mtu incorreclty in case of
fragmentation.

> May have something to do with it:
> The tunneled network is 10.6.6.6/32 and I am SNAT'ing some destinations 
> to that IP, so they get routed through the tunnel. Any other networks 
> are not to go through the tunnel.
> 
> iptables -t nat -A POSTROUTING -d "${R}" -j SNAT --to-source 10.6.6.6
> 
> It seems quite clear to me that xfrm is doing something wrong here.

Can you send a ip route get <ip> to the problematic target to see how
far off the calculated value is?

Thanks,

  Hannes

