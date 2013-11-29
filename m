Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3K2NbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 08:31:24 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:41426 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3K2NbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 08:31:22 -0500
MIME-Version: 1.0
In-Reply-To: <52986CA8.3010601@overkiz.com>
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>
	<1377687995-10758-1-git-send-email-b.brezillon@overkiz.com>
	<20131120145926.GE14627@ns203013.ovh.net>
	<528CDFFB.1020601@overkiz.com>
	<CACRpkdboBg4YOnMNiar0DDBVnoky=zNky+Pzyp1=P_POtH15qQ@mail.gmail.com>
	<528DE1C4.6060900@overkiz.com>
	<CACRpkdZdweyWJefttiuiYAJ9qhahLbnj7eHUiLV_83UA41X_uQ@mail.gmail.com>
	<5294D64D.7000100@overkiz.com>
	<CACRpkdZoAjuWVpWZfvPgOAd7qB1ZBtC+45nD3SYay3SrMhqwVA@mail.gmail.com>
	<52986CA8.3010601@overkiz.com>
Date: Fri, 29 Nov 2013 14:31:21 +0100
Message-ID: <CACRpkdag5=QYsWe81ocpkMp2APaoBAOOn2r0iAVdf9DHTKrSXA@mail.gmail.com>
Subject: Re: [PATCH 5/9] ARM: at91/dt: add mmc0 slot0 support to at91rm9200ek board
From: Linus Walleij <linus.walleij@linaro.org>
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 11:30 AM, boris brezillon
<b.brezillon@overkiz.com> wrote:
> On 29/11/2013 11:03, Linus Walleij wrote:

>> I guess one way is to obtain this GPIO in board code and just
>> flick it depending on which device you register.
(...)
> The whole goal of moving from board files to dt is to drop all board
> specific processing or initialization and only keep a common description
> with generic drivers capable of handling common use cases.
>
> I'm not sure providing new board specific drivers is a good solution
> (even if it is the simplest way to achieve our goal).
>
> Could we have something similar to pinctrl but with gpios :
> when the device is probed the device/driver core code request the gpio
> configure it appropriately and set it to the requested value (if configured
> as output).

This has been suggested under the name "GPIO hogs" in the past.

It would work similar to how pinctrl hogs work by associating the
GPIO line the controller itself, using some specific string
like gpio-input-hogs = <...> / gpio-output-hogs = <...>;

The gpiolib core will then grab and set up these before
returning from the registration call so noone ever gets a chance
to use them.

> These are just thoughts, and I guess introducing new code in the
> device/driver core
> code is not that easy, especially when this code is here to handle specific
> case
> like ours.

It is very easy, just write the patch, iterate it (these patches get
a lot of scrutiny as it is core code, so expect some work and time
to get it done), and then unless there is a blocker, I would merge it.
The concept is entirely sound, just that someone needs to step
up and do the work...

Yours,
Linus Walleij
