Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaLSNv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 08:51:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35958 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbaLSNvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 08:51:25 -0500
Date: Fri, 19 Dec 2014 13:51:23 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-usb@vger.kernel.org, ronald.wahl@raritan.com,
        stable@vger.kernel.org, Kamal Mostafa <kamal@canonical.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RESEND PATCH] usb: gadget: at91_udc: move prepare clk into
 process context
Message-ID: <20141219135123.GA2620@charon>
References: <1416411447-31112-1-git-send-email-nicolas.ferre@atmel.com>
 <20141120195049.GF23217@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141120195049.GF23217@saruman>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Thu, Nov 20, 2014 at 01:50:49PM -0600, Felipe Balbi wrote:
> On Wed, Nov 19, 2014 at 04:37:27PM +0100, Nicolas Ferre wrote:
> > From: Ronald Wahl <ronald.wahl@raritan.com>
> > 
> > Commit 7628083227b6bc4a7e33d7c381d7a4e558424b6b (usb: gadget: at91_udc:
> > prepare clk before calling enable) added clock preparation in interrupt
> > context. This is not allowed as it might sleep. Also setting the clock
> > rate is unsafe to call from there for the same reason. Move clock
> > preparation and setting clock rate into process context (at91udc_probe).
> > 
> > Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
> > Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: <stable@vger.kernel.org> # v3.17+
> > ---
> > Hi Felipe,
> > 
> > I forgot to answer you on this patch. So I resend it now with the proper
> > "stable" tag. You can also queue it during this -rc phase if you feel it is
> > still possible.
> 
> I think it's late for v3.18, so it'll go on v3.19 and get backported to
> 3.17 and 3.18. Sorry :-s
>

Although this commit (b2ba27a5c56f "usb: gadget: at91_udc: move
prepare clk into process context") is tagged for stable v3.17+, it
seems like it could be applied to earlier kernels.

3.16, 3.13 and 3.12 seem to be affected by the same issue (and they
all include commit 7628083227b6 "usb: gadget: at91_udc: prepare clk
before calling enable").  Is there any reason for not applying it in
these trees?

Cheers,
--
Luís

> cheers
> 
> -- 
> balbi


