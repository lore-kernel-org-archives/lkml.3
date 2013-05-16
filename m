Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab3EPSSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:18:15 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64488 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3EPSSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:18:12 -0400
MIME-Version: 1.0
In-Reply-To: <5194FCDD.8080209@ti.com>
References: <1368636386-17138-1-git-send-email-dmurphy@ti.com>
	<20130515170516.GA6135@kahuna>
	<5194FCDD.8080209@ti.com>
Date: Thu, 16 May 2013 13:18:10 -0500
X-Google-Sender-Auth: E8pPQ7L9Sul-GraqKX3eyHpIh4s
Message-ID: <CAGo_u6pX+DdVNWqdPXDChzMr27YAXL_Zvt7DxWBijOCW0rXpkA@mail.gmail.com>
Subject: Re: [PATCH v4] ARM:dts:omap4-panda: Update the LED support for the
 panda DTS
From: Nishanth Menon <nm@ti.com>
To: Dan Murphy <dmurphy@ti.com>
Cc: =?ISO-8859-1?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-omap <linux-omap@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 10:35 AM, Dan Murphy <dmurphy@ti.com> wrote:
> I am not sure you really want to do this.
> If I make the pinctrl part of the led structure then the only way the gpio_wk7 on a1-a3 to be configured is when
> the CONFIG_LEDS_GPIO flag is set.
>
> Do you really want that dependency?  You did say it was a key fix
> At least this way the pins are configured regardless of that flag.

That is better as the system will be left in the pinmux configuration
handed over from bootloader.

The point being, muxing up pins even when not needed(config switched
off) has no real benefit - in this case albeit, the default mux was
causing a bug.
pinctrl IMHO should be considered as any other resource, if it is not
mandatory for boot, and needed only for a device functionality when
probed, it should done there only.

just my 2 cents.
