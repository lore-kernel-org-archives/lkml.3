Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab3HUSyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:54:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65079 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab3HUSyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:54:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [RFC 02/17] ARM: call clk_of_init from time_init
Date: Wed, 21 Aug 2013 20:54:10 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <5213C90F.9010407@wwwdotorg.org> <5213CF58.50703@gmail.com>
In-Reply-To: <5213CF58.50703@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308212054.10417.arnd@arndb.de>
X-Provags-ID: V02:K0:mMR4Ad7+ScGthMUqUnh5aKRceHtDTGYhMCpxsk9tvC9
 zK4qbj/8DddMLKiAyqHGuwnsdF3cPYhyayChFh1I8+djfzRQDv
 0Qu67PT1gdi789aTTMoC+2/bAF5eHeZAUtje4DIBeOuNGYdVcg
 hg7txOOE02Z1iqz7HrTmvLKYH+mXsJ1KBBCsGIMZiUWCrvj1V9
 rGO/Rtx3lIj65sP3MgpDdgO9QN45YbfNDNuWWFhND8zRSLLAvR
 FYZ5uc9y3XUP4+7MMfHdqcPevAR4WZHaD+pH7x8uAIZFwM7ImK
 wFBrWXEeLECFsC+RRVzYMFFGt/gtxkAPAT8OznYz/1hgSpwLqc
 HjIvH697ce00hnmcW8P4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 August 2013, Sebastian Hesselbarth wrote:
> Perhaps Tegra is the common case but other SoC haven't dug deep enough?
> IMHO from a HW point-of-view clocks are really among the essential
> things that need to be running before you can do anything useful.
> 
> Just consider boot loaders that run fine without irqs but don't without
> clocks (even if just represented by API). Maybe you are right, and we
> should call of_clk_init(NULL) as early as possible. That would also
> eliminate patch 1/17 as you suggest.

Timers and interrupts are also things that are required really early,
and from my experience they tend to be needed earlier than clock
management. Obviously you need some clocks to be enabled in order
to do anything (including interrupt handling), but those clocks tend
to be enabled in the boot loader, so we don't have to worry about
reprogramming them this early.

	Arnd
