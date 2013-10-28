Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab3J1QFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:05:52 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:5019
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757112Ab3J1QFu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:05:50 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432I14ffIzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Mon, 28 Oct 2013 09:05:37 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Suneel Garapati <suneelg@xilinx.com>,
        Vlad Lungu <vlad.lungu@windriver.com>
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
References: <20131029013317.a33ae4ff86b88ea17bb58e74@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20131029013317.a33ae4ff86b88ea17bb58e74@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <2bf73b4c-8905-4889-bdd1-6bdae2c54bbd@CH1EHSMHS036.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 01:33:17AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/tty/serial/xilinx_uartps.c: In function 'xuartps_clk_notifier_cb':
> drivers/tty/serial/xilinx_uartps.c:436:7: error: 'PRE_RATE_CHANGE' undeclared (first use in this function)
>   case PRE_RATE_CHANGE:
>        ^
> drivers/tty/serial/xilinx_uartps.c:436:7: note: each undeclared identifier is reported only once for each function it appears in
> drivers/tty/serial/xilinx_uartps.c:446:36: error: dereferencing pointer to incomplete type
>    if (!xuartps_calc_baud_divs(ndata->new_rate, xuartps->baud,
>                                     ^
> drivers/tty/serial/xilinx_uartps.c:461:7: error: 'POST_RATE_CHANGE' undeclared (first use in this function)
>   case POST_RATE_CHANGE:
>        ^
> drivers/tty/serial/xilinx_uartps.c:470:24: error: dereferencing pointer to incomplete type
>    port->uartclk = ndata->new_rate;
>                         ^
> drivers/tty/serial/xilinx_uartps.c:475:7: error: 'ABORT_RATE_CHANGE' undeclared (first use in this function)
>   case ABORT_RATE_CHANGE:
>        ^
> drivers/tty/serial/xilinx_uartps.c: In function 'xuartps_probe':
> drivers/tty/serial/xilinx_uartps.c:1385:2: error: implicit declaration of function 'clk_notifier_register' [-Werror=implicit-function-declaration]
>   if (clk_notifier_register(xuartps_data->refclk,
>   ^
> drivers/tty/serial/xilinx_uartps.c:1418:2: error: implicit declaration of function 'clk_notifier_unregister' [-Werror=implicit-function-declaration]
>   clk_notifier_unregister(xuartps_data->refclk,
>   ^
> 
> Caused by commits in the tty tree.
> 
> I have left this broken for today.

I already sent a series to Greg which should fix the x86 build of the
tty tree. I think he didn't apply those patches yet.

	Sören


