Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836AbaJ3NFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:05:13 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:50659 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759685AbaJ3NFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:05:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: Re: I2C OF IRQ parsing issue due to probe ordering
Date: Thu, 30 Oct 2014 15:05:18 +0200
Message-ID: <1441244.9DO8HMds24@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20141030125645.GA19386@ulmo>
References: <2287003.09eTeKUr1V@avalon> <20141027125819.GA12641@katana> <20141030125645.GA19386@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Thursday 30 October 2014 13:56:46 Thierry Reding wrote:
> On Mon, Oct 27, 2014 at 01:58:19PM +0100, Wolfram Sang wrote:
> > > The i2c@e6520000 node is probed before the gpio@e6051000 node. The
> > > of_i2c_register_devices() function tries to register all children,
> > > including hdmi@39. It tries to parse and map the I2C client IRQ by
> > > calling irq_of_parse_and_map(), which returns 0 as the interrupt
> > > controller isn't probed yet. The adv7511 driver later probes the hdmi@39
> > > device and gets client->irq set to 0.
> > 
> > I've got this strange feeling of deja vu... Ah, here: Thierry Reding
> > tackled this problem a year ago. His series:
> > 
> > https://lkml.org/lkml/2013/9/16/111 (of/irq: Defer interrupt reference
> > resolution)
> > 
> > He did a V2 (which never made it to the i2c list). Seems like the first
> > two patches made it and the rest got stalled without discussion?
> > 
> > https://lkml.org/lkml/2013/9/18/216
> > 
> > Adding Thierry to the queue. Maybe he can bring some light to what
> > happened to his series.
> 
> I tried to fix it in a proper way, but it seems people were uneasy with
> how invasive the change was.

It was a bit invasive indeed and I can share the uneasiness, but on the other 
hand there was no real nack. I think I still prefer your approach, but can 
live with something simpler.

> At some point I lost interest. People ended up merging something that was
> similar, but side-stepped the issue of propagating error codes all the way
> up by introducing a new API and in case of of_irq_parse_one() failing doing
> an additional check to see if the reason was the missing IRQ domain.
> 
> See:
> 
> 	9ec36cafe43b of/irq: do irq resolution in platform_get_irq
> 
> I suspect a similar thing could be done for I2C.

That could work. We would need to introduce a new i2c_get_irq() function 
though. Wolfram, would you be fine with that ?

-- 
Regards,

Laurent Pinchart

