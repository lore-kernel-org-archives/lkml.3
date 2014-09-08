Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaIHNAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:00:55 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:56823 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaIHNAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:00:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Robert Richter <rric@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Robert Richter <rrichter@cavium.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64, defconfig: Increase NR_CPUS default to 64
Date: Mon, 08 Sep 2014 15:00:47 +0200
Message-ID: <3450151.nDuN2aF2Xl@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410176689-20020-1-git-send-email-rric@kernel.org>
References: <1410176689-20020-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:t7uZO6sR6Gh2/KhnpdZFruQ4ww78XuZAvPvdpfDbwi0
 tGL7UXXo9YZCbRt6HmJd2WI3PKE6SIpXSfe64oQnJJbNIBaRtU
 zVqa7na2DveSIOHxrWyorO4IIfkVLsqWhIzsRkSIJOzEZm9B1H
 6mcN/Ac2rQUYvmK8phCU1/XfyQrlv5Wd/iLx+D+WA/1/ONZs9c
 oMQhM5z+bGACgYu5HxbtaXNhNw5zxFR4frqobu8mvWSOwjhTB2
 Tp0tmZaJZsN+qYCcsu7vMJiY4aW0tfB/3cqbuDwkD4/2XCRgmX
 iUAk5o4l/7vxo81cu3XcLZ+HMFZgUbWky5/1/4b4WRKa3IXv6j
 om7C30YK8Sz0weefs4jw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2014 13:44:48 Robert Richter wrote:
> From: Robert Richter <rrichter@cavium.com>
> 
> Raising the current maximum limit to 64. This is needed for Cavium's
> Thunder systems that will have at least 48 cores per die.
> 
> The change keeps the current memory footprint in cpu mask structures.
> It does not break existing code. Setting the maximum to 64 cpus still
> boots systems with less cpus.
> 
> Mark's Juno happily booted with a NR_CPUS=64 kernel.
> 
> Tested on our Thunder system with 48 cores. We could see interrupts to
> all cores.
> 
> Cc: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Robert Richter <rrichter@cavium.com>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

FWIW, have you tried what happens when you increase the number further?
We have architectures on which we support thousands of CPUs, so I wonder
if there is a point at which this stops working on ARM64.

Are you able to compile and boot a kernel built with e.g. NR_CPUS=256 or
4096 on your hardware?

	Arnd
