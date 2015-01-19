Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbbASSJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:09:00 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:36613 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbbASSIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:08:42 -0500
MIME-Version: 1.0
In-Reply-To: <1397668411-27162-2-git-send-email-ynvich@gmail.com>
References: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
 <1397668411-27162-1-git-send-email-ynvich@gmail.com> <1397668411-27162-2-git-send-email-ynvich@gmail.com>
From: Rob Herring <robherring2@gmail.com>
Date: Mon, 19 Jan 2015 12:08:21 -0600
Message-ID: <CAL_JsqJUWRhGA_8NU+O=fLFdMiVNz0LV6G0LU=ikgk=zah2q2A@mail.gmail.com>
Subject: Re: [PATCH v4 01/21] serial: rewrite pxa2xx-uart to use 8250_core
To: Sergei Ianovich <ynvich@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, James Cameron <quozl@laptop.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Paul Bolle <pebolle@tiscali.nl>, Arnd Bergmann <arnd@arndb.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stefan Seyfried <seife+kernel@b1-systems.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 12:13 PM, Sergei Ianovich <ynvich@gmail.com> wrote:
> pxa2xx-uart was a separate uart platform driver. It was declaring
> the same device names and numbers as 8250 driver. As a result,
> it was impossible to use 8250 driver on PXA SoCs.
>
> Upon closer examination pxa2xx-uart turned out to be a clone of
> 8250_core driver.
>
> Workaround for Erratum #19 according to Marvel(R) PXA270M Processor
> Specification Update (April 19, 2010) is dropped. 8250_core reads
> from FIFO immediately after checking DR bit in LSR.
>
> Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Reviewed-by: James Cameron <quozl@laptop.org>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  Resenging together with the rest of the series as the series
>  breaks without this one at [PATCH 12/21]

Whatever happened with merging this? I'm asking because either this or
fixes to PXA uart are needed to coexist with the 8250 driver and for
earlycon to work.

Rob
