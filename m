Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaEBWOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 18:14:35 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34923 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaEBWOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 18:14:34 -0400
MIME-Version: 1.0
In-Reply-To: <1392138636-29240-5-git-send-email-pawel.moll@arm.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
	<1392138636-29240-5-git-send-email-pawel.moll@arm.com>
Date: Fri, 2 May 2014 15:14:34 -0700
Message-ID: <CACRpkdZ2Chwm0xu+bf8UAEi_5DR8WhMTv0gDJ6NC+6bQwHeB6Q@mail.gmail.com>
Subject: Re: [PATCH 04/12] clocksource: Sched clock source for Versatile Express
From: Linus Walleij <linus.walleij@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 9:10 AM, Pawel Moll <pawel.moll@arm.com> wrote:

> This patch adds a trival sched clock source using free
> running, 24MHz clocked counter present in the ARM Ltd.
> Versatile Express platform's System Registers block.
>
> This code replaces the call in the VE machine code.
>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

Even the Integrator is very similar, albeit using register 0x28 instead
of register 0x5c. cd commit
a79528e9d849803457b6235ddb1a1cfd4e11c6cd

It's one of these things where writing a device driver results in
more code than just registering this counter with the sched_clock
guts :-/

Getting the clock from the DT gives this nice feeling of having it all
complete, and sched_clock cannot really change frequency anyway
so I'm happy with this thing.

I'll augment it for Integrator when/if I find time.

Yours,
Linus Walleij
