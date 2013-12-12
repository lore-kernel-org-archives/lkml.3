Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab3LLUHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:07:17 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:39718 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3LLUHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:07:14 -0500
MIME-Version: 1.0
In-Reply-To: <CA+E=qVc4pNU_e5YjUZX7hG21FzS3omdd1XvgwFcHQy2z_Mnm8A@mail.gmail.com>
References: <1385879185-22455-3-git-send-email-ynvich@gmail.com>
	<1386348542-9584-1-git-send-email-ynvich@gmail.com>
	<CACRpkdYVsGSyMS6sSTqqJ4XrE3GqpWkJsY7GDazi5ix7xjKQ=Q@mail.gmail.com>
	<CA+E=qVc4pNU_e5YjUZX7hG21FzS3omdd1XvgwFcHQy2z_Mnm8A@mail.gmail.com>
Date: Thu, 12 Dec 2013 21:07:13 +0100
Message-ID: <CACRpkdZpwPhscWG_j-BM9bRZL-J7dRoX4=Q+Eo5Td9We6qvH0w@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] arm: pxa27x: support ICP DAS LP-8x4x
From: Linus Walleij <linus.walleij@linaro.org>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Sergei Ianovich <ynvich@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 1:54 PM, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> On Tue, Dec 10, 2013 at 3:43 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

>> Argh! Now you're adding another user for a legacy custom pin control
>> implementation. But if noone is going to modernize PXA2xx what
>> can we do :-/
>
> I tried a ~year ago, but it's not so trivial. PXA2xx has no separate
> pin control module, it's
> highly integrated into GPIO controller. I've asked the maillist what
> should I do for that case, but AFAIR no one answered.

It is very common for pin controllers and GPIO blocks to
be integrated.

The usual solution is to make a combined driver that registers
both pinctrl and GPIO interfaces and put that into
drivers/pinctrl.

Here is a recent example that can be used as inspiration:
http://marc.info/?l=linux-doc&m=138629591206248&w=2

Yours,
Linus Walleij
