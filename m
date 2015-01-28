Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbbA2Bv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:51:26 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:54176 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758843AbbA2BvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:51:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
Cc: Guenter Roeck <linux@roeck-us.net>, wim@iguana.be,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, paul@crapouillou.net
Subject: Re: [PATCH 1/2] dt: watchdog: Add DT binding documentation for jz47xx watchdog timer
Date: Wed, 28 Jan 2015 12:23:48 +0100
Message-ID: <9831838.T0biTLFe1N@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54C8B974.8030703@imgtec.com>
References: <1422371490-44402-1-git-send-email-Zubair.Kakakhel@imgtec.com> <9081741.fTg5kD1W54@wuerfel> <54C8B974.8030703@imgtec.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:WuTvrsnsGBLG5WSxNH6mBLAjQZ1bjEovJlFREJYCIpY7q0jJhaS
 vQCISJV6rUE2HBhEE+lxjdBTjd/tLNjwJZvOXVrX8OX5VvOeWRh+tgUT2d7Sg/Hrx4z2ju+
 RG7w5+nSQpefEjxA2D9kz5aRhpLggrqrvWliPfEN/TGpETKrcFKQKSa+zonDHegAX0bidER
 O96YDjT3cCYXDKdwMozkA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2015 10:27:00 Zubair Lutfullah Kakakhel wrote:
> 
> There is on-going work to fix jz4740, add jz4780 and shake the entire clock tree as well.
> 
> Patch 14 onwards in this series
> http://patchwork.linux-mips.org/bundle/paulburton/ci20-v3.20/

Right, that looks good.
 
> Instead of lumping things out in huge changesets, I intended to push out the minor patches that are disjoint.
> 
> That was the purpose of sending these two patches.
> 
> Current binding requires the clock-name to be "rtc". Hence the name at the moment.

The problem with the binding is that once you've established it, it
is very hard to change. One possible solution would be to try
'of_clk_get(dev->of_node, 0)' in the driver first, and only then
call clk_get(dev, "rtc"). Doing that, you can have an anonymous clock
in the DT without waiting for the clock driver to get merged first
or breaking the existing setup.

	Arnd
