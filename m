Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371Ab3LXD2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 22:28:10 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:39364 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072Ab3LXD2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 22:28:07 -0500
MIME-Version: 1.0
In-Reply-To: <20131213103822.GX3651@lukather>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-5-git-send-email-wens@csie.org> <52A5A52C.50605@st.com>
 <CAGb2v67WiCaMpJEzA_X6o7uOu6i3w3FCEz7=N5HY0amQb01SZA@mail.gmail.com>
 <52A72C6D.60100@st.com> <CAGb2v64qQvqJSicA6MTAxeh1sGjWY=Pk=vDq=9J3pTQW+wkXrA@mail.gmail.com>
 <52A87A74.8040807@st.com> <20131212090415.GQ3651@lukather>
 <CAGb2v655_83b76PTmgkDmNGCADWwTjTwW13sOgM5HFmCVkeu=w@mail.gmail.com> <20131213103822.GX3651@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 24 Dec 2013 11:27:45 +0800
X-Google-Sender-Auth: en5cSmlT7crCracueIMh8V06TDw
Message-ID: <CAGb2v64Q1PSMw_nULBHMR5eOC44hWBPewchxE_4sO+4XN8_sDA@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH 04/10] net: stmmac: sunxi platfrom
 extensions for GMAC in Allwinner A20 SoC's
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev <netdev@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 13, 2013 at 6:38 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Thu, Dec 12, 2013 at 06:31:43PM +0800, Chen-Yu Tsai wrote:
>> Hi,
>>
>> On Thu, Dec 12, 2013 at 5:04 PM, Maxime Ripard
>> <maxime.ripard@free-electrons.com> wrote:
>> > Hi,
>> >
>> > On Wed, Dec 11, 2013 at 02:45:08PM +0000, srinivas kandagatla wrote:
>> >> >>> 1. .tx_coe
>> >> >>>    This is not exported in the DT bindings.
>> >> >>>    Looking at stmmac code, not setting this seems to disable all
>> >> >>>    checksum offloading.
>> >> >>
>> >> >> Why cant this go via DT as well?
>> >> >
>> >> > If you and Giuseppe are OK with this, why not?
>> >> Am Ok with it.
>> >
>> > Please note that I'm opposed to this until someone explain why putting
>> > it in the DT is relevant (and not just convenient).
>>
>> Checksum offloading is an optional feature[1], implemented starting
>> from version 3.20a. It is not tied to a specific IP version. As such,
>> using a "snps,dwmac-<version>" compatible isn't a good fit here.
>
> No, but we're not in such case. Since we have a compatible of our own,
> we can derive it from that. Putting a property in the DT would only be
> redundant.
>
>> stmmac does auto-detection for optional features on MAC version > 3.50a.
>> This is what Srinivas was referring to.
>>
>> Unfortunately, our MAC is < 3.50a. No auto-detection. We could add a
>> "snps,dwmac-tx-coe" compatible for this, or the seperate DT property.
>>
>> The other way would be to pass the flags in the initial .data with the
>> SoC specific compatible. Other SoCs with the same feature won't be
>> able to reuse the same compatible though.
>
> Which is already pretty much the case, since we have to deal with
> Allwinner specific code and features.
>
> A new compatible is cheap to maintain, a new property is not.

Srinivas,

Let's keep platform data as of_data, so SoC compatibles can pass
hardware feature flags for cores that don't support auto-detection.

We can adjust the callbacks as you suggested, and I added a .free
to complement .setup. Driver private data and platform data are
off limits to the callbacks. My version of the callbacks:

        void (*fix_mac_speed)(void *priv, unsigned int speed);
        void (*bus_setup)(void __iomem *ioaddr);
        void *(*setup)(struct platform_device *pdev);
        void (*free)(struct platform_device *pdev, void *priv);
        int (*init)(struct platform_device *pdev, void *priv);
        void (*exit)(struct platform_device *pdev, void *priv);


Cheers,

ChenYu
