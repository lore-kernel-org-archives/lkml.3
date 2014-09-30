Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750809AbaI3Nns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:43:48 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:54415 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaI3Nnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:43:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Chen <peter.chen@freescale.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com,
        alexandre.belloni@free-electrons.com, p.zabel@pengutronix.de,
        jszhang@marvell.com, sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Tue, 30 Sep 2014 15:43:40 +0200
Message-ID: <10249326.XCThPmSrfL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140930123933.GA25395@peterchendt>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com> <3366285.QN2R3CQNzG@wuerfel> <20140930123933.GA25395@peterchendt>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Qvsdp8cYE3HJyTlg3Z/NY0iiTV6z0xq1G4p07NV5i8x
 WUtbo8oNDklgfpEiP9D/Un8FR7if4nmhnm0BFToeltRbkvKnL+
 Wyz6B9fWJXchwfCip/8pfhcB3phivdA3bcUF+WlK08o7ieSEu7
 oWH3GOoCVcRJXOzTZP41Tf3TY5lNFh7Xop9tVXe6pfgOgDwbMG
 7kyXrNerUZYoHfWlM8wB+uzHvoN4v3rkLrWY5f2SL/oapxfOzh
 W19BNPcdqzrtZ0/OLBxjMkqULqhjjATHkbkNj30mYX4nEq8S6P
 TQ7fsctReqa1fhcu4MceljN/3lBrLXVNyzRQYmEIbwqds5Oktf
 BC6ms0y3C53YlJwMPw5c=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 20:39:34 Peter Chen wrote:
> Thanks, Arnd. I had not thought setting dma mask is so complicated, yes, it
> should check the return value, two things to confirm:
> 
> - dma_coerce_mask_and_coherent or dma_set_mask_and_coherent, the only difference
> of these two API is the first one do "dev->dma_mask = &dev->coherent_dma_mask;"
> The reason you suggest choosing dma_set_mask_and_coherent is you do not want
> assign dev->dma_mask?

No, that is just the current definition on ARM32 with CONFIG_ARCH_MULTIPLATFORM, and
that is going to change soon to be DT aware.
dma_set_mask_and_coherent() is supposed to check whether the platform can support
the respective mask and return an error if it cannot.

> - The second parameter for dma_set_mask_and_coherent is DMA_BIT_MASK(32), is it
> ok?
> 
> I just a little confused of what's the operation is "hardcoding the dma mask"?

dma_coerce_mask_and_coherent() will hardcode the dma mask and override whatever
the platform says is necessary.

	Arnd
