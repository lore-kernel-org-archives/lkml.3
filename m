Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaLNJsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 04:48:14 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:8387 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaLNJsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 04:48:07 -0500
X-IronPort-AV: E=Sophos;i="5.07,574,1413270000"; 
   d="scan'208";a="53020093"
Message-ID: <548D5CD1.10801@broadcom.com>
Date: Sun, 14 Dec 2014 10:48:01 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Ray Jui <rjui@broadcom.com>, Christian Daudt <bcm@fixthebug.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@linaro.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>, Kumar Gala <galak@codeaurora.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH v2 1/4] pci: iProc: define Broadcom iProc PCIe binding
References: <1418351817-14898-2-git-send-email-rjui@broadcom.com> <3907917.zNo7yttzkh@wuerfel> <548C0F80.2090300@broadcom.com> <3383252.Ad6Qf0H2fa@wuerfel>
In-Reply-To: <3383252.Ad6Qf0H2fa@wuerfel>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/14 20:46, Arnd Bergmann wrote:
> On Saturday 13 December 2014 11:05:52 Arend van Spriel wrote:
>>
>> Makes sense. I think that is what Hauke meant by "adding
>> additional support for registering to bcma". So the discovery info is a
>> piece of read-only memory in the chip. Its address is stored in the
>> chipcommon core register space. BCMA parses that memory blob resulting
>> in a list of cores which register address info. We could add DT support
>> in BCMA matching the compatible string and register a core for it.
>
> Ah, interesting idea. That would mirror what we do for drivers/amba,
> I like the idea.

+ Rafal

Let's explore this. Although I don't have the iProc hardware to verify it.

>> However, apart from the discovery info a "discoverable ARM AXI" chip has
>> a register space per core that provides common procedures like
>> enable/disable, reset, core status, which are implemented in BCMA. I am
>> not seeing that register space in the DT examples so I guess this IP
>> block is not there for iProc chips.
>
> I wouldn't draw conclusions from the absence of some node. Maybe these
> registers are present but just not used by the original BSP.

I do not intend to. We have raised the question internally to iProc chip 
designers.

Regards,
Arend
