Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbaIVQVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:21:06 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:55961 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbaIVQVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:21:03 -0400
From: Max Schwarz <max.schwarz@online.de>
To: Chris Zhong <zyw@rock-chips.com>
Cc: linux-rockchip@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>,
        Wolfram Sang <wsa@the-dreams.de>, dianders@chromium.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] i2c-rk3x: move setup to the earlier subsys initcall
Date: Mon, 22 Sep 2014 18:20:20 +0200
Message-ID: <2856441.ivW6yi69vh@xq-nb>
User-Agent: KMail/4.13.3 (Linux/3.17.0-031700rc4-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <7192455.FveG5nGWsJ@xq-nb>
References: <1411370675-27866-1-git-send-email-zyw@rock-chips.com> <7192455.FveG5nGWsJ@xq-nb>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nlOqZHOOSM4ZZ2cTJ58mYpBvG9k0hzmOKjoQ08tkVII
 Yi6i/NmROvIQdV9zssl9ZHCcXCQqk6UWcP01rLchNNdx2MAubT
 DFfV8nl7hUNtLVefL9ecjSze6aBw9bzNBmhknmRofpFzM36bn9
 xG7pUc9ZCKYXRbiSW5aVKksECNjg1yibxi3pma6oYUSzysxtZO
 dUVrwsFZh7AwGXcxpjaAH3KwX+E/+PCRb1WVxvvK1oRzZnAblH
 Mb/o7Tgndr3uyYxsrx9CMmICTMqpEAXQ/NSkyz5ZeHTmpjj1Z9
 fOv7XkH+lEsqK6CaR9zwGH0EsL8wLA45/Qh7yIUYzxsHm0vSoF
 o6liKBRW6zy3u6sLSHRc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

> > +subsys_initcall(rk3x_i2c_init_driver);
> > +module_exit(rk3x_i2c_exit_driver);
> 
> This means that the driver cannot be used as a loadable module any more,
> right?
> 
> In that case, you should probably turn the tristate option in Kconfig into a
> bool.

I'm sorry, I see now that subsys_initcall() gets mapped to module_init() if 
the driver is built as a loadable module. Everything is fine ;-)

Acked-By: Max Schwarz <max.schwarz@online.de>

Cheers,
  Max
