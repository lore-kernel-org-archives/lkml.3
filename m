Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaHFUNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:13:04 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44992 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaHFUNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:13:00 -0400
Date: Wed, 6 Aug 2014 13:12:56 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of/irq: lookup 'interrupts-extended' property first
Message-ID: <20140806201256.GO3711@ld-irv-0074>
References: <1403220823-19444-1-git-send-email-f.fainelli@gmail.com>
 <CAGVrzcYfA8rCXGRW7g0JhT4GQKT8SQj+pMvCh25yoXLFGNM_Pw@mail.gmail.com>
 <20140806165452.GN3711@ld-irv-0074>
 <CAL_JsqK8BiffXgpQSig5EbV3FUW7EBOn9YjZGqOcUcEJiCJ0WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqK8BiffXgpQSig5EbV3FUW7EBOn9YjZGqOcUcEJiCJ0WA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 01:42:08PM -0500, Rob Herring wrote:
> On Wed, Aug 6, 2014 at 11:54 AM, Brian Norris <computersforpeace@gmail.com> wrote:
> > On Thu, Jul 31, 2014 at 11:00:01AM -0700, Florian Fainelli wrote:
> > I think it is important that a device tree provide some flexibility on
> > kernel versions. We only invented 'interrupts-extended' in Linux 3.13,
> > so it's easy to have device trees that could work only on 3.13+.
> >
> > Typically, we might say that new features require new kernels, but this
> > is a very basic piece of the DT infrastructure. In our case, we have
> > hardware whose basic features can be supported by a single interrupt
> > parent, and so we used the 'interrupts' property pre-3.13. But when we
> > want to add some power management features, there's an additional
> > interrupt parent. Under the current DT binding, we have to switch over
> > to using 'interrupts-extended' exclusively, and thus we must have a
> > completely new DTB for >=3.13, and this DTB no longer works with the old
> > kernels.
> 
> "Must have" to enable the new features?

Yes. The new feature requires an additional interrupt parent, and so it
requires interrupts-extended.

> I would expect a new kernel
> and old dtb still works, right? That is the most important
> compatibility issue to consider.

Yes, new kernels work with an old DTB.

The problem we are considering is that old kernels don't work with new
DTBs, unless you allow both interrupts and interrupts-extended in a new
DTB.

> > How's that for DT stability?
> >
> > On the other hand, if we support this precedence concept, then a new DTB
> > can provide both the 'interrupts-extended' and 'interrupts' properties,
> > and thus be compatible with both pre-3.13 and
> > post-<whenever-this-is-accepted> kernels.
> 
> Yes, this is what should be done. And I don't have any issue marking
> this for stable if needed.

Fine with me. We'll be porting it for our downstream kernels anyway.

> >> Any comments on this? Brian suggested that I update
> >> interrupt-controller/interrupts.txt to specify the look up ordering
> >> change as well.
> >
> > What do you think about the following DT binding doc update to accompany
> > this change?
> 
> For both changes,
> 
> Acked-by: Rob Herring <robh@kernel.org>
> 
> Can you send a proper patch for the doc change or combine them.

Florian just sent the combined version.

Brian
