Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaBYJoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:44:05 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:58479 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbaBYJoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:44:00 -0500
MIME-Version: 1.0
In-Reply-To: <1393311470-11526-1-git-send-email-acourbot@nvidia.com>
References: <1393311470-11526-1-git-send-email-acourbot@nvidia.com>
Date: Tue, 25 Feb 2014 15:13:59 +0530
Message-ID: <CAK9yfHx-gMzJb=OgaMXQ3esKx1n0fFA-+nNMcLrF5e6ajd+n7w@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: allow enabling without enable op
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Mark Brown <broonie@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Markus Pargmann <mpa@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 February 2014 12:27, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Commit 14c32a3ce6676265d7a27ea64a4d406e6dbad111 replaced direct uses of
> ops->enable by calls to _regulator_do_enable. This prevents a fixed
> regulators without a GPIO from being probed, since the former code
> checked the existence of ops->enable and continued if it did not exist,
> while _regulator_do_enable return -EINVAL in that case.
>
> This patch fixes this by allowing _regulator_do_enable to go through
> without error if ops->enable is not defined, similarly to what
> _regulator_do_disable already does.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

This patch fixes the fixed regulator registration failure on Exynos5420 board.

Tested-by: Sachin Kamat <sachin.kamat@linaro.org>

-- 
With warm regards,
Sachin
