Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3LRR0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:26:23 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:11024
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754204Ab3LRR0U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:26:20 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(z551biz98dIc89bh1432I1447Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h906i1155h)
Date: Wed, 18 Dec 2013 09:26:10 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <arm@kernel.org>,
        <linux@arm.linux.org.uk>, <arnd@arndb.de>, <olof@lixom.net>,
        <peter.crosthwaite@xilinx.com>, <linux@roeck-us.net>
Subject: Re: [PATCH v6 0/2] ARM: mach-moxart: add MOXA ART SoC support
References: <1387371526-15309-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1387371526-15309-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <0e3d482f-0b7c-4654-bb75-d6aa3e209fd7@CH1EHSMHS008.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonas,

On Wed, Dec 18, 2013 at 01:58:44PM +0100, Jonas Jensen wrote:
> Thanks for the replies!
> 
> This should tick the boxes on feedback except for one detail
> on the fixed rate clock:
> 
> Moving fixed-clock "ref12" from .dtsi to .dts proved problematic
> for other clocks, this is why ref12 is still in SoC.
> 
> My assertion is that "fixed-clock" clocks are probed later when
> placed in .dts (see diff and boot log below).
> of_clk_get() from clk_pll in .dtsi fails, i.e. fixed-clock ref12
> is not added as a provider in time before clk_pll loads.

I haven't looked into the details, but is of_clk_get_parent_name() an
alternative? That function does purely rely on DT data to obtain a name
of a clock which may enable to register your PLL? Then probing oder
wouldn't matter anymore.

	Sören


