Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbbAHTZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 14:25:05 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:49026 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377AbbAHTZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 14:25:03 -0500
MIME-Version: 1.0
In-Reply-To: <1419274049-5069-1-git-send-email-dianders@chromium.org>
References: <1419274049-5069-1-git-send-email-dianders@chromium.org>
Date: Thu, 8 Jan 2015 20:25:02 +0100
Message-ID: <CACRpkdYOqbsTgNMx8n_NmAe2vtfx+mGRGpw3zUCqjsrFiH0ZVw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: rockchip: Avoid losing interrupts when
 supporting both edges
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Alexandru Stan <amstan@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 7:47 PM, Doug Anderson <dianders@chromium.org> wrote:

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

Patch applied for fixes.

Yours,
Linus Walleij
