Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaFZW5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 18:57:06 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:35454 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaFZW5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 18:57:05 -0400
MIME-Version: 1.0
In-Reply-To: <1403822608-31158-1-git-send-email-gregory.clement@free-electrons.com>
References: <1403822608-31158-1-git-send-email-gregory.clement@free-electrons.com>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 26 Jun 2014 17:56:43 -0500
Message-ID: <CAL_JsqL9w0oxxM0zTAVioh0Uf3PNO3TfhxzOLV6KhBOoS4Fdiw@mail.gmail.com>
Subject: Re: [PATCH 0/5] ARM: Centralize the access to the SCU register
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nadav Haklai <nadavh@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 5:43 PM, Gregory CLEMENT
<gregory.clement@free-electrons.com> wrote:
> Hello,
>
> Following the feedback I go on the patch "ARM: mvebu: Enable SCU
> Speculative linefills to L2 for Armada 375/38x" :
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/335961/focus=335993
>
> I take the opportunity of adding new functions in smp_scu.c to
> centralize the other access done on the SCU register from C file in
> this file.
>
> The first patch is a preliminary clean-up in smp_scu.c.
>
> The second and the third patches add functions to manipulate the SCU
> control register.
>
> The forth patch use the new scu_spec_linefills_enable()
> function. Enabling SCU Speculative linefills to L2 for Armada 375/38x
> was the reason of this series.
>
> The last patch removed a direct access to the SCU register by an
> access through the new scu_standby_enable() function. For this one I
> have just checked that the kernel can be built using the
> imx_v6_v7_defconfig config, but I didn't test it on an imx6 hardware.

Why would we not just turn on these 2 features unconditionally? If we
don't know of any platform where they are broken, then we should just
enable them. We can add these functions only if necessary later.

Rob
