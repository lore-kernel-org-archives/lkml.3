Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbaJ3NMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:12:36 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:50669 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759755AbaJ3NMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:12:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: Re: I2C OF IRQ parsing issue due to probe ordering
Date: Thu, 30 Oct 2014 15:12:43 +0200
Message-ID: <2475312.fxdzhGkprr@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20141030130207.GB19386@ulmo>
References: <2287003.09eTeKUr1V@avalon> <1718941.Qj8UzhsRTh@avalon> <20141030130207.GB19386@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Thursday 30 October 2014 14:02:09 Thierry Reding wrote:
> On Thu, Oct 30, 2014 at 02:53:42PM +0200, Laurent Pinchart wrote:
> > On Monday 27 October 2014 13:58:19 Wolfram Sang wrote:
> > > > The i2c@e6520000 node is probed before the gpio@e6051000 node. The
> > > > of_i2c_register_devices() function tries to register all children,
> > > > including hdmi@39. It tries to parse and map the I2C client IRQ by
> > > > calling irq_of_parse_and_map(), which returns 0 as the interrupt
> > > > controller isn't probed yet. The adv7511 driver later probes the
> > > > hdmi@39
> > > > device and gets client->irq set to 0.
> > > 
> > > I've got this strange feeling of deja vu... Ah, here: Thierry Reding
> > 
> > > tackled this problem a year ago. His series:
> > Thanks for the pointer.
> > 
> > > https://lkml.org/lkml/2013/9/16/111 (of/irq: Defer interrupt reference
> > > resolution)
> > > 
> > > He did a V2 (which never made it to the i2c list). Seems like the first
> > > two patches made it and the rest got stalled without discussion?
> > > 
> > > https://lkml.org/lkml/2013/9/18/216
> > > 
> > > Adding Thierry to the queue. Maybe he can bring some light to what
> > > happened to his series.
> > 
> > That's exactly what I need :-) Thierry, do you plan to respin the series ?
> 
> Not really. Like I said in my reply to Wolfram, a different set of
> patches was merged subsequently to solve this issue for platform
> devices, which makes my patchset mostly obsolete. But I think the
> solution that you proposed would work well if you do:
> 
> -		int irq = irq_of_parse_and_map(dev->of_node, 0);
> +		int irq = of_irq_get(dev->of_node, 0);
> 
> And then changing irq_create_of_mapping() should no longer be necessary.

It looks like it would work, yes. I'll test it and will resubmit my patch.

> I still think it's kind of lame to handle -EPROBE_DEFER specially as was
> done in of_irq_get(), but given how worried people were about the more
> invasive changes needed to propagate the correct error code all the way
> up it seems like that's as good as it's going to get.

-- 
Regards,

Laurent Pinchart

