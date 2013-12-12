Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3LLRw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:52:26 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:48014 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab3LLRwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:52:20 -0500
MIME-Version: 1.0
In-Reply-To: <52A59C9A.6000306@overkiz.com>
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
	<CACRpkdag5=QYsWe81ocpkMp2APaoBAOOn2r0iAVdf9DHTKrSXA@mail.gmail.com>
	<52A59C9A.6000306@overkiz.com>
Date: Thu, 12 Dec 2013 18:52:19 +0100
Message-ID: <CACRpkdavA+wPoms2mxxQPStH7yMATyqL6HiS8HVi9bPEXL2Sqw@mail.gmail.com>
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

On Mon, Dec 9, 2013 at 11:34 AM, boris brezillon
<b.brezillon@overkiz.com> wrote:
> [Me]
>> This has been suggested under the name "GPIO hogs" in the past.
>>
>> It would work similar to how pinctrl hogs work by associating the
>> GPIO line the controller itself, using some specific string
>> like gpio-input-hogs = <...> / gpio-output-hogs = <...>;
>>
>> The gpiolib core will then grab and set up these before
>> returning from the registration call so noone ever gets a chance
>> to use them.
>
> One more question, and I'm done :).
>
> In which case should we use output-high or output-low config
> instead of gpio-output-hogs ?

This is specified in Documentation/pinctrl.txt under the
heading "GPIO mode pitfalls".

Basically: the generic pinconfig output-high/output-low are
for the case where this is a valid state for a Linux device
driver driving a piece of hardware, like an IP-block, which
is making use of these pins and during that usecase passes
through states the data sheet may call "GPIO mode",
but which are actually a way which the *device* uses
the pins, not independent GPIO lines, like, just some
1-bit line.

Yours,
Linus Walleij
