Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423322Ab3FUQYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:24:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52739 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423064Ab3FUQYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:24:36 -0400
Message-ID: <51C47E41.6050609@wwwdotorg.org>
Date: Fri, 21 Jun 2013 10:24:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lucas Stach <dev@lynxeye.de>
CC: Anna-Maria Gleixner <anna-maria@glx-um.de>, linux-tegra@vger.kernel.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM:tegra20-colibri-512.dts: Change tristate status for
 i2c pinmux
References: <alpine.DEB.2.02.1306202302210.11096@dionysos>
In-Reply-To: <alpine.DEB.2.02.1306202302210.11096@dionysos>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 03:08 PM, Anna-Maria Gleixner wrote:
> The nvidia,tristate entry for the pinmux of i2c1 an i2c3 was set to
> tristate. This results in non working i2c, because the i2c pins are
> not actively driven. Set the entries to "driven".

Lucas, can you please comment on this patch? It sounds correct to me,
but I would have assumed you'd tested I2C already when you wrote the
original DT?

Oh actually, now that I look further, I see that tegra20-iris-512.dts
includes this file, and overrides some of the tristate values there.
What's the thinking behind that, and does this patch fit into it?

> diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi

>                  nvidia,pins = "rm";
>                  nvidia,function = "i2c1";
>                  nvidia,pull = <0>;
> -                nvidia,tristate = <1>;
> +                nvidia,tristate = <0>;
>              };
>              i2c3 {
>                  nvidia,pins = "dtf";
>                  nvidia,function = "i2c3";
>                  nvidia,pull = <0>;
> -                nvidia,tristate = <1>;
> +                nvidia,tristate = <0>;
>              };
>              i2cddc {
>                  nvidia,pins = "ddc";

