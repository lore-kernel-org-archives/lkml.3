Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3I3RC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:02:57 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:38258 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab3I3RCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:02:55 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1380559686-2605-1-git-send-email-nicolas.ferre@atmel.com>
References: <1380559686-2605-1-git-send-email-nicolas.ferre@atmel.com>
Date: Mon, 30 Sep 2013 10:02:54 -0700
Message-ID: <CAOesGMh8sv0mSZ5NbJGd=oN4Ay_k8WMUDkVjpM7Aw+S6_jJk3w@mail.gmail.com>
Subject: Re: [GIT PULL] at91: fixes for 3.12 #2
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "arm@kernel.org" <arm@kernel.org>,
        boris brezillon <b.brezillon@overkiz.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 9:48 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Arnd, Olof, Kevin,
>
> Second batch of fixes for AT91. Two little patches but that can be important
> for AT91.
> One is finishing the conversion to clk_xxx_[un]prepare() routines. That will
> allow us to begin the move to common clock framework with help from Boris and
> his big patch series. I tried to push it through Thomas and John's git tree but
> without success.

It sounds to me like this patch should go in together with the CCF
patches, since it doesn't address a regression and is just a
prerequisite for the conversion? If you can shake an Ack out of John
you should be all set for that. :-)

> The other one is important for sam9g45 when the second DDR conrtoller is in
> use. The DDR / EBI lines are not properly reseted after a shutdown and could
> prevent the use of whatever is connected to this EBI. It is not a configuration
> that we are using on the Evaluation Kit and this explains why we face this isue
> just now...

Ok, that sounds like a valid fix.

I'll cherry-pick in the DDR fix right away, and if you for some reason
need the other one we can add it later, but it sounds like it should
just go in with the CCF branch.


-Olof
