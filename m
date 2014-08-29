Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaH2DHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 23:07:13 -0400
Received: from regular2.263xmail.com ([211.157.152.4]:47376 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaH2DHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 23:07:10 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: huangtao@rock-chips.com
X-FST-TO: huangtao@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: huangtao@rock-chips.com
X-UNIQUE-TAG: <b5582b2b8747f84f881c21e01eae22fc>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <53FFEE40.3010001@rock-chips.com>
Date: Fri, 29 Aug 2014 11:06:40 +0800
From: Huang Tao <huangtao@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Kever Yang <kever.yang@rock-chips.com>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "wulf@rock-chips.com" <wulf@rock-chips.com>,
        "lyz@rock-chips.com" <lyz@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lorenzo.pieralisi@arm.com
Subject: Re: [RESEND PATCH] ARM: dts: make arch-timer always on in rk3288
 soc
References: <1409190017-12656-1-git-send-email-kever.yang@rock-chips.com> <20140828091758.GB14650@leverpostej> <20140828151121.GM14650@leverpostej>
In-Reply-To: <20140828151121.GM14650@leverpostej>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark:

在 2014年08月28日 23:11, Mark Rutland 写道:
> To clarify: if there are low power states that the CPU can enter where
> we lose state, then this patch isn't correct.
Right now, the software of RK3288 SoC only support CPU hotplug
(cpu_on/off) and power off all CPUs on suspend.
We do not implement cpuidle to power off CPU. Do you think we should
introduce a broadcast timer?
On our early kernel, I never see any interrupt on a broadcast timer
(yes, we implement it with a external timer).
>
> A more general approach would be to enable the broadcast hrtimer for
> arm, as has been done for arm64.
Yes. I think it should be done by arm framework.
>
> See commit 5d1638acb9f6 (tick: Introduce hrtimer based broadcast) which
> introduced the broadcast hrtimer, and commit 9358d755bd5c (arm64:
> kernel: initialize broadcast hrtimer based clock event device) which
> added the requisite plumbing for arm64.



