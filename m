Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaFPL2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:28:47 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:35309 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754144AbaFPL2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:28:45 -0400
Message-ID: <539ED4C5.4070906@st.com>
Date: Mon, 16 Jun 2014 13:28:05 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <patrice.chotard@st.com>, <srinivas.kandagatla@gmail.com>
Cc: <lee.jones@linaro.org>, <gabriel.fernandez@st.com>,
        <daniel.thompson@linaro.org>
Subject: Re: [PATCH V2] ARM: STi: DT: Properly define sti-ethclk & stmmaceth
 for stih415/6
References: <1402345355-5682-1-git-send-email-peter.griffin@linaro.org> <20140616092339.GB27978@griffinp-ThinkPad-X1-Carbon-2nd>
In-Reply-To: <20140616092339.GB27978@griffinp-ThinkPad-X1-Carbon-2nd>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-16_02:2014-06-16,2014-06-15,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 06/16/2014 11:23 AM, Peter Griffin wrote:
> This patch fixes two problems: -
>
> 1) The device tree isn't currently providing sti-ethclk which is
> required by the dwmac glue code to correctly configure the ethernet
> PHY clock speed.
>
> This means depending on what the bootloader/jtag has
> configured this clock to, and what switch/hub the board is plugged
> into you most likely will NOT successfully negotiate a ethernet link.
>
> 2) The stmmaceth clock was associated with the wrong clock. It was
> referencing the PHY clock rather than the interconnect clock which
> clocks the IP.
>
> This patch also brings us closer to not having to boot the upstream
> kernel with the clk_ignore_unused parameter.
>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>   arch/arm/boot/dts/stih415.dtsi           | 8 ++++----
>   arch/arm/boot/dts/stih416.dtsi           | 8 ++++----
>   include/dt-bindings/clock/stih415-clks.h | 1 +
>   include/dt-bindings/clock/stih416-clks.h | 1 +
>   4 files changed, 10 insertions(+), 8 deletions(-)
>

...

Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Thanks for the fix!

Maxime
