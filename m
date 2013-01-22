Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3AVKy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:54:57 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:54382 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab3AVKy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:54:56 -0500
MIME-Version: 1.0
In-Reply-To: <1358788568-11137-7-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
	<1358788568-11137-7-git-send-email-arnd@arndb.de>
Date: Tue, 22 Jan 2013 08:54:55 -0200
Message-ID: <CAOMZO5AON+FhTQpTbEdjwZaEaxsPoEVLeALhH2s34biWH_EeOA@mail.gmail.com>
Subject: Re: [PATCH 06/15] clk: export __clk_get_name
From: Fabio Estevam <festevam@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>, arm@kernel.org,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 3:15 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The __clk_get_name is used by drivers that provide their
> own clocks, which have traditionally all been built-in.
> The new imx drm driver however provides clocks but can
> be built as a module, so we need to export __clk_get_name.
>
> While this is only a staging driver, it's likely that
> there will be others like it in the future.
>
> Without this patch, building ARM allmodconfig results in:
>
> ERROR: "__clk_get_name" [drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.ko] undefined!
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Mike Turquette <mturquette@linaro.org>

A fix from Niels de Vos has already been applied into clk-next:
https://patchwork.kernel.org/patch/1871981/
