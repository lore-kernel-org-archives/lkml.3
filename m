Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481Ab3IDIf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:35:57 -0400
Received: from smtp2-1.goneo.de ([212.90.139.83]:33923 "EHLO smtp2-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934372Ab3IDIfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:35:50 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.741
From: Lars Poeschel <poeschel@lemonage.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
Date: Wed, 04 Sep 2013 10:35:44 +0200
Message-ID: <5584741.67AvVurcHF@lem-wkst-02>
User-Agent: KMail/4.10.5 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52261C8B.2030906@wwwdotorg.org>
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <CACRpkdYeMGkju345g9d_ifZEOiVXftzSqU=1CfGO=qnt6Vj-Bg@mail.gmail.com> <52261C8B.2030906@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 September 2013 11:29:47, Stephen Warren wrote:
> On 09/03/2013 06:35 AM, Linus Walleij wrote:
> > On Fri, Aug 30, 2013 at 9:53 PM, Stephen Warren <swarren@wwwdotorg.org> 
wrote:
> >> I still haven't seen an answer to why we really care about this; how
> >> many times has code actually allocated the same GPIO/IRQ when it
> >> shouldn't, in a way that it wasn't detectable by some other mechanism,
> >> i.e. the feature just not working? Why are we even trying to solve this
> >> issue? I'm not totally convinced it even makes sense to try and solve it.
> > 
> > We care about this because a number of OMAP boards are not
> > working properly when booted from device tree, and they have a hard
> > time figuring out a solution to the problem. Last try exploded. Now
> > they are looking to create a patch that will fix the actual problem.
> 
> Is something missing from /proc/interrupts or /sys/kernel/debug/gpios?
> If so, let's just add it.

That would require procfs to be mounted to /proc and even CONFIG_PROC_FS to be 
compiled in. Drivers have to work without that requirement.
That would require CONFIG_DEBUG_FS to be set, right? Drivers have to work 
without that.
