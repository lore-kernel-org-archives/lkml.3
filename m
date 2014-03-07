Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaCGQKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:10:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:52492 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaCGQKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:10:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH 3/7] of: introduce of_dma_is_coherent() helper
Date: Fri, 7 Mar 2014 17:09:11 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
References: <1394097598-17622-1-git-send-email-santosh.shilimkar@ti.com> <CAL_JsqJ3QhRRNVAsvAPP=Ex_ptQcbpCXh7pf44K1xh+scFqiug@mail.gmail.com> <531948A8.9040106@ti.com>
In-Reply-To: <531948A8.9040106@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403071709.11568.arnd@arndb.de>
X-Provags-ID: V02:K0:9JxmDDPxE2bB6rZjZQz1pvx9l+CfAl1Z56i/ZNkQGOe
 Rg7KjPJTgYCvsvI7vF78X7+HzOKK4OqA0EvcD/E4DXvVLLXOKN
 ZFWUkZA9cpjoAnEybrVA/D9CFMqJynwnC8YG2MstRqPCrMSVXY
 GNYgsWfga4YrHT6/ACRd9zSBgfpL4Z4+DVGkYaT05P2QRQoCz8
 8LRf21COYukbLwNOIXGn3YM2cJvQo/D1DemkNNwkeJrus54FIu
 R8Sc1waQI9EkCwqKvwx/V+DOZJxo8hsXG/0UBbqp4DtMZHx9vY
 vvwD6TAy8nSElVGHi++TFt9Ck6zpoIFbvGzjYutP80QpMC8spS
 MQxXDFQff4tRVaZ4ZPV0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 March 2014, Santosh Shilimkar wrote:
> On Friday 07 March 2014 11:55 AM, Rob Herring wrote:
>
> > Thinking about this some more, if the arch is always coherent or
> > always non-coherent, then the default ops are always fine. In that
> > case set_arch_dma_coherent_ops is always a nop and of_dma_is_coherent
> > is a don't care.
> > 
> Hmmm.. I guess you are right. In that case we can drop the need of
> config option.

A compile-time config option clearly would not work here, because it
breaks multiplatform support when some platforms are different from
others. I can still see the possible need for a global run-time setting
though, to give some platform init code the ability to override the
DT flags when it knows better. That is probably what you want to do
on keystone without LPAE.

	Arnd
