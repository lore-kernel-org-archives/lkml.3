Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3GVWnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:43:37 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:55596 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3GVWnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:43:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130718151504.30990.96819.stgit@localhost>
References: <20130718151213.30990.45828.stgit@localhost>
	<20130718151504.30990.96819.stgit@localhost>
Date: Tue, 23 Jul 2013 00:43:35 +0200
Message-ID: <CACRpkdYbXEPmHwzGMwJ9e-VEJsOumYboGdQcPHqbq87FNL3fBw@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: Remove duplicate code in pinctrl_pm_select_state
 functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 5:15 PM, Tony Lindgren <tony@atomide.com> wrote:

> There's no need to duplicate essentially the same functions. Let's
> introduce static int pinctrl_pm_select_state() and make the other
> related functions call that.
>
> This allows us to add support later on for multiple active states,
> and more optimized dynamic remuxing.
>
> Note that we still need to export the various pinctrl_pm_select
> functions as we want to keep struct pinctrl_state private to the
> pinctrl code, and cannot replace those with inline functions.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Aha that is how to do it. Stephen complained about it earlier
but I couldn't come up with a good enough refactoring.

Patch applied.

Yours,
Linus Walleij
