Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaKCJnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:43:52 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:46893 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaKCJnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:43:47 -0500
MIME-Version: 1.0
In-Reply-To: <3D00ADB3-00B3-40A8-8263-444BCADDAC33@gmail.com>
References: <1413922198-29373-1-git-send-email-bparrot@ti.com>
	<3D00ADB3-00B3-40A8-8263-444BCADDAC33@gmail.com>
Date: Mon, 3 Nov 2014 10:43:46 +0100
Message-ID: <CACRpkda-HbKmN_RisHpWRV4bquwpBsd4RgaA5pW0qXrhYChRYA@mail.gmail.com>
Subject: Re: [RFC Patch] gpio: add GPIO hogging mechanism
From: Linus Walleij <linus.walleij@linaro.org>
To: Pantelis Antoniou <pantelis.antoniou@gmail.com>
Cc: Benoit Parrot <bparrot@ti.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 9:53 AM, Pantelis Antoniou
<pantelis.antoniou@gmail.com> wrote:

> 3) I’m not very fond of having this being part of the gpio controller. This
> configuration conceptually has little to do with the gpio controller per se,
> it is more of a board specific thing. Why not come up with a gpio-hog driver that
> references GPIOs? That way with a single gpio-hog driver instance you could setup
> all the GPIO-hogging configuration for all GPIOs on the board, even one that
> lie on different GPIO controllers.

You have a point. But it's vital that we set up hogs at the same time as the
gpio_chip is probed, not later, or there may be a race as to who
gets the GPIO line, and that should be avoided at any cost.

Yours,
Linus Walleij
