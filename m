Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaHSQ7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:59:19 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:46049 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbaHSQ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:59:16 -0400
MIME-Version: 1.0
In-Reply-To: <53F2EA5C.1020403@renesas.com>
References: <1408378343-9352-1-git-send-email-abrestic@chromium.org>
	<1408378343-9352-2-git-send-email-abrestic@chromium.org>
	<53F2EA5C.1020403@renesas.com>
Date: Tue, 19 Aug 2014 09:59:15 -0700
X-Google-Sender-Auth: xM1vuKLqUTskHHerbycxdMSLFuQ
Message-ID: <CAL1qeaEkqSHnia=Pc1LMapuwuNhWyU9k-6fb3OhV9y=mUPEAag@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] xhci: Introduce xhci_init_driver()
From: Andrew Bresticker <abrestic@chromium.org>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 11:10 PM, Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> Hi,
>
> (2014/08/19 1:12), Andrew Bresticker wrote:
>> Since the struct hc_driver is mostly the same across the xhci-pci,
>> xhci-plat, and the upcoming xhci-tegra driver, introduce the function
>> xhci_init_driver() which will populate the hc_driver with the default
>> xHCI operations.  The caller must supply a setup function which will
>> be used as the hc_driver's reset callback.
>>
>> Note that xhci-plat also overrides the default ->start() callback so
>> that it can do rcar-specific initialization.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> ---
>> Changes from v1:
>>  - rebased on changes introduced by xhci-rcar driver
> < snip >
>> @@ -300,6 +249,8 @@ MODULE_ALIAS("platform:xhci-hcd");
>>
>>  int xhci_register_plat(void)
>>  {
>> +     xhci_init_driver(&xhci_plat_hc_driver, xhci_plat_setup);
>> +     xhci_plat_hc_drver.start = xhci_plat_start;
>
> Thank you for the care of xhci-rcar driver.
> However, this "xhci_plat_hc_drver" should be "xhci_plat_hc_driver".

D'oh!  Thanks for catching this... had it fixed in my tree but forgot
to update the patches.  v3 incoming.
