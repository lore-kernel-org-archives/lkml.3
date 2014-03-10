Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaCJRIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:08:25 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56738 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbaCJRIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:08:21 -0400
Date: Mon, 10 Mar 2014 12:05:26 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 6/6] documentation: bindings: document PMIC8921/8058 RTC
Message-ID: <20140310170526.GK18529@joshc.qualcomm.com>
References: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
 <1394047776-13827-7-git-send-email-joshc@codeaurora.org>
 <5317900F.5030803@codeaurora.org>
 <20140306000058.GE18529@joshc.qualcomm.com>
 <CAL_JsqJU-vb8CAat+X-WtW9rDPzqj9oDfpXf8pEwuwLVtOskPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJU-vb8CAat+X-WtW9rDPzqj9oDfpXf8pEwuwLVtOskPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Rob-

Thanks for the reply.

On Mon, Mar 10, 2014 at 10:35:25AM -0500, Rob Herring wrote:
> On Wed, Mar 5, 2014 at 6:00 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> > On Wed, Mar 05, 2014 at 12:58:55PM -0800, Stephen Boyd wrote:
> >> On 03/05/14 11:29, Josh Cartwright wrote:
> >> > +- interrupts: interrupt list for the RTC, must contain a single interrupt
> >> > +              specifier for the alarm interrupt
> >> > +- interrupt-names: corresponding interrupt names for the interrupts listed in
> >> > +                   the 'interrupts' property, must contain:
> >> > +     "alarm" - summary interrupt for PMIC peripherals
> >>
> >> optional interrupt-names?
> >
> > It isn't clear to me why these should be made optional, I hope Rob
> > provides some clarification in the sdhci-msm thread.
>
> Because reg and interrupt names are relatively new and reluctantly
> added by DT maintainers. Personally, I think it was a mistake and it
> is simply Linux specific information leaking into the DT, but it did
> make transition to DT easier.

I don't necessarily buy the Linux-specific argument in general.  If a
devices' datasheet clearly gives names to register regions and
interrupts, what about reflecting these names in the bindings is
Linux-specific?

Now, there are probably abuses of this, where the reg-names and
interrupt-names are abused to ensure driver compatibility with devices
described in board files, and only in that case will I agree is
Linux-specific and should be strongly discouraged.

> The requirement is still the ordering of reg and interrupts fields
> must be defined and you cannot rely on the names to define the order.

Should this requirement also exist for other <foo>-names properties?

> It is quite pointless here since you only have 1 field.

Indeed in the interrupt case it is worthless, as there is only one alarm
interrupt.  However for registers I do plan to extend this binding in
the future to document a newer RTC which does split registers across
multiple named address regions.

Thanks again,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
