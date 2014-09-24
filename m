Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaIXMY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:24:29 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:62795 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaIXMY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:24:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Chen <peter.chen@freescale.com>
Cc: balbi@ti.com, Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, sebastian.hesselbarth@gmail.com,
        p.zabel@pengutronix.de, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Wed, 24 Sep 2014 14:23:38 +0200
Message-ID: <2786668.t3YLqX5enD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140924112902.GA23331@peterchendt>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com> <2923729.dtX0WmHSV0@wuerfel> <20140924112902.GA23331@peterchendt>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:dVmv6kiRx/95nKOrApauZjhlN9c07dFJRUwv4i42pst
 iMWld1roUEWlpyrQkzusJX+16d4xdfrqZukrIbidzFPnLYAUYm
 S99pwJ7P3N7OhafuKJVYM6yYpEW+f2mtLmdJkWgSY/r3yyN8UP
 iG9OkMoydMENzsxhOJrEL7Fh3Co0Tjbd4rtXP59lMuyuvvXABr
 mhSpgO8Er1zgNDI7x3m5BStd9hyDgS4uoOYtZMOltzyry0a5qR
 SgdaE/V44BmFZnj793SijjhdqKy7AMuXpHQTCQ6NElPDRMc6s7
 cMO/yoMR/mgta8AEuyKaZ05i89q+aJbcR+nF8yQQfRYe4kA6r7
 WFT3+4gRDRJvRBZSvUt4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2014 19:29:05 Peter Chen wrote:
> 
> So, it is IP CORE LIB (you suggest) vs IP CORE Platform Driver
> (dwc3, musb, chipidea) you are talking about, right? Except for
> creating another platform driver as well as related DT node (optional),
> are there any advantages compared to current IP core driver structure?

Having a library module usually requires less code, and is more consistent
with other drivers, which helps new developers understand what the
driver is doing.

The most important aspect though is the DT binding: once the structure
with separate kernel drivers leaks out into the DT format, you can't
easily change the driver any more, e.g. to make a property that was
introduced for one glue driver more general so it can get handled by
the common part. Having a single node lets us convert to the library
model later, so that would be a strong reason to keep the DT binding
simple, without child nodes.

Following that logic, it turns into another reason for using the library
model to start with, because otherwise the child device does not have
any DT properties itself and has to rely on the parent device properties,
which somewhat complicates the driver structure.

> In this thread, we are talking about creating common platform driver for glue
> layer, its design purpose (adapt it for as many as platforms) should be the
> same, no matter the IP core part is a LIB or platform driver, am I missing
> something?

No, you are absolutely right with that, introducing the generic glue
driver is orthogonal to the structure of the core driver in principle.

I mainly brought it up because I noticed how this patch could be done
in a simpler way by combining the new generic glue with the move to
a library driver model.

	Arnd
