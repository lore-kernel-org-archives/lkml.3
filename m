Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaLQGUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 01:20:51 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:34273 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLQGUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 01:20:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAJAp7OhWKoAoZfq+zWspLnqUkoJb3izMD41Vyfn0AW4Jni8HAQ@mail.gmail.com>
References: <54584260.8030602@nvidia.com>
	<CAD7vxxKb668Y0hpYRhwMjQnNrDCQMzn=XGtLEU+ZAtY=OFjHLg@mail.gmail.com>
	<545895B2.2000101@nvidia.com>
	<CAD7vxxLmLsRpxrYqc30nV0m6atO7jyNgv1Wh4R8GCAy3+y-1dw@mail.gmail.com>
	<CAJAp7OgmrEX1XQcwvwf4jzW3eK9TUgde2MQQOp7fOJzvmO=tCQ@mail.gmail.com>
	<CAD7vxxJaCdKiG9h_32OUSUkQMQk6AAwi6d0v01KEnSVTF8cN1w@mail.gmail.com>
	<CAJAp7Oh+ziadeEDWsus_k_2w33vPJxGGcGZyMNQkpLemf7SAhg@mail.gmail.com>
	<CAJAp7OhWKoAoZfq+zWspLnqUkoJb3izMD41Vyfn0AW4Jni8HAQ@mail.gmail.com>
Date: Tue, 16 Dec 2014 22:20:49 -0800
Message-ID: <CAD7vxxLe5COSrsnVZ2G_uhtUXfjFnDA45HSG2dNT1LrxcyFcQw@mail.gmail.com>
Subject: Re: Possible regression with commit 52221610d
From: Tim Kryger <tim.kryger@gmail.com>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sachin Kamat <spk.linux@gmail.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 10:18 AM, Bjorn Andersson <bjorn@kryo.se> wrote:

> We are routing the regulators straight to vdd of the memory and should
> hence use vmmc to specify this. However unless I actually program 0x29
> in the Qualcomm sdhci block I get no responses from the card.
>
> Which I believe is correct behavior as the SDHC specification [1] says
> the following about BIT(0) of 0x29:
>
> "If this bit is cleared, the Host Controller shall immediately stop
> driving CMD and DAT[3:0] (tri-state) and drive SDCLK to low level".
>
>
> So I think 52221610d is indeed incorrect.
>
> [1] https://www.sdcard.org/downloads/pls/simplified_specs/archive/partA2_300.pdf

Agreed.  Host controllers that fail to implement the required internal
regulator configured via bits 1-3 of the Power Control Register may
still follow the specification with regard to bit zero of that same
register.  The driver should be updated to configure bit zero
appropriately even when an external regulator is used.

If you like, I can propose a patch or if you have one ready, I will be
happy to review yours.

Thanks,
Tim Kryger
