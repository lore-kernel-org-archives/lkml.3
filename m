Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaL0S3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 13:29:33 -0500
Received: from gloria.sntech.de ([95.129.55.99]:60259 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbaL0S3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 13:29:32 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandru Stan <amstan@chromium.org>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: rockchip: Avoid losing interrupts when supporting both edges
Date: Sat, 27 Dec 2014 19:29:23 +0100
Message-ID: <6699676.mHhQhT5KAT@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1419274049-5069-1-git-send-email-dianders@chromium.org>
References: <1419274049-5069-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 22. Dezember 2014, 10:47:29 schrieb Doug Anderson:
> I was seeing cases where I was losing interrupts when inserting and
> removing SD cards.  Sometimes the card would get "stuck" in the
> inserted state.
> 
> I believe that the problem was related to the code to handle the case
> where we needed both rising and falling edges.  This code would
> disable the interrupt as the polarity was switched.  If an interrupt
> came at the wrong time it could be lost.
> 
> We'll match what the gpio-dwapb.c driver does upstream and change the
> interrupt polarity without disabling things.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Reviewed-by: Heiko Stuebner <heiko@sntech.de>
on a rk3188 board with the edge triggered power-button
Tested-by: Heiko Stuebner <heiko@sntech.de>


Heiko
