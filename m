Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab3LLOke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:40:34 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:61872 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3LLOkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:40:33 -0500
MIME-Version: 1.0
In-Reply-To: <52A5938E.40201@free-electrons.com>
References: <1386421734-10240-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1386421734-10240-2-git-send-email-alexandre.belloni@free-electrons.com>
	<52A57E55.40808@atmel.com>
	<52A5938E.40201@free-electrons.com>
Date: Thu, 12 Dec 2013 15:40:32 +0100
Message-ID: <CACRpkdbxq-w8KquMjQVSbkEZcsMLsSRc3BqfuLLDM7c1P3UOxw@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: at91: initialize config parameter to 0
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 10:55 AM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:

> I'm actually wondering if the checks for the ops->pin_config_get are not
> a bit overkill. We check for that function in:
>  - pinconf_check_ops()
>  - before calling it in pin_config_get_for_pin() which is only used
> once, in the same path : dump using debugfs and having ops->is_generic
> == true
>  - in pinconf_pins_show() which is the function calling also in the same
> path
>
> What I would do is:
>  - remove all the checks in pinconf_check_ops() and pinconf_pins_show()
> so that people are not pressured to implement a function that is simply
> never used.
>  - modify pin_config_get_for_pin() by removing the dev_err() call and
> returning -ENOTSUPP instead of -EINVAL (it doesn't change the behaviour
> but I feel -ENOTSUPP is more appropriate)
>
> I have a patch ready but I can't test it as I don't own any of the
> is_generic platforms.

Mail it out with a [CFT: ] "call for testing" prefix.

Yours,
Linus Walleij
