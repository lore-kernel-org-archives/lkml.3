Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaFKVGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:06:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46156 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaFKVGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:06:41 -0400
Message-ID: <5398C4DD.6020509@wwwdotorg.org>
Date: Wed, 11 Jun 2014 15:06:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] pinctrl: Add NVIDIA Tegra XUSB pad controller
 support
References: <1402398708-10722-1-git-send-email-thierry.reding@gmail.com>	<1402398708-10722-2-git-send-email-thierry.reding@gmail.com> <CAL1qeaGKUGjSzriDGptR+h23+bS3ZWuStz6koPURCstkFbEjNA@mail.gmail.com>
In-Reply-To: <CAL1qeaGKUGjSzriDGptR+h23+bS3ZWuStz6koPURCstkFbEjNA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 02:23 PM, Andrew Bresticker wrote:
> On Tue, Jun 10, 2014 at 4:11 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>> From: Thierry Reding <treding@nvidia.com>
>>
>> The XUSB pad controller found on NVIDIA Tegra SoCs provides several pads
>> that lanes can be assigned to in order to support a variety of interface
>> options: USB 2.0, USB 3.0, PCIe and SATA.
>>
>> In addition to the pin controller used to assign lanes to pads two PHYs
>> are exposed to allow the bricks for PCIe and SATA to be powered up and
>> down by PCIe and SATA drivers.

>> diff --git a/drivers/pinctrl/pinctrl-tegra-xusb.c b/drivers/pinctrl/pinctrl-tegra-xusb.c

>> +static int tegra_xusb_padctl_pinconf_group_set(struct pinctrl_dev *pinctrl,
>> +                                              unsigned int group,
>> +                                              unsigned long *configs,
>> +                                              unsigned int num_configs)

>> +       for (i = 0; i < num_configs; i++) {
>> +               param = TEGRA_XUSB_PADCTL_UNPACK_PARAM(configs[i]);
>> +               value = TEGRA_XUSB_PADCTL_UNPACK_VALUE(configs[i]);
>> +
>> +               switch (param) {
>> +               case TEGRA_XUSB_PADCTL_IDDQ:
>> +                       value = padctl_readl(padctl, lane->offset);
> 
> This overwrites the configuration value - probably want to use a
> separate variable for the register value.

It'd be nice to trim what you quote so that people don't have to wade
through hundreds of lines of code to find a 2-line comment. It's easily
missed.
