Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3GVXPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:15:16 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:36241 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab3GVXPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:15:14 -0400
MIME-Version: 1.0
In-Reply-To: <51E98D89.9050407@wwwdotorg.org>
References: <20130716090310.5541.36777.stgit@localhost>
	<20130716090536.5541.36289.stgit@localhost>
	<51E70B5D.6030802@wwwdotorg.org>
	<20130718073638.GP7656@atomide.com>
	<51E84180.6080902@wwwdotorg.org>
	<20130719073957.GZ7656@atomide.com>
	<51E91516.2040301@ti.com>
	<51E98D89.9050407@wwwdotorg.org>
Date: Tue, 23 Jul 2013 01:15:13 +0200
Message-ID: <CACRpkdbHj8R-ZFa2FB-pxcvgBRYH=1KKGNEbWieAnSZSv5LHaQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: Add support for additional dynamic states
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 9:03 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 07/19/2013 04:29 AM, Grygorii Strashko wrote:

>> First of all, I'd like to mention that these patches do *not* connect
>> pinctrl to PM runtime, so until driver will call pinctrl_select_state()
>> or pinctrl_pm_select_*() there will be no pins state changes.
>
> Isn't the whole point of the pinctrl_pm_select*() APIs to eventually be
> called automatically by the runtime PM core,

Nah I had no such complete ambitions, just factoring around.

There are examples, such as deactivating a TTY from userspace,
that should result in the pins going to sleep while it may have nothing
to do with runtime PM.

> so that we don't need to
> write code to do this in every single driver, just like we moved the
> call to pinctrl_select_state(default) into the device core so that we
> didn't have to make every device do that manually?

I am pretty convinced that if this dynamic muxing stuff shall be
implemented, it should be a pinctrl subsystem intrinsic optimization
detail and should not be exposed to the outside with all these extra
functions at all. It looks overly complicated to me.

Yours,
Linus Walleij
