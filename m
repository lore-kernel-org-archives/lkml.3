Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaG1KrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:47:07 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:60668 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaG1KrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:47:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Graeme Gregory <graeme.gregory@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH 19/19] Documentation: ACPI for ARM64
Date: Mon, 28 Jul 2014 12:46:17 +0200
Message-ID: <5959830.lpqeqL7HbK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53D616AD.2090501@linaro.org>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <5014834.k6eecMddPC@wuerfel> <53D616AD.2090501@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:v1x/djs+a5gMy6XNwXJ0nfHNNR+IKhwQKBwuxSIyyDu
 XvuysoopGBKy4EFoFDLc32jWQnm13ssjg72tsbmaTmyTYwc5nm
 nWabvFXTFAZsFKIhq5rqHRB3ZjzqLuijNAWRHUJUYRap9R30qa
 z7/k+aWJp9gu9NPN0+XSTFt9K6zqZ/e9ZEOJz5p4Ob7NlwTwdo
 p3pli6t1k1gKQWBgoLdEOUxWsjsIxzbKKQI5tek5lcS27Lfu6Q
 +plTh5MM53NC4BqYKXRpWlT15LU6iZv9Xi6kUJNkJ84iy5ZZ8l
 QB8eFf86hjaA3+3uUlh3WdcLbQP6BLL4CX1BAuqU9cMWligfBt
 z1XhQmo/KGrnr2hJwnhI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2014 10:23:57 Graeme Gregory wrote:
> The PL011 UART is the use-case I keep hitting, that IP block has a 
> variable input clock on pretty much everything I have seen in the wild. 

Ok, I see. What does ACPI-5.1 say about pl011?

Interestingly, the subset of pl011 that is specified by SBSA does not
contain the IBRD/FBRD registers, effectively making it a fixed-rated
UART (I guess that would be a ART, without the U then), and you
consequently don't even need to know the clock rate.

However, my guess is that most hardware in the real world contains
an actual pl011 and it does make a lot of sense to allow setting
the baud rate on it, which then requires knowing the input clock.

If there is any hardware that implements just the SBSA-mandated subset
rather than the full pl011, we should probably implement both
in the kernel: a dumb driver that can only send and receive, and the
more complex one that can set the bit rates and flow-control but that
requires a standardized ACPI table with the input clock rate.

Whether the two would belong into one file or two separate driver
modules is something I can't tell, it would be up to the serial
maintainers to decide.

> I really hope that this use does not spread beyond a few essential 
> devices like the UART. IMO all real hardware should be the other side of 
> a PCIe bridge.

I would definitely agree with that.

	Arnd
