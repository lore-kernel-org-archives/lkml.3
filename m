Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbaFYXNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 19:13:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36206 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbaFYXNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 19:13:16 -0400
Message-ID: <53AB5786.8090904@wwwdotorg.org>
Date: Wed, 25 Jun 2014 17:13:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
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
Subject: Re: [PATCH v1 5/9] of: Add NVIDIA Tegra XHCI controller binding
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>	<1403072180-4944-6-git-send-email-abrestic@chromium.org>	<53AB4495.1020000@wwwdotorg.org> <CAL1qeaG=nLxDHrsVuuL9c-JdKB+TrNN785+8v=hb0MAFJ=5juw@mail.gmail.com>
In-Reply-To: <CAL1qeaG=nLxDHrsVuuL9c-JdKB+TrNN785+8v=hb0MAFJ=5juw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 05:01 PM, Andrew Bresticker wrote:
> On Wed, Jun 25, 2014 at 2:52 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 06/18/2014 12:16 AM, Andrew Bresticker wrote:
>>> Add device-tree binding documentation for the XHCI controller present
>>> on Tegra124 and later SoCs.
>>
>>> diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt
>>
>>> +Required properties:
>>> +--------------------
>>
>>> + - clock-names: Must include the following entries:
>>> +    - xusb_host
>>> +    - xusb_falcon_src
>>> +    - xusb_ss
>>> +    - xusb_ss_src
>>> +    - xusb_hs_src
>>> +    - xusb_fs_src
>>> +    - pll_u_480m
>>> +    - clk_m
>>> +    - pll_e
>>
>>> + - reset-names: Must include the following entries:
>>> +   - xusb_host
>>> +   - xusb_ss
>>
>> Usually the CAR has a reset control for each clock. So, I would expect
>> as many entries in reset-names as in clock-names. Even if the SW doesn't
>> currently touch all the reset lines, we should make sure the binding
>> requires them to be present so that any DT will contain the entries if
>> they're ever needed in the future.
> 
> The xusb_{falcon,host,hs,fs,ss}_src clocks all share the same reset
> bit (143), so I can add a single entry for those.
> 
>> In the CAR documentation, I see "XUSB_DEV" as a clock/reset bit. Is that
>> missing from the list above?
> 
> This is used when XUSB is in device mode, which the driver does not
> support.  I can add those clocks here though if you want.

That'd be a good idea. That way, the DT doesn't have to change later.

>>> +Optional properties:
>>
>>> + - s1p05v-supply: 1.05V supply regulator.
>>> + - s1p8v-supply: 1.8V supply regulator.
>>> + - s3p3v-supply: 3.3V supply regulator.
>>
>> What are those supplies for? I would have expected any input to the SoC
>> to have a name that described its purpose, and the pins and DT
>> properties would be named to match.
> 
> I *think* this what they are from looking at the schematic, but I'll
> have to ask around:
>  - s1p05v: avddio_pex, dvddio_pex, and maybe avdd_pll_erefe
>  - s1p8v: avdd_pll_utmip
>  - s3p3v: avdd_usb, hvdd_pex, hvdd_pex_pll_e
> Should these be separated out as they are for PCIe?

Yes, I think they should be separated. I wonder if the supplies for PCIe
shouldn't have been added to the XUSB padctrl rather than PCIe node
though? It probably doesn't matter much either way.
