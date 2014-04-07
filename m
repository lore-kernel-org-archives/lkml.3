Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaDGROS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:14:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51708 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbaDGROM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:14:12 -0400
Date: Mon, 7 Apr 2014 12:11:15 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Tien Hock Loh <thloh@altera.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com,
        Mark Rutland <mark.rutland@arm.com>, ijc+devicetree@hellion.org.uk,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        dinguyen@altera.com, "lftan@altera.com" <lftan@altera.com>
Subject: Re: [PATCH V7 1/1] drivers/gpio: Altera soft IP GPIO driver and
 devicetree binding
Message-ID: <20140407171115.GA3956@joshc.qualcomm.com>
References: <1393842463-5206-1-git-send-email-thloh@altera.com>
 <20140307151455.GI18529@joshc.qualcomm.com>
 <CAOLUe6aspffO1PUjKWW7ejpbxnYtb+RKRQrK=y30kuF7KXUUhA@mail.gmail.com>
 <CAOLUe6aPWmkJJSiBLL8tmw2MNfpaeLpSp3CSwP1u7q+qXxCh9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOLUe6aPWmkJJSiBLL8tmw2MNfpaeLpSp3CSwP1u7q+qXxCh9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 04:00:43PM +0800, Tien Hock Loh wrote:
> On Wed, Mar 19, 2014 at 6:09 PM, Tien Hock Loh <thloh@altera.com> wrote:
> > On Fri, Mar 7, 2014 at 11:14 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> >> On Mon, Mar 03, 2014 at 06:27:43PM +0800, thloh@altera.com wrote:
> >>> From: Tien Hock Loh <thloh@altera.com>
[..]
> >>> +     altera_gc->mapped_irq = irq_of_parse_and_map(node, 0);
> >>>
> >>
> >> platform_get_irq(pdev, 0);
> >>
> > OK.
> >
>
> platform_get_irq doesn't create the irq mapping which is needed by the
> driver. Since this driver is targeted at using of, should I be using
> irq_of_parse_and_map or should I still redo the codes with
> platform_get_irq and irq_create_mapping? I think the latter would be
> introducing code redundancy. Please advice.

Yes, it is technically true that platform_get_irq() doesn't do the
mapping directly, but that's because the mapping is setup earlier, when
of_device_alloc() (drivers/of/platform.c) allocates resources for your
platform device.

Calling irq_of_parse_and_map() should be unnecessary.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
