Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaBMHlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 02:41:49 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:46782 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaBMHlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 02:41:46 -0500
MIME-Version: 1.0
In-Reply-To: <1392059868-8782-1-git-send-email-arend@broadcom.com>
References: <1392059868-8782-1-git-send-email-arend@broadcom.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Thu, 13 Feb 2014 15:41:25 +0800
X-Google-Sender-Auth: iq6jEr-lp8H0_0GLg6e5qdXRZPU
Message-ID: <CAGb2v66ib=6NK1OpYct_5Cs6V-89PNHpk69J++e6ph85etF6sw@mail.gmail.com>
Subject: Re: [RFC] dt: bindings: add bindings for Broadcom bcm43xx sdio devices
To: Arend van Spriel <arend@broadcom.com>
Cc: Rob Herring <robh+dt@kernel.org>, devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 3:17 AM, Arend van Spriel <arend@broadcom.com> wrote:
> The Broadcom bcm43xx sdio devices are fullmac devices that may be
> integrated in ARM platforms. Currently, the brcmfmac driver for
> these devices support use of platform data. This patch specifies
> the bindings that allow this platform data to be expressed in the
> devicetree.
>
> Cc: Chen-Yu Tsai <wens@csie.org>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> This devicetree binding proposal is intended for platforms with
> Broadcom wireless device in MMC sdio slot. These devices may
> have their own interrupt and power line. Also the SDIO drive
> strength is often hardware dependent and expressed in this
> binding.

Hi,

I believe the interrupts and drive-strength properties are Ok.
However, letting the platform driver power up the wifi chip does
not guarantee proper ordering, does it? I mean, what if the MMC
bus was probed before the (non-removable) chip was switched on?

Being able to tie that to the mmc controller would be better IMO.
I think this was discussed in Olof's "mmc: add support for
power-on sequencing through DT" thread.


Thanks!
ChenYu

>
> Not sure if this should go in staging or not. Feel free to
> comment on this proposal.
>
> Regards,
> Arend
