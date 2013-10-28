Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab3J1Qdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:33:37 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42745 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756609Ab3J1Qdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:33:35 -0400
X-Sasl-enc: MZxpLGPK+Ng4LvncPPWT56JzfNo4JT2tTSoRCoo5dL7f 1382978014
Date: Mon, 28 Oct 2013 09:33:33 -0700
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Suneel Garapati <suneelg@xilinx.com>,
        Vlad Lungu <vlad.lungu@windriver.com>
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
Message-ID: <20131028163333.GA4797@kroah.com>
References: <20131029013317.a33ae4ff86b88ea17bb58e74@canb.auug.org.au>
 <2bf73b4c-8905-4889-bdd1-6bdae2c54bbd@CH1EHSMHS036.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2bf73b4c-8905-4889-bdd1-6bdae2c54bbd@CH1EHSMHS036.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 09:05:37AM -0700, Sören Brinkmann wrote:
> On Tue, Oct 29, 2013 at 01:33:17AM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> > 
> > drivers/tty/serial/xilinx_uartps.c: In function 'xuartps_clk_notifier_cb':
> > drivers/tty/serial/xilinx_uartps.c:436:7: error: 'PRE_RATE_CHANGE' undeclared (first use in this function)
> >   case PRE_RATE_CHANGE:
> >        ^
> > drivers/tty/serial/xilinx_uartps.c:436:7: note: each undeclared identifier is reported only once for each function it appears in
> > drivers/tty/serial/xilinx_uartps.c:446:36: error: dereferencing pointer to incomplete type
> >    if (!xuartps_calc_baud_divs(ndata->new_rate, xuartps->baud,
> >                                     ^
> > drivers/tty/serial/xilinx_uartps.c:461:7: error: 'POST_RATE_CHANGE' undeclared (first use in this function)
> >   case POST_RATE_CHANGE:
> >        ^
> > drivers/tty/serial/xilinx_uartps.c:470:24: error: dereferencing pointer to incomplete type
> >    port->uartclk = ndata->new_rate;
> >                         ^
> > drivers/tty/serial/xilinx_uartps.c:475:7: error: 'ABORT_RATE_CHANGE' undeclared (first use in this function)
> >   case ABORT_RATE_CHANGE:
> >        ^
> > drivers/tty/serial/xilinx_uartps.c: In function 'xuartps_probe':
> > drivers/tty/serial/xilinx_uartps.c:1385:2: error: implicit declaration of function 'clk_notifier_register' [-Werror=implicit-function-declaration]
> >   if (clk_notifier_register(xuartps_data->refclk,
> >   ^
> > drivers/tty/serial/xilinx_uartps.c:1418:2: error: implicit declaration of function 'clk_notifier_unregister' [-Werror=implicit-function-declaration]
> >   clk_notifier_unregister(xuartps_data->refclk,
> >   ^
> > 
> > Caused by commits in the tty tree.
> > 
> > I have left this broken for today.
> 
> I already sent a series to Greg which should fix the x86 build of the
> tty tree. I think he didn't apply those patches yet.

Yes, I have them, sorry, been traveling, will get to them later today...

thanks,

greg k-h
