Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaBXJtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:49:55 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:55270 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBXJty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:49:54 -0500
MIME-Version: 1.0
In-Reply-To: <1391114256.2422.71.camel@joe-AO722>
References: <1391108240-16161-1-git-send-email-broonie@kernel.org>
	<1391108694.2422.59.camel@joe-AO722>
	<1391114256.2422.71.camel@joe-AO722>
Date: Mon, 24 Feb 2014 10:49:53 +0100
Message-ID: <CACRpkdYxDu-vZLpc3Ef-2q1B3wpHqnuJofRwhA332Qw4pw39vg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Avoid kasprintf/kfree
From: Linus Walleij <linus.walleij@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 9:37 PM, Joe Perches <joe@perches.com> wrote:

> Avoid an unnecessary allocation/free by using stack instead.
>
> Signed-off-by; Joe Perches <joe@perches.com>

Hm.

> +       char propname[9 + sizeof(int) * 2 + 4] = "pinctrl-";

If you absolutely want to do this you have to

#define PINCTRL_PREFIX "pinctrl-"

char propname[strlen(PINCTRL_PREFIX) + sizeof(int)*2 + 4] = PINCTRL_PREFIX;

Then add a comment above stating why you add 4.

> This allocation seems unnecessary and the kasprintf isn't
> checked for non-null, so maybe this is better.

Another option would be to just add a NULL-check? This is
definately not on a performance-critical path.

Yours,
Linus Walleij
