Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaAGKZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:25:21 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:58216 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaAGKZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:25:17 -0500
MIME-Version: 1.0
In-Reply-To: <52C5656A.4060402@st.com>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-5-git-send-email-wens@csie.org> <52A5A52C.50605@st.com>
 <CAGb2v67WiCaMpJEzA_X6o7uOu6i3w3FCEz7=N5HY0amQb01SZA@mail.gmail.com>
 <52A72C6D.60100@st.com> <CAGb2v64qQvqJSicA6MTAxeh1sGjWY=Pk=vDq=9J3pTQW+wkXrA@mail.gmail.com>
 <52A87A74.8040807@st.com> <20131212090415.GQ3651@lukather>
 <CAGb2v655_83b76PTmgkDmNGCADWwTjTwW13sOgM5HFmCVkeu=w@mail.gmail.com>
 <20131213103822.GX3651@lukather> <CAGb2v64Q1PSMw_nULBHMR5eOC44hWBPewchxE_4sO+4XN8_sDA@mail.gmail.com>
 <52C5656A.4060402@st.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 7 Jan 2014 18:24:55 +0800
X-Google-Sender-Auth: Zdsl8DfxX9U-vZEFaWADegEq7TU
Message-ID: <CAGb2v67iSZOivEokrye7haQss06MvUaPCNGF=E+odasgzhoWFg@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH 04/10] net: stmmac: sunxi platfrom
 extensions for GMAC in Allwinner A20 SoC's
To: srinivas kandagatla <srinivas.kandagatla@st.com>
Cc: linux-sunxi <linux-sunxi@googlegroups.com>,
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

On Thu, Jan 2, 2014 at 9:11 PM, srinivas kandagatla
<srinivas.kandagatla@st.com> wrote:
> Hi Chen,
>
> On 24/12/13 03:27, Chen-Yu Tsai wrote:
>> Srinivas,
>>
>> Let's keep platform data as of_data, so SoC compatibles can pass
>> hardware feature flags for cores that don't support auto-detection.
>
> I understand your concern here, But making platform_data as of_data
> would just open a wide door for other hacky stuff too. So other glue
> drivers would just use this interface instead, ignoring standard
> interfaces. Also there would be issues on who takes the priority if the
> parameters are specified in multiple places.
>
>
> Can't this field/s be one of the variable in the struct stmmac_of_data
> rather than reusing platform data?

We (sunxi) need .has_gmac and .tx_coe.

To be generic and usable to other SoCs, it seems like I would be
adding most of the fields from platform data. But maybe future
glue layers will only need the callbacks. I can not be sure.

Also since snps,phy-addr should be deprecated, I am thinking of
changing the default phy address to auto-detect, until
Giuseppe merges his phy node support work.

I will post a v2 series this week.

>>
>> We can adjust the callbacks as you suggested, and I added a .free
>> to complement .setup. Driver private data and platform data are
>> off limits to the callbacks. My version of the callbacks:
>>
>>         void (*fix_mac_speed)(void *priv, unsigned int speed);
>>         void (*bus_setup)(void __iomem *ioaddr);
>
> In reply to your question in last email:
> bus_setup this is something very specific to ST which configures the bus
> parameters of AMBA-to-STBUS converter. This register falls inside the
> memory map of stmmac.

I see. IMHO it could be merged into .init?

>
>>         void *(*setup)(struct platform_device *pdev);
>>         void (*free)(struct platform_device *pdev, void *priv);
>>         int (*init)(struct platform_device *pdev, void *priv);
>>         void (*exit)(struct platform_device *pdev, void *priv);
>>
>
> The callbacks to Ok to me, unless Peppe has more comments on this.

Ok.


Cheers
ChenYu
