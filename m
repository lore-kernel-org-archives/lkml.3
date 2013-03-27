Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3C0M2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:28:34 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:48815 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab3C0M2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:28:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFp27MUOjhydLXf92vN3cua=XcX4oTJnMGfOJPpBhtwM8Q@mail.gmail.com>
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com>
	<1363224194-7366-1-git-send-email-ynvich@gmail.com>
	<87620jmkoe.fsf@octavius.laptop.org>
	<CAPDyKFp27MUOjhydLXf92vN3cua=XcX4oTJnMGfOJPpBhtwM8Q@mail.gmail.com>
Date: Wed, 27 Mar 2013 16:28:31 +0400
Message-ID: <CAL0eWdGjPKUUcm6mStAHgHKHLABmPw7nMwDhR8D5rbvg+DPzfQ@mail.gmail.com>
Subject: Re: [PATCH v2] wait while adding MMC host to ensure root mounts
From: =?UTF-8?B?0KHQtdGA0LPQtdC5INCv0L3QvtCy0LjRhw==?= <ynvich@gmail.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On 27 March 2013 15:13, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> Moreover, this patch will have bad impact on booting the kernel, since
> every host device that has scheduled a detect work from it's probe
> function will also wait for it to finish. Even if it is the boot
> device of not. If this is needed, I would prefer that a host cap is
> used.

Do you have any profiling data supporting bad impact on boot?

It should be it in the range of dozens us, if any. Without the patch,
approx. 30% of boots succeeded with CONFIG_PREEMT and aprox. 95%
without CONFIG_PREEMT. mmc_rescan is just a few instructions, if there
is no card present. On boot and with a card present, it might only
sleep in the host implementation.

Anyway, something had to be done about mmc boot. rootdelay will not
report error if the card is absent or its partition table is damaged.
rootdelay is a workaround by definition, so it may occasionally fail
if it is too small. Big rootdealy has a clear bad impact on boot time.
