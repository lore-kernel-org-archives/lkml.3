Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab3GUOpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 10:45:25 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:64145 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3GUOpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 10:45:24 -0400
MIME-Version: 1.0
In-Reply-To: <1372842992-18712-1-git-send-email-broonie@kernel.org>
References: <1372842992-18712-1-git-send-email-broonie@kernel.org>
Date: Sun, 21 Jul 2013 16:45:23 +0200
Message-ID: <CACRpkdY4MEJyY4w42yEStYUg+yMeP3uekVVi31nSd-90fOo1HA@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab8500: Provide map_voltage() functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 11:16 AM, Mark Brown <broonie@kernel.org> wrote:

> From: Mark Brown <broonie@linaro.org>
>
> Since all the voltage tables for ab8500 are sorted in ascending order we
> can improve performance by using regulator_map_voltage_ascend(). A couple
> of the regulators can actually use linear maps which would be even better.
>
> Signed-off-by: Mark Brown <broonie@linaro.org>

Hm. Have you looked closer at this one voltage table in this driver:

static const unsigned int ldo_vaux56_voltages[] = {
    1800000,
    1050000,
    1100000,
    1200000,
    1500000,
    2200000,
    2500000,
    2790000,
};

Or this one:

static const unsigned int ldo_sdio_voltages[] = {
    1160000,
    1050000,
    1100000,
    1500000,
    1800000,
    2200000,
    2910000,
    3050000,
};

Yours,
Linus Walleij
