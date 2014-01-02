Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaABNRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 08:17:12 -0500
Received: from eu1sys200aog124.obsmtp.com ([207.126.144.157]:50967 "EHLO
	eu1sys200aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbaABNRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 08:17:10 -0500
Message-ID: <52C5656A.4060402@st.com>
Date: Thu, 2 Jan 2014 13:11:06 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>
Cc: linux-sunxi <linux-sunxi@googlegroups.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev <netdev@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-sunxi] Re: [PATCH 04/10] net: stmmac: sunxi platfrom extensions
 for GMAC in Allwinner A20 SoC's
References: <1386350983-13281-1-git-send-email-wens@csie.org> <1386350983-13281-5-git-send-email-wens@csie.org> <52A5A52C.50605@st.com> <CAGb2v67WiCaMpJEzA_X6o7uOu6i3w3FCEz7=N5HY0amQb01SZA@mail.gmail.com> <52A72C6D.60100@st.com> <CAGb2v64qQvqJSicA6MTAxeh1sGjWY=Pk=vDq=9J3pTQW+wkXrA@mail.gmail.com> <52A87A74.8040807@st.com> <20131212090415.GQ3651@lukather> <CAGb2v655_83b76PTmgkDmNGCADWwTjTwW13sOgM5HFmCVkeu=w@mail.gmail.com> <20131213103822.GX3651@lukather> <CAGb2v64Q1PSMw_nULBHMR5eOC44hWBPewchxE_4sO+4XN8_sDA@mail.gmail.com>
In-Reply-To: <CAGb2v64Q1PSMw_nULBHMR5eOC44hWBPewchxE_4sO+4XN8_sDA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

On 24/12/13 03:27, Chen-Yu Tsai wrote:
> Srinivas,
> 
> Let's keep platform data as of_data, so SoC compatibles can pass
> hardware feature flags for cores that don't support auto-detection.

I understand your concern here, But making platform_data as of_data
would just open a wide door for other hacky stuff too. So other glue
drivers would just use this interface instead, ignoring standard
interfaces. Also there would be issues on who takes the priority if the
parameters are specified in multiple places.


Can't this field/s be one of the variable in the struct stmmac_of_data
rather than reusing platform data?

> 
> We can adjust the callbacks as you suggested, and I added a .free
> to complement .setup. Driver private data and platform data are
> off limits to the callbacks. My version of the callbacks:
> 
>         void (*fix_mac_speed)(void *priv, unsigned int speed);
>         void (*bus_setup)(void __iomem *ioaddr);

In reply to your question in last email:
bus_setup this is something very specific to ST which configures the bus
parameters of AMBA-to-STBUS converter. This register falls inside the
memory map of stmmac.

>         void *(*setup)(struct platform_device *pdev);
>         void (*free)(struct platform_device *pdev, void *priv);
>         int (*init)(struct platform_device *pdev, void *priv);
>         void (*exit)(struct platform_device *pdev, void *priv);
> 

The callbacks to Ok to me, unless Peppe has more comments on this.

Thanks,
srini


> 
> Cheers,
> 
> ChenYu

