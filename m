Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaHND5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 23:57:40 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:53173 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaHND5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 23:57:38 -0400
X-263anti-spam: BIG:0;KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 1
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <a5d0f9848135105e95be092467a98f8e>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53EC338E.9060409@rock-chips.com>
Date: Thu, 14 Aug 2014 11:57:02 +0800
From: addy ke <addy.ke@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: dianders@chromium.org
CC: heiko@sntech.de, sonnyrao@chromium.org, stefan@agner.ch,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Add mmc0 and mmc1 aliases for rk3288
References: <1407974880-30626-1-git-send-email-dianders@chromium.org>	<53EC177B.1080706@rock-chips.com> <CAD=FV=XNJ9RRnOaJ5e-D60S5vjZu6UbphdWqqfRq_YfZaXoq+A@mail.gmail.com>
In-Reply-To: <CAD=FV=XNJ9RRnOaJ5e-D60S5vjZu6UbphdWqqfRq_YfZaXoq+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Addy,
> 
> On Wed, Aug 13, 2014 at 6:57 PM, Addy <addy.ke@rock-chips.com> wrote:
> 
>> I think maybe it is suitable as follows:
>> mmc0 = &sdmmc
>> mmc1 = &sdio0
>> mmc2 = &sdio1
>> mmc3 = &emmc
> 
> Right, except the only ones that have landed in Heiko's tree are sdmmc
> and emmc, so we can't do sdio0 and sdio1 yet.  You could post support
> for sdio0 and adio1?

yes, I will post it today.
> 
> Also: it's really handy if emmc is 0.  See below: I don't think it's
> great to use the ID to find the sysconfig registers.
> 
> 
>> So we can get ctrl_id:
>> ctrl_id = of_alias_get_id(host->dev->of_node, "mshc");
> 
> Somehow I hadn't realized that was there.  I guess we could use that
> too.  I'd vote to remove that and use the standard "mmc" numbering
> (and get some momentum to land those patches).  If you want I'll
> repost using the mshc stuff, though.
> 
> 
>> and can get offset of registers:
>> offset = 0x200 + ctrl_id * 8 + 4 * drive_or_sample
> 
> I thought the plan was to actually implement the phase stuff as a clock driver.
> 
> ...even if we didn't, I'd rather not rely on ID like this to find the
> right address.  It's really non-obvious.
> 
> 
> 

