Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab3CYSNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:13:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52969 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab3CYSNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:13:12 -0400
Message-ID: <515093B4.2090701@wwwdotorg.org>
Date: Mon, 25 Mar 2013 12:13:08 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, git@xilinx.com,
        =?UTF-8?B?SmFuIEzDvA==?= =?UTF-8?B?YmJl?= <jlu@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: RFC v2: Zynq Clock Controller
References: <27dae808-1d3a-4001-8eb2-b0a6e2a34b8f@AM1EHSMHS013.ehs.local>
In-Reply-To: <27dae808-1d3a-4001-8eb2-b0a6e2a34b8f@AM1EHSMHS013.ehs.local>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 05:56 PM, Sören Brinkmann wrote:
> Hi,
> 
> I spent some time working on this and incorporating feedback. Here's an updated proposal for a clock controller for Zynq:
> 
> Required properties:
>  - #clock-cells : Must be 1
>  - compatible : "xlnx,ps7-clkc"  (this may become 'xlnx,zynq-clkc' terminology differs a bit between Xilinx internal and mainline)
>  - ps-clk-frequency : Frequency of the oscillator providing ps_clk in HZ
>                      (usually 33 MHz oscillators are used for Zynq platforms)

This may have been mentioned before, but shouldn't the input clock be
represented as an actual clock in DT, and hence as an entry in this
node's clocks property? The crystal/... itself can be represented in DT
as a fixed-clock.

>  - clock-output-names : List of strings used to name the clock outputs. Shall be a list of the outputs given below.

That shouldn't be required.

> Optional properties:
>  - clocks : as described in the clock bindings
>  - clock-names : as described in the clock bindings

I think clocks should be required, with at least the main crystal clock
input always present, but perhaps having some optional entries for the
(E)MIO feature you mention.

> Example:
>         clkc: clkc {
>                 #clock-cells = <1>;
>                 compatible = "xlnx,ps7-clkc";
>                 ps-clk-frequency = <33333333>;
>                 clock-output-names = "armpll", "ddrpll", "iopll", "cpu_6or4x", "cpu_3or2x", "cpu_2x", "cpu_1x", "ddr2x", "ddr3x", "dci", "lqspi", "smc", "pcap", "gem0", "gem1", "fclk0", "fclk1", "fclk2", "fclk3", "can0", "can1", "sdio0", "sdio1", "uart0", "uart1", "spi0", "spi1", "dma", "usb0_aper", "usb1_aper", "gem0_aper", "gem1_aper", "sdio0_aper", "sdio1_aper", "spi0_aper", "spi1_aper", "can0_aper", "can1_aper", "i2c0_aper", "i2c1_aper", "uart0_aper", "uart1_aper", "gpio_aper", "lqspi_aper", "smc_aper", "swdt", "dbg_trc", "dbg_apb";  /* long list... explanation below */
>                 /* optional props */
>                 clocks = <&clkc 16>, <&clk_foo>;
>                 clock-names = "gem1_emio_clk", "can_mio_clk_23";
>         };
> 
> The downside of supporting this is, that I don't see a way around explicitly listing the clock output names in the DT.

(Please wrap your emails to ~74 characters or so)

As Mike mentioned off-list, one can create a new clk registration API
that takes a struct clk* as parent rather than a char *clk_name.

> This email and any attachments are intended for the sole use of the named recipient(s)...

It's not good form to include that kind of disclaimer on public mailing
list posts. That's why many people use their personal email when posting
to mailing lists.
