Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaGaUYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:24:39 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:54343 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaGaUYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:24:38 -0400
X-CheckPoint: {53DAA605-7-2100090A-C0000000}
Message-ID: <53DAA605.2030500@tilera.com>
Date: Thu, 31 Jul 2014 16:24:37 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>, <paul@pwsan.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>, <arm@kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] char: tile-srom: Remove reference to platform_bus
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com> <1406298233-27876-2-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1406298233-27876-2-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/2014 10:23 AM, Pawel Moll wrote:
> The code was creating "srom" class devices using
> platform_bus as a parent. As they are not really
> platform devices, make them virtual, using NULL instead.
>
> Cc: Chris Metcalf<cmetcalf@tilera.com>
> Signed-off-by: Pawel Moll<pawel.moll@arm.com>
> ---
>   drivers/char/tile-srom.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Can you clarify the point of this change a bit?  The SROM devices
in question are real devices (bits of silicon on the processor die), not
some kind of virtual construct.  In addition, we also have user binaries
in the wild that know to look for /sys/devices/platform/srom/ paths,
so I'm pretty reluctant to change this path without good reason.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

