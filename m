Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbaJ1PwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:52:06 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33716 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaJ1Pvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:51:52 -0400
MIME-Version: 1.0
In-Reply-To: <1413847670-12245-1-git-send-email-dianders@chromium.org>
References: <1413847670-12245-1-git-send-email-dianders@chromium.org>
Date: Tue, 28 Oct 2014 16:51:50 +0100
Message-ID: <CACRpkdZO+TuCodDzLZ2evRc0ak+4of38aKNqCiC5cMkm++keHw@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: rockchip: Set wake_enabled
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>, Heiko Stuebner <heiko@sntech.de>
Cc: Chris Zhong <zyw@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        linux-rockchip@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 1:27 AM, Doug Anderson <dianders@chromium.org> wrote:

> The rockchip pinctrl driver uses irq_gc_set_wake() but doesn't setup
> the .wake_enabled member.  That means that we can never actually use a
> pin for wakeup.  When "irq_set_irq_wake()" tries to call through it
> will always get a failure from set_irq_wake_real() and will then set
> wake_depth to 0.  Assuming you can resume you'll later get an error
> message about "Unbalanced IRQ x wake disable".
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Heiko, are you looking at this patch series? Need you Reviewed-by
to merge this stuff.

Yours,
Linus Walleij
