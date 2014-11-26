Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaKZTmC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:42:02 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:43820 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaKZTl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:41:59 -0500
MIME-Version: 1.0
In-Reply-To: <547488EB.2040507@ti.com>
References: <1416874644-12070-1-git-send-email-abrestic@chromium.org>
	<1416874644-12070-8-git-send-email-abrestic@chromium.org>
	<547488EB.2040507@ti.com>
Date: Wed, 26 Nov 2014 11:41:58 -0800
X-Google-Sender-Auth: lRoFRNfCdhEMTpZk9q2BFnTC4CQ
Message-ID: <CAL1qeaHZCh1AomPTQGKN-ytx7EyW8Gncb64S1ikGk0eB16maRA@mail.gmail.com>
Subject: Re: [PATCH V6 07/12] pinctrl: tegra-xusb: Add USB PHY support
From: Andrew Bresticker <abrestic@chromium.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Felipe Balbi <balbi@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 5:49 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
>
> On Tuesday 25 November 2014 05:47 AM, Andrew Bresticker wrote:
>> In addition to the PCIe and SATA PHYs, the XUSB pad controller also
>> supports 3 UTMI, 2 HSIC, and 2 USB3 PHYs.  Each USB3 PHY uses a single
>> PCIe or SATA lane and is mapped to one of the three UTMI ports.
>>
>> The xHCI controller will also send messages intended for the PHY driver,
>> so request and listen for messages on the mailbox's PHY channel.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> Reviewed-by: Stephen Warren <swarren@nvidia.com>
>> ---
>> No changes from v5.
>> Changes from v4:
>>  - Disabled USB support on missing mailbox channel instead of failing
>>    to probe.
>>  - Made usb3-port a pinconfig property.
>>  - Addressed review comments from Thierry.
>> No changes from v3.
>> Changes from v2:
>>  - Added support for nvidia,otg-hs-curr-level-offset property.
>>  - Moved mailbox request handling to workqueue.
>>  - Added filtering out of non-PHY mailbox messages.
>>  - Dropped "-otg" from VBUS supplies.
>> Changes from v1:
>>  - Updated to use common mailbox API.
>>  - Added SATA PHY enable sequence for USB3 ports using the SATA lane.
>>  - Made USB3 port-to-lane mappins a top-level binding rather than a pinconfig
>>    binding.
>> ---
>>  drivers/pinctrl/Kconfig              |    1 +
>>  drivers/pinctrl/pinctrl-tegra-xusb.c | 1262 +++++++++++++++++++++++++++++++++-
>>  include/soc/tegra/xusb.h             |    7 +
>>  3 files changed, 1254 insertions(+), 16 deletions(-)
>
> The devm_phy_create() API has changed (see linux-phy next) and the patch that
> modified the existing devm_phy_create() in pinctrl-tegra-xusb.c has also been
> merged in linux-phy tree.

Ok, I'll rebase on top of that.
