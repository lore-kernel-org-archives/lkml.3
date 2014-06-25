Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbaFYXB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 19:01:29 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:65457 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990AbaFYXB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 19:01:26 -0400
MIME-Version: 1.0
In-Reply-To: <53AB4495.1020000@wwwdotorg.org>
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
	<1403072180-4944-6-git-send-email-abrestic@chromium.org>
	<53AB4495.1020000@wwwdotorg.org>
Date: Wed, 25 Jun 2014 16:01:25 -0700
X-Google-Sender-Auth: bIo1VNFhBdUHOl3o7h-GKP4PQyE
Message-ID: <CAL1qeaG=nLxDHrsVuuL9c-JdKB+TrNN785+8v=hb0MAFJ=5juw@mail.gmail.com>
Subject: Re: [PATCH v1 5/9] of: Add NVIDIA Tegra XHCI controller binding
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-usb@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 2:52 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/18/2014 12:16 AM, Andrew Bresticker wrote:
>> Add device-tree binding documentation for the XHCI controller present
>> on Tegra124 and later SoCs.
>
>> diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt
>
>> +Required properties:
>> +--------------------
>
>> + - clock-names: Must include the following entries:
>> +    - xusb_host
>> +    - xusb_falcon_src
>> +    - xusb_ss
>> +    - xusb_ss_src
>> +    - xusb_hs_src
>> +    - xusb_fs_src
>> +    - pll_u_480m
>> +    - clk_m
>> +    - pll_e
>
>> + - reset-names: Must include the following entries:
>> +   - xusb_host
>> +   - xusb_ss
>
> Usually the CAR has a reset control for each clock. So, I would expect
> as many entries in reset-names as in clock-names. Even if the SW doesn't
> currently touch all the reset lines, we should make sure the binding
> requires them to be present so that any DT will contain the entries if
> they're ever needed in the future.

The xusb_{falcon,host,hs,fs,ss}_src clocks all share the same reset
bit (143), so I can add a single entry for those.

> In the CAR documentation, I see "XUSB_DEV" as a clock/reset bit. Is that
> missing from the list above?

This is used when XUSB is in device mode, which the driver does not
support.  I can add those clocks here though if you want.

>> +Optional properties:
>
>> + - s1p05v-supply: 1.05V supply regulator.
>> + - s1p8v-supply: 1.8V supply regulator.
>> + - s3p3v-supply: 3.3V supply regulator.
>
> What are those supplies for? I would have expected any input to the SoC
> to have a name that described its purpose, and the pins and DT
> properties would be named to match.

I *think* this what they are from looking at the schematic, but I'll
have to ask around:
 - s1p05v: avddio_pex, dvddio_pex, and maybe avdd_pll_erefe
 - s1p8v: avdd_pll_utmip
 - s3p3v: avdd_usb, hvdd_pex, hvdd_pex_pll_e
Should these be separated out as they are for PCIe?
