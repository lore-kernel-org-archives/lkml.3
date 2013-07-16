Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab3GPNlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:41:24 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:25219 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab3GPNlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:41:23 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX195tQCapHzTLtNZHBypM35k
Date: Tue, 16 Jul 2013 06:41:18 -0700
From: Tony Lindgren <tony@atomide.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: linus.walleij@linaro.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/4] pinctrl: Remove duplicate code in
 pinctrl_pm_select_state functions
Message-ID: <20130716134118.GC7656@atomide.com>
References: <20130716090310.5541.36777.stgit@localhost>
 <20130716090529.5541.54331.stgit@localhost>
 <51E5475B.1050900@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E5475B.1050900@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grygorii Strashko <grygorii.strashko@ti.com> [130716 06:22]:
> Hi Tony,
> 
> This patch causes boot failure when I've applied my patch
> "[RFC] ARM: OMAP2+: omap_device: add pinctrl handling"
> https://lkml.org/lkml/2013/6/21/309
>
> on top of it:

Hmm this patch alone removes duplicate code and if it causes
issues I must have made a typo somewhere.

I cannot see a typo though, but in your dmesg I see something..

> [    0.610565] PC is at pinctrl_pm_select_active_state+0x4/0xc

..looks like you have something applied for the active_state
that only gets introduced later on in this series.

Maybe you have the earlier version of drivers/base/pinctrl.c
active_state patch that was in linux next for a while but
got reverted as we noticed we had to rework some things?

So maybe try with v3.11-rc1 + these four patches + your
omap_device patch?

Regards,

Tony
