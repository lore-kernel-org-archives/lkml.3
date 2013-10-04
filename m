Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3JDOJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:09:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47328 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754114Ab3JDOJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:09:16 -0400
Date: Fri, 4 Oct 2013 11:09:26 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Daniel Mack <zonque@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/2] input: rotary-encoder: Add 'on-each-step' to
 binding documentation
Message-ID: <20131004140925.GA27809@localhost>
References: <1380891203-17617-1-git-send-email-ezequiel@vanguardiasur.com.ar>
 <1380891203-17617-3-git-send-email-ezequiel@vanguardiasur.com.ar>
 <20131004131956.GE6999@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131004131956.GE6999@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 02:19:56PM +0100, Mark Rutland wrote:
> On Fri, Oct 04, 2013 at 01:53:23PM +0100, Ezequiel Garcia wrote:
> > The driver now supports a new mode to handle the interruptions generated
> > by the device: on this new mode an input event is generated on each step
> > (i.e. on each IRQ). Therefore, add a new DT property, to select the
> > mode: 'rotary-encoder,on-each-step'.
> > 
> > Cc: Daniel Mack <zonque@gmail.com>
> > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Cc: devicetree@vger.kernel.org
> > Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> > ---
> > I'm not at all happy with this DT binding as it's way to customized
> > for the current driver. For instance, if we want to support mapping
> > key events (or better arbitrary linux-input event types) it seems
> > there's no easy way to fix the binding.
> > 
> > Maybe a better way of handling the different 'modes' is through
> > compatible strings?
> 
> I'd prefer not to have more pseudo-devices in DT, and would prefer not
> to have compatible strings that boil down to driver options. We end up
> just embedding a tonne of Linux-specific driver configuration in the DT
> rather than describing hardware.
> 
> That said, I'm not sure what the best solution is here.
> 
> > 
> > I'm not really sure, so I hope the DT guys have some comment on this.
> > 
> >  Documentation/devicetree/bindings/input/rotary-encoder.txt | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/input/rotary-encoder.txt b/Documentation/devicetree/bindings/input/rotary-encoder.txt
> > index 3315495..b89e38d 100644
> > --- a/Documentation/devicetree/bindings/input/rotary-encoder.txt
> > +++ b/Documentation/devicetree/bindings/input/rotary-encoder.txt
> > @@ -15,6 +15,7 @@ Optional properties:
> >  - rotary-encoder,rollover: Automatic rollove when the rotary value becomes
> >    greater than the specified steps or smaller than 0. For absolute axis only.
> >  - rotary-encoder,half-period: Makes the driver work on half-period mode.
> > +- rotary-encoder,on-each-step: Makes the driver send an event on each step.
> 
> Could this not be something requested at runtime?
> 

Sure. The different modes:

* default (no option)
* rotary-encoder,half-period
* rotary-encoder,on-each-step

Just map to different interruption handlers. I don't have any other
rotary-encoder device, so I'm not at all sure what's the use of the
other two cases.
My particular device is detented, and produces a 'stable' event on each
step (i.e on each IRQ).

Regarding the runtime specification: you mean as a module parameter?
That should be trivial to add, no?

> Could you explain what you want to achieve with this? -- what events do
> you want to occur when, to be handled in what way?
> 

Hm.. maybe I should have added the binding to the 1/2 patch and CCed
everybody involved for better context.

Anyway, I hope the above is clearer, I'm not really sure how to specify
the details in the DT binding, since it's a specific interruption handler
for this class of encoder devices (stable on each step).

That said, I really hope I'm crafting a generic solution and not some
tailor-made implementation that just happens to match my use case.

The input maintainer's opinion on this would be valuable.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
