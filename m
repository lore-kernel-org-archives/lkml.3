Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaHOM4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 08:56:44 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:37450 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaHOM4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 08:56:42 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of/irq: lookup 'interrupts-extended' property first
To: Florian Fainelli <f.fainelli@gmail.com>, Tim Bird <tbird20d@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <53E2A85A.8030406@gmail.com>
References: <1403220823-19444-1-git-send-email-f.fainelli@gmail.com>
	<CAGVrzcYfA8rCXGRW7g0JhT4GQKT8SQj+pMvCh25yoXLFGNM_Pw@mail.gmail.com>
	<20140806165452.GN3711@ld-irv-0074>
	<CAL_JsqK8BiffXgpQSig5EbV3FUW7EBOn9YjZGqOcUcEJiCJ0WA@mail.gmail.com>
	<20140806201256.GO3711@ld-irv-0074>
	<CA+bK7J7LQq4S70ScSynbLTjNMmP=9n3KD2suYRg9JN+pEv-Y7g@mail.gmail.com>
	<53E2A85A.8030406@gmail.com>
Date: Fri, 15 Aug 2014 13:56:38 +0100
Message-Id: <20140815125638.C4D61C410ED@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2014 15:12:42 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 08/06/2014 02:50 PM, Tim Bird wrote:
> > On Wed, Aug 6, 2014 at 1:12 PM, Brian Norris
> > <computersforpeace@gmail.com> wrote:
> >> On Wed, Aug 06, 2014 at 01:42:08PM -0500, Rob Herring wrote:
> >>> On Wed, Aug 6, 2014 at 11:54 AM, Brian Norris <computersforpeace@gmail.com> wrote:
> >>>> On Thu, Jul 31, 2014 at 11:00:01AM -0700, Florian Fainelli wrote:
> >>>> I think it is important that a device tree provide some flexibility on
> >>>> kernel versions. We only invented 'interrupts-extended' in Linux 3.13,
> >>>> so it's easy to have device trees that could work only on 3.13+.
> >>>>
> >>>> Typically, we might say that new features require new kernels, but this
> >>>> is a very basic piece of the DT infrastructure. In our case, we have
> >>>> hardware whose basic features can be supported by a single interrupt
> >>>> parent, and so we used the 'interrupts' property pre-3.13. But when we
> >>>> want to add some power management features, there's an additional
> >>>> interrupt parent. Under the current DT binding, we have to switch over
> >>>> to using 'interrupts-extended' exclusively, and thus we must have a
> >>>> completely new DTB for >=3.13, and this DTB no longer works with the old
> >>>> kernels.
> >>>
> >>> "Must have" to enable the new features?
> >>
> >> Yes. The new feature requires an additional interrupt parent, and so it
> >> requires interrupts-extended.
> > 
> > Hold on there.  What about interrupt-map?  That was the traditional DT
> > feature for
> > supporting multi-parented interrupts.  Why couldn't the feature have been added
> > using that instead of interrupts-extended?
> 
> As far as I read it from the ePAPR specification, you have a good point
> here, it looks like 'interrupt-map' could have been used as-is instead
> of 'interrupts-extended'. In fact it is a little more general than
> 'interrupts-extended' since it allows any sort of "child unit address",
> whether that is an actual interrupt number, or something else, is
> dependent on the type of node being used.

Not really any more general. The child unit address is for filtering
which nodes get a particular map entry. That doesn't have any value when
the routing information is directly in the device node, which is what
interrupts-extended does.

interrupt-map certainly still works, but it is quite fiddly to use when
the use case is merely one device wired to multiple interrupt
controllers, and it is very easy to get wrong. interrupts-extended is
far more concise.

g.
