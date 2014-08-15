Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaHOFgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 01:36:21 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:57103 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaHOFgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 01:36:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140814151958.GY17528@sirena.org.uk>
References: <1408019940-11153-1-git-send-email-javier.martinez@collabora.co.uk>
	<CAD7vxxKvzxvmzgx=S5ZZn54ts99ca2TqBYFvY1SXZQZDkhjq3w@mail.gmail.com>
	<20140814151958.GY17528@sirena.org.uk>
Date: Thu, 14 Aug 2014 22:36:18 -0700
Message-ID: <CAD7vxxLHtk2ywHGoBtDp6x3-5BtDdaFnCdc_pfgMwq63Cg8Qow@mail.gmail.com>
Subject: Re: [PATCH 1/1] mmc: core: Use regulator_get_voltage() if OCR mask is empty.
From: Tim Kryger <tim.kryger@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Haijun Zhang <Haijun.Zhang@freescale.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 8:19 AM, Mark Brown <broonie@kernel.org> wrote:

> Right, there's two things going on here.  One is that as you describe we
> shouldn't be putting constraints in .dtsi files if we don't know they're
> OK for a given board.  The other thing is that on this particular board
> it turns out that there's no support for varying the voltages at all so
> it doesn't make sense to have to specify a range, there's only one value
> anyway so the software really should be able to figure out that fixed
> value all by itself.

If constraints are truly irrelevant when the voltage supplied to
consumers is fixed, why doesn't regulator_list_voltage honor this
exemption and skip the voltage filtering that uses (potentially
unspecified) constraints when output is entirely determined by a
parent (or grandparent) supply that can't change its voltage?

It seems odd to make callers be the ones to handle this subtlety.

Thanks,
Tim Kryger
