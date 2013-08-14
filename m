Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab3HNQlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:41:15 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:52838 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709Ab3HNQlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:41:10 -0400
MIME-Version: 1.0
In-Reply-To: <51F6E657.2060802@wwwdotorg.org>
References: <20130716090310.5541.36777.stgit@localhost>
	<20130716090536.5541.36289.stgit@localhost>
	<51E70953.1000601@wwwdotorg.org>
	<20130718072034.GO7656@atomide.com>
	<51E8401E.8040705@wwwdotorg.org>
	<20130719072927.GY7656@atomide.com>
	<51E98AEC.5000802@wwwdotorg.org>
	<20130729090524.GY7656@atomide.com>
	<51F6E657.2060802@wwwdotorg.org>
Date: Wed, 14 Aug 2013 18:41:09 +0200
Message-ID: <CACRpkdZXFv4JFek9SV1n=7gw0sLAeA_xxC1D+_OMLQyLYtXLvA@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: Add support for additional dynamic states
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tony Lindgren <tony@atomide.com>, Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 12:01 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> I was thinking more about people writing the device trees that define
> these states; they need to explicitly make the choice re: overlapping
> states or independent states. We should not plan to obsolete any current
> usage of overlapping states since that will mean an incompatible change
> to the DT ABI (deprecate yes so that no more usage is added, but the
> kernel should still support the old way).

This is another reason to not group and encode explicitly the pins
that remain unchanged during state transitions.

I prefer that either:

- when we build up the state containers in the subsystem,
 we identify overlapping pins and encode them in the state
 container somehow

or:

- when transitioning from state A -> state B we identify
 ovelapping pins or groups of pins and do not touch them
 by making calls down to the driver ->free() and ->request()
 callback pair.

or:

the pinctrl-single.c driver in it's callbacks like ->enable()
->disable(), ->request(), ->free() internally short cuts from
its knowledge of such pin shortcuts and no other drivers
are affected (nor helped) by this optimization.

Yours,
Linus Walleij
