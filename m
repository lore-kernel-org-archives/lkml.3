Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbaAJQg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:36:29 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:52952 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaAJQg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:36:27 -0500
Date: Fri, 10 Jan 2014 08:36:22 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH V1] input: use device managed memory in da9052
 touchscreen driver
Message-ID: <20140110163622.GB10889@core.coreip.homeip.net>
References: <201401091252.s09CqsOr042762@swsrvapps-02.lan>
 <20140109191236.GA28020@core.coreip.homeip.net>
 <24DF37198A1E704D9811D8F72B87EB51AC050B52@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51AC050B52@NB-EX-MBX02.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 09:02:10AM +0000, Opensource [Anthony Olech] wrote:
> > -----Original Message-----
> > From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> > 
> > I am uncomfortable with the touchscreen portion of this driver ignoring the
> > framework of it's MFD core and mixing native IRQ management with the
> > ones done through the core.
> > 
> > What would happen if somebody changes da9052_request_irq() to do some
> > thing more than it is doing now so that your open-coded duplicate of the
> > same in da9052_ts_probe() is no longer equivalent? Or
> > da9052_disable_irq() no longer works correctly with IRQs allocated by this
> > sub-module?
> > Thanks.
> > --
> > Dmitry

> Hi Dmitry,
>
> unfortunately the PMIC is a multifunction device and the component
> drivers come under different subsystem maintainers. Thus it is not
> possible to do one patch in one go to change them all.

This could be arranged if you really want to do that. You could post a
patch series and have various maintainers ack it and then Samuel could
take it all through MFD tree.

This is up to you however. The change does not fix any bugs and error
unwinding paths in the input portion of the driver are simple enough, so
I do not see a very strong reason for moving to managed devices. I said
that I would not be opposed to this (given that conversion is solid),
but that was never a request form me.

Thanks.

-- 
Dmitry
