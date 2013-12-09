Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111Ab3LIQwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:52:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63920 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab3LIQv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:51:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: boris brezillon <b.brezillon@overkiz.com>
Subject: Re: [PATCH v4 3/6] ARM: at91/dt: define sama5d3 clocks
Date: Mon, 9 Dec 2013 17:48:58 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1385650171-8756-1-git-send-email-b.brezillon@overkiz.com> <201312091648.13802.arnd@arndb.de> <52A5ED03.2070306@overkiz.com>
In-Reply-To: <52A5ED03.2070306@overkiz.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312091748.58386.arnd@arndb.de>
X-Provags-ID: V02:K0:9K0Ty2+ooIQ4OQwN+qJTJpgSSEuuejzJGKVUbuAkLja
 QAl8f/sWxHM4a8J4sZ3CujGwOXG2CEJ8mZ6r1lcHjdOU8u8XBa
 tQXfLQUZQNEWxDEian8289BSsGE+KYgDNkf2JFuFazQ95dZ2yI
 UXdBT3vEq71tbGgMIcygAvnRqLqC1JuV6tCT+CPa3hKNsr046O
 tMYy6LC3ahNRbpVgjjLt2fCmkcdOT5w7oRAKn4ypPaotDWGGe0
 Qo4+U59TYd8HP7NYmOXu34Nmj5Z7HRKbZR2tMrHK+yfJThoO/k
 7rFne9IWOH49LcBRpdvqDhas8c1vlYGt7QBNyyVfDUwk/3MW/j
 t3I/R4XKutz1N/jKDTK8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 December 2013, boris brezillon wrote:
> Hello Arnd,
> 
> On 09/12/2013 16:48, Arnd Bergmann wrote:
> > On Monday 09 December 2013, boris brezillon wrote:
> >>> You are adding "clock-names" properties in a lot of cases. Are you sure you
> >>> are using the strings that are documented in the respective device bindings
> >>> for each name? In a lot of cases, drivers just want an anonymous clock
> >>> and we don't name them.
> >> I rechecked it, and almost all drivers call [devm_]clk_get with a
> >> specific clock
> >> name, and as a result we must specify the "clock-names" property.
> >> The only exceptions I found are the spi and PIT (Periodic Interval
> >> Timer) drivers,
> >> and "clock-names" property is not defined in these nodes.
> > Yes, I understood that the *drivers* use the names, but are they actually
> > documented in the device bindings? If not, it might be better to change the
> > drivers.
> 
> We have to keep both clk system working for at91 platform (new CCF based
> clk implementations and old clk implementations) for two reasons:
> 1) the new clk implemetations are only compatible with DT enabled boards
>      and some at91 boards are not yet ported to DT.
> 2) we decided to move to the new clk implementations in multiple steps 
> (one SoC
>      family after another) in order to ease PATCH review.
> 
> If we change the drivers to avoid specific clock name request 
> ([devm]_clk_get(dev, NULL)),
> we will have to change the old static clk lookup tables
> (i.e. 
> http://lxr.free-electrons.com/source/arch/arm/mach-at91/at91sam9g45.c#L226,
> http://lxr.free-electrons.com/source/arch/arm/mach-at91/at91sam9260.c#L202, 
> ...).

Yes, that is a bit painful, but we really need to ensure that the drivers
implement the documented binding. If they don't match we have to either 
review and change all the binding documents, or change the static clock
tables and the drivers.

Note that I have not checked your binding documents for the devices in
question. If they already document these names, we don't need to change
anything.

	Arnd
