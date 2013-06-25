Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3FYG6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 02:58:18 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:30109 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751396Ab3FYG6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 02:58:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+iMiwyiSNgqCdImmRoRKj5
Date: Mon, 24 Jun 2013 23:58:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC] ARM: OMAP2+: omap_device: add pinctrl handling
Message-ID: <20130625065811.GZ5523@atomide.com>
References: <1371826990-25820-1-git-send-email-grygorii.strashko@ti.com>
 <CACRpkdY=m1b9Lh27+wHP8FQ4SbVZKmAOCGhxe59aP+TcuR9QaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY=m1b9Lh27+wHP8FQ4SbVZKmAOCGhxe59aP+TcuR9QaA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [130624 05:13]:
> On Fri, Jun 21, 2013 at 5:03 PM, Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
> 
> > Hence, add pinctrl handling in omap_device core:
> > 1) on PM runtime resume
> > - switch pinctrl state to "default" (todo: "active")
> > 2) on PM runtime suspend
> > - switch pinctrl state to "idle"
> > 3) during system wide suspend
> > - switch pinctrl state to "sleep" or "idle" if omap_device core disables device
> > - switch pinctrl state to "sleep" if device is disabled already

Do you need a separate setting for "idle" and "sleep", or are
they the same?

> > 4) during system wide resume
> > - switch pinctrl state to "default" (todo: "active") if omap_device core has
> >   disabled  device during suspend
> > - switch pinctrl state to "idle" if device was already disabled before suspend
> 
> I don't understand step 4.
> 
> I get the creeps about whether the system is runtime suspended
> or runtime resumed when we come to resume proper, so I need
> Kevin to have a look at this.
> 
> Apart from that it looks good.
> 
> Stephen and Tony are trying to figure out the details of whether "active"
> is necessary or not in a related thread I think.

Yes we should have that sorted out over next few weeks, so let's
just wait a little while on all these dynamic remuxing patches
to avoid churn.

Regards,

Tony
