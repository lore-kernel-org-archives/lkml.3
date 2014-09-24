Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaIXVle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:41:34 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44667 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaIXVlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:41:32 -0400
Message-ID: <54233A84.7040902@collabora.co.uk>
Date: Wed, 24 Sep 2014 23:41:24 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>, Kukjin Kim <kgene@kernel.org>
CC: =?UTF-8?B?J0FuZHJlYXMgRsOkcmJlcic=?= <afaerber@suse.de>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "'Daniel Drake'" <drake@endlessm.com>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: dts: Add rtc_src clk for s3c-rtc on exynos5250-snow
References: <1410954633-27025-1-git-send-email-javier.martinez@collabora.co.uk> <1410954633-27025-3-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=W7xJ01m2oLtuDnogOmrpwpztbir=59oSWU6oojFYUWKw@mail.gmail.com> <5419ADF9.3010509@suse.de> <00f801cfd6f6$07e10500$17a30f00$@kernel.org> <5421992F.6070908@samsung.com> <54219D47.6010102@collabora.co.uk>
In-Reply-To: <54219D47.6010102@collabora.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

On 09/23/2014 06:18 PM, Javier Martinez Canillas wrote:
> On 09/23/2014 06:00 PM, Kukjin Kim wrote:
>> On 09/23/14 15:17, Kukjin Kim wrote:
>> 
>> I've applied above and this series and please double-check the commits 
>> in my tree. If no problems, I will send the branch out for v3.18 soon...
>>
>> Thanks,
>> Kukjin
>> 
> 
> I've looked the RTC source clock patches and look good to me. Thanks a lot for your help!
> 

Today I also had time to review the rebased patches from Andreas and found
two issues introduced during the merge conflict resolution:

1) The spi_1 dev node on exynos5250-smdk5250.dts now uses the old "cs-gpio" 
   DT property under the controller-data instead of the standard "cs-gpios"
   under the SPI parent. IOW, is a regression of the bug fixed in commit
   e138d43 ("ARM: dts: fix the chip select gpios definition in the SPI nodes").

2) The display-timings child node of the dp-controller was removed in commit
   a98c3c2 ("ARM: dts: update display related nodes for exynos5250-snow") but
   was introduced again in the Snow DTS during the merge.

I'll post a series that fixes both issues with the following patches:

Javier Martinez Canillas (2):
      ARM: dts: Fix chip select GPIO on smdk5250
      ARM: dts: Remove display timings node from exynos5250-snow

I see that you already send a pull request to arm-soc maintainers so probably
these will be part of the fixes during the 3.18 rc cycle.

Best regards,
Javier
