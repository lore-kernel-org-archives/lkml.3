Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaI3PTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:19:12 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:51924 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaI3PTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:19:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH] gpiolib: fix callers of gpiochip_remove
Date: Tue, 30 Sep 2014 17:18:35 +0200
Message-ID: <2272579.vn7eKdEJtW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACRpkdYdwhujkP_66GCNktcvXFOzmGW=3t6BvCSXXMnHu03eEg@mail.gmail.com>
References: <2923496.zl6JUbOQrZ@wuerfel> <CACRpkdYdwhujkP_66GCNktcvXFOzmGW=3t6BvCSXXMnHu03eEg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0j6p3kHX3hcR6iZyWg2aZIWrgVjTywN691bal62IUXv
 MMNwvbFP29pYWoGZ2LMZyenuL3ILKwnAOwy4nnJHMn4Tt5mxKf
 2R+yGGwBMZe4p6Qhqd8OXaNnlIvNrd2iMeuZWqKTw85dIsQMg/
 c72A1J1tFpfuBn+bpB/AD/3+zoAkGcjzHsio3zkvzhFPOY+agg
 rm9iKAOlSm9UxGoqe+bOIRbfpsAeF49vj0k/4ShkOpRT2vJo8+
 lF+fiw8ONgH9ilBVJVaOpCdDq4WjNmtZx6oAxP4bqjSu3m/DFN
 /GmeGTqJUBeCuncilH6GfpKkqCGxPSvNaPF94nDEf6vot53r/D
 ho7AvjlsYEYPddtAKza0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 16:11:28 Linus Walleij wrote:
> On Tue, Sep 30, 2014 at 3:24 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > A recent API change made gpiochip_remove return void instead of an
> > error value, which broke drivers that use this return value:
> >
> > gpio/gpio-sch311x.c: In function 'sch311x_gpio_probe':
> > gpio/gpio-sch311x.c:286:7: error: void value not ignored as it ought to be
> >    if (gpiochip_remove(&priv->blocks[i].chip))
> >        ^
> >
> > This changes the callers that I have found during randconfig testing
> > so they no longer depend on the error code.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Fixes: e1db1706c86e ("gpio: gpiolib: set gpiochip_remove retval to void")
> 
> Hm AFAICT these are already fixes in my GPIO tree
> and linux-next...
> 
> Am I looking in the wrong place?
> 
> 

No, it's my fault, I seem to have a patch in my tree that reverts those
changes.

	Arnd
