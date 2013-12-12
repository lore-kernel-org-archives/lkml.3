Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab3LLEcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 23:32:16 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:60472 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3LLEcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 23:32:14 -0500
MIME-Version: 1.0
In-Reply-To: <20131210200529.GD3651@lukather>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-2-git-send-email-wens@csie.org> <20131207103335.GL24519@lukather>
 <CAGb2v65YOSq_BMWSzSHX8w_hbo+0vwquBT2pnLuwNVZkWRfLvA@mail.gmail.com> <20131210200529.GD3651@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Thu, 12 Dec 2013 12:31:53 +0800
X-Google-Sender-Auth: Vusdti7lGmiCBIolUn1O8jKndlE
Message-ID: <CAGb2v67TkxcMSrFsMtAy8TaMG_VZWt73xZZcuqkJ71VO4y=7_w@mail.gmail.com>
Subject: Re: [PATCH 01/10] net: stmmac: Enable stmmac main clock when probing hardware
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev <netdev@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 11, 2013 at 4:05 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi,
>
> On Mon, Dec 09, 2013 at 10:43:29AM +0800, Chen-Yu Tsai wrote:
>> >> @@ -2759,15 +2760,18 @@ struct stmmac_priv *stmmac_dvr_probe(struct device *device,
>> >>               }
>> >>       }
>> >>
>> >> +     clk_disable_unprepare(priv->stmmac_clk);
>> >> +
>> >
>> > Hu? Why do you disable the clock? don't you need it afterwards?
>>
>> The clock is enabled in *_open (when the network interface is used),
>> and disabled in *_close.
>
> Maybe it is the real issue then.
>
> Why don't you move the clk_disable to _remove then?

I wasn't sure this was the proper way. However, looking around, it
seems other drivers enable the clock in, _probe, and disable it in
_remove. I will modify stmmac to do so as well.


ChenYu
