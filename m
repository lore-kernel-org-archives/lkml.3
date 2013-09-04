Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768Ab3IDUmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:42:25 -0400
Received: from mail-db9lp0248.outbound.messaging.microsoft.com ([213.199.154.248]:48113
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754517Ab3IDUmX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:42:23 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(z551biz98dIc89bh1418Idb82hzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097h186068h8275bhz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Wed, 4 Sep 2013 13:41:52 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH RFC v2 01/16] ARM: call clk_of_init from time_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <3837b119-baad-4e68-8805-2bc52c0135f9@DB9EHSMHS031.ehs.local>
 <521D2F1F.1070103@gmail.com>
 <201308291545.37520.arnd@arndb.de>
 <52278AC8.5080103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <52278AC8.5080103@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <6ba67c93-e0d0-42d4-b0a5-55c06938a15e@DB9EHSMHS013.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

+Michal

On Wed, Sep 04, 2013 at 09:32:24PM +0200, Sebastian Hesselbarth wrote:

[ ... ]

> For mach-zynq I prepared a patch set that brings it close to .init_time
> removal. I have pushed it to
>   https://github.com/shesselba/linux-dove.git zynq-clk-init-v1
> and will maybe post a patch set after this one is done.

I think Steffen had a similar approach and we turned it down:
Your proposal lets the clkc map the SLCR's registers. I think
that approach is not right. It might be okay now, since the
SLCR driver is pretty much a useless skeleton. But in general,
there is a driver for the SLCR which maps that register
region. No other driver should mess with it.

Actually, one early version of my clkc looked pretty much like what you
propose now and we changed it because of above reason.

	Sören


