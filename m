Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaEZFXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 01:23:25 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38798 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaEZFXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 01:23:23 -0400
Date: Sun, 25 May 2014 22:23:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Yufeng Shen <miletus@chromium.org>
Cc: Nick Dyer <nick.dyer@itdev.co.uk>, Benson Leung <bleung@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 20/51] Input: atmel_mxt_ts - Set default irqflags when
 there is no pdata
Message-ID: <20140526052320.GA12890@core.coreip.homeip.net>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
 <1372337366-9286-21-git-send-email-nick.dyer@itdev.co.uk>
 <20130718171744.GC32381@polaris.bitmath.org>
 <20130916022533.GA6468@core.coreip.homeip.net>
 <537E09D6.7050604@itdev.co.uk>
 <CAPDwgkP5KjP6PcZBeYTMPuewO4exyUFfCX8rhzmgDO65ti=3Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDwgkP5KjP6PcZBeYTMPuewO4exyUFfCX8rhzmgDO65ti=3Mg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 12:37:46PM -0400, Yufeng Shen wrote:
> On Thu, May 22, 2014 at 10:29 AM, Nick Dyer <nick.dyer@itdev.co.uk> wrote:
> >
> > Dmitry Torokhov wrote:
> > > On Thu, Jul 18, 2013 at 07:17:44PM +0200, rydberg@euromail.se wrote:
> > >>> From: Yufeng Shen <miletus@chromium.org>
> > >>> This is the preparation for supporting the code path when there is
> > >>> platform data provided and still boot the device into a sane state
> > >>> with backup NVRAM config.
> > >>>
> > >>> Make the irqflags default to be IRQF_TRIGGER_FALLING if no platform data is
> > >>> provided.
> > >
> > > I think if there is no platform data we should use 0 as IRQ falgs and
> > > assume that IRQ line is properly configured by the board code or via
> > > device tree.
> >
> > Beson/Yufeng - do you still have a requirement to probe without platform
> > data or device tree? I'm just merging in some changes to add device tree
> > support, and it would simplify things a bit if I can drop this patch.
> 
> 
> It has been working for quite a while for boards/devices that don't
> provide platform
> data. If we drop the default IRQ flags, sure we can add code for each
> board to configure
> the IRQ separately, but that's just adding extra work. Is there strong
> reason why we
> should not do the default setting in the driver if it is not already
> configured in platform
> data ?


I am not saying that board code needs to add platform data. I am saying
that the board code needs to set up interrupt properly (via
irq_set_irq_type() or similar) and then the driver can use 0 as irqflags
argument in request_irq() in absence of DT/platform data.

Thanks.

-- 
Dmitry
