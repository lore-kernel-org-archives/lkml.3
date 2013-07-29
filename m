Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab3G2JI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:08:29 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49820 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab3G2JI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:08:27 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18bmkCUlCflmRpTxBrwAM8j
Date: Mon, 29 Jul 2013 02:08:22 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>, linus.walleij@linaro.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] pinctrl: Add support for additional dynamic states
Message-ID: <20130729090822.GZ7656@atomide.com>
References: <20130716090310.5541.36777.stgit@localhost>
 <20130716090536.5541.36289.stgit@localhost>
 <51E70B5D.6030802@wwwdotorg.org>
 <20130718073638.GP7656@atomide.com>
 <51E84180.6080902@wwwdotorg.org>
 <20130719073957.GZ7656@atomide.com>
 <51E91516.2040301@ti.com>
 <51E98D89.9050407@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E98D89.9050407@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [130719 12:10]:
> On 07/19/2013 04:29 AM, Grygorii Strashko wrote:
> > 
> > First of all, I'd like to mention that these patches do *not* connect
> > pinctrl to PM runtime, so until driver will call pinctrl_select_state()
> > or pinctrl_pm_select_*() there will be no pins state changes.
> 
> Isn't the whole point of the pinctrl_pm_select*() APIs to eventually be
> called automatically by the runtime PM core, so that we don't need to
> write code to do this in every single driver, just like we moved the
> call to pinctrl_select_state(default) into the device core so that we
> didn't have to make every device do that manually?

Yes I think we can make it all automatic. So far it seems that the
last missing piece was Linus' suggestion of making it mostly happen
using irqchip with calls to pinctrl so consumer drivers may not need
to do anything.
 
> > (As result, i2c-mux is not good example, seems:))
> 
> As such, I think all situations are good examples, because a generic
> feature has to work in all cases.

Yes we need to support both runtime PM, and more complex cases of
sharing pins between devices for example that are not runtime PM
related.

Regards,

Tony
