Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab3HTUpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:45:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54124 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3HTUpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:45:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC 02/17] ARM: call clk_of_init from time_init
Date: Tue, 20 Aug 2013 22:44:56 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-3-git-send-email-sebastian.hesselbarth@gmail.com> <52138F56.6030008@wwwdotorg.org>
In-Reply-To: <52138F56.6030008@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308202244.56782.arnd@arndb.de>
X-Provags-ID: V02:K0:3PtI0kx0C8X0zUjhd3QLcGzu9Vra636pWXQp45MeM7q
 p6HKLA4Nx2gKxvTnA/aUe684ilrklN4B+897SIc4OdOD0KNKW0
 GdwcIT8LoPk5LjE9KtIAlYPf7gL0JJSHhBbQfKnheu8tjEEgMJ
 EixZTt/ozMpNCVlQbeEal7oAIPjEx5nqUC39m/AHaUhuAH9oRa
 OKezaKbiXfpsRbpgIs+1+zQJgRYFYv2pPhbGYpDYCAqI0QUDph
 kmBv8Qrto9oT6fh0Og3PXbW9XtZmRtJB3xnMq95XxZ73AGKqka
 zeuzIDH/kilT1xAQQ3nTZDS99gBETj8N6dogq+r5rMGP9RHYGE
 GoB1Sm9ispNB+xXsDzUA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 August 2013, Stephen Warren wrote:
> On 08/19/2013 08:04 PM, Sebastian Hesselbarth wrote:
> > Most DT ARM machs require common clock providers initialized before timers.
> > Currently, arch/arm machs use .init_time to call clk_of_init right before
> > clocksource_of_init. This prevents to remove that hook and use the default
> > hook instead. clk_of_init now checks for multiple calls to it, so add
> > the call to ARM arch time_init by default.
> 
> Some SoCs call this function in .init_irq() rather than .init_time().
> Perhaps we adjust this patch to do that instead. That way, we can
> presumably get rid of patch 1/17 since we can eliminate any duplicate
> calls, and adjust patch 14/17 (Tegra board file) to remove its custom
> call to of_clock_init(NULL)?

I think we should do thinks as late as possible in general. We probably
need clocks running on most platforms before we can set up timers, so
it makes sense to do the clocks first, but very few platforms require
clocks to be running before the interrupt controller is set up.

A nicer solution would be to change the tegra code to not require this
to be called this early, if at all possible.

	Arnd
