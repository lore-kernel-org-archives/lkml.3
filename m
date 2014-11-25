Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942AbaKYQN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:13:56 -0500
Received: from regular1.263xmail.com ([211.150.99.134]:33105 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaKYQNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:13:55 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-arm-kernel@lists.infradead.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <26c162ab3ddf7536854164d8fd38f2a4>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <5474AAB4.2060301@rock-chips.com>
Date: Wed, 26 Nov 2014 00:13:40 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chris Zhong <zyw@rock-chips.com>, heiko@sntech.de, dianders@chromium.org
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Increase the maximum cpu frequency of rk3288
References: <1416908253-31721-1-git-send-email-zyw@rock-chips.com>
In-Reply-To: <1416908253-31721-1-git-send-email-zyw@rock-chips.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On 11/25/2014 05:37 PM, Chris Zhong wrote:
> The maximum cpu frequency of rk3288 can up to 1.8Ghz, but the vdd_cpu need set
> to 1.4v. I've tested these patches on rk3288 evb board.
I'm not sure why you need this patch, I think we have a discuss
for the cpu operating point before.
In this case:
1. rk3288.dtsi is for all the rk3288 Soc based system, you may need
a separate opp table in rk3288-evb-rk808.dts;
2. 1.4V may beyond the supported voltage range too much,
     and it's not a good idea to add it to rk3288.dtsi as a safe voltage.
3. Do you have a stress/heavy load test on evb with 1.4v at 1.8GHz?

- Kever
>
>
> Chris Zhong (2):
>    ARM: dts: rockchip: change the max voltage of cpu to 1.4v
>    ARM: dts: rk3288: change the max clk of cpu to 1.8Ghz
>
>   arch/arm/boot/dts/rk3288-evb-rk808.dts | 2 +-
>   arch/arm/boot/dts/rk3288.dtsi          | 6 ++++--
>   2 files changed, 5 insertions(+), 3 deletions(-)
>


