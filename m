Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3HZPQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:16:46 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:59679 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756836Ab3HZPQn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:16:43 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 8
X-BigFish: VPS8(zzbb2dI98dIc89bh1432I1591rzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h906i1155h192ch)
Date: Mon, 26 Aug 2013 08:16:29 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Michal Simek <monstr@monstr.eu>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Michal Simek <michal.simek@xilinx.com>,
        <linux-kernel@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 17/17] clk: zynq: remove call to of_clk_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376964271-22715-18-git-send-email-sebastian.hesselbarth@gmail.com>
 <d17acba9-85f9-40cd-a176-2005e3e924f8@CO1EHSMHS002.ehs.local>
 <c4d10bdf-6506-4edc-92cc-2acc67b86602@VA3EHSMHS032.ehs.local>
 <20130823073250.GB30135@pengutronix.de>
 <521B38BF.6040400@monstr.eu>
 <20130826120716.GB24795@pengutronix.de>
 <521B4FCF.5000904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <521B4FCF.5000904@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <c46b466a-1f8a-4b22-9dad-9d2419100b06@TX2EHSMHS043.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 02:53:35PM +0200, Sebastian Hesselbarth wrote:
> On 08/26/13 14:07, Steffen Trumtrar wrote:
> >On Mon, Aug 26, 2013 at 01:15:11PM +0200, Michal Simek wrote:
> >>I agree with Soren - let's fix the current problem and then when Steffen has patches with syscon
> >>we can look at them.
> >>
> >>If there is any discussion about early syscon registration please let me know.
> >>
> >
> >Where I'm stuck at the moment is: if I map the whole register space to the
> >parent node, how do I get its mapped address in the clkc?
> 
> Steffen,
> 
> if slcr is such an essential part of the SoC, you can choose to provide
> zynq_slcr_readl/writel callbacks. You can then use those callback in the
> clock driver without knowing the base address. Also, it allows you to
> hide slcr specific locking details from subsequent drivers using the
> callbacks.

I don't think that'll work. The clkc just wraps the cock primitives and
does not provide a lot of own clock drivers - actually only one. Those
clock primitives receive an iomapped address for the clock control which
is then accessed using readl/writel(). So, wrapping all SLCR accesses in
special accessors would mean to have almost identical reimplementations
of all used clock primitives, just to replace readl/writel with
zynq_slcr_write/read. Or is there some way to make this actually work?


Sören


