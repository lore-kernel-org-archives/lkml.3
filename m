Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab3LLKc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 05:32:29 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:61070 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab3LLKcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 05:32:04 -0500
MIME-Version: 1.0
In-Reply-To: <20131212090415.GQ3651@lukather>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-5-git-send-email-wens@csie.org> <52A5A52C.50605@st.com>
 <CAGb2v67WiCaMpJEzA_X6o7uOu6i3w3FCEz7=N5HY0amQb01SZA@mail.gmail.com>
 <52A72C6D.60100@st.com> <CAGb2v64qQvqJSicA6MTAxeh1sGjWY=Pk=vDq=9J3pTQW+wkXrA@mail.gmail.com>
 <52A87A74.8040807@st.com> <20131212090415.GQ3651@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Thu, 12 Dec 2013 18:31:43 +0800
X-Google-Sender-Auth: NGv3MFNmTUkb8R5cEYrx1a-OYRk
Message-ID: <CAGb2v655_83b76PTmgkDmNGCADWwTjTwW13sOgM5HFmCVkeu=w@mail.gmail.com>
Subject: Re: [PATCH 04/10] net: stmmac: sunxi platfrom extensions for GMAC in
 Allwinner A20 SoC's
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev <netdev@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 12, 2013 at 5:04 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi,
>
> On Wed, Dec 11, 2013 at 02:45:08PM +0000, srinivas kandagatla wrote:
>> >>> 1. .tx_coe
>> >>>    This is not exported in the DT bindings.
>> >>>    Looking at stmmac code, not setting this seems to disable all
>> >>>    checksum offloading.
>> >>
>> >> Why cant this go via DT as well?
>> >
>> > If you and Giuseppe are OK with this, why not?
>> Am Ok with it.
>
> Please note that I'm opposed to this until someone explain why putting
> it in the DT is relevant (and not just convenient).

Checksum offloading is an optional feature[1], implemented starting
from version 3.20a. It is not tied to a specific IP version. As such,
using a "snps,dwmac-<version>" compatible isn't a good fit here.

stmmac does auto-detection for optional features on MAC version > 3.50a.
This is what Srinivas was referring to.

Unfortunately, our MAC is < 3.50a. No auto-detection. We could add a
"snps,dwmac-tx-coe" compatible for this, or the seperate DT property.

The other way would be to pass the flags in the initial .data with the
SoC specific compatible. Other SoCs with the same feature won't be
able to reuse the same compatible though.


ChenYu

[1] http://www.synopsys.com/dw/dwtb.php?a=ethernet_mac
