Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761975Ab3DBKNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:13:55 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:54478 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761943Ab3DBKNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:13:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAL0eWdGjPKUUcm6mStAHgHKHLABmPw7nMwDhR8D5rbvg+DPzfQ@mail.gmail.com>
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com>
	<1363224194-7366-1-git-send-email-ynvich@gmail.com>
	<87620jmkoe.fsf@octavius.laptop.org>
	<CAPDyKFp27MUOjhydLXf92vN3cua=XcX4oTJnMGfOJPpBhtwM8Q@mail.gmail.com>
	<CAL0eWdGjPKUUcm6mStAHgHKHLABmPw7nMwDhR8D5rbvg+DPzfQ@mail.gmail.com>
Date: Tue, 2 Apr 2013 12:13:49 +0200
Message-ID: <CAPDyKFroki00+SCLjUXYN_=+qcVZwZ2H4NJacH+d8p3dFXoLPg@mail.gmail.com>
Subject: Re: [PATCH v2] wait while adding MMC host to ensure root mounts
From: Ulf Hansson <ulf.hansson@linaro.org>
To: =?UTF-8?B?0KHQtdGA0LPQtdC5INCv0L3QvtCy0LjRhw==?= <ynvich@gmail.com>
Cc: Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 March 2013 13:28, Сергей Янович <ynvich@gmail.com> wrote:
> Hi Ulf,
>
> On 27 March 2013 15:13, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> Moreover, this patch will have bad impact on booting the kernel, since
>> every host device that has scheduled a detect work from it's probe
>> function will also wait for it to finish. Even if it is the boot
>> device of not. If this is needed, I would prefer that a host cap is
>> used.
>
> Do you have any profiling data supporting bad impact on boot?
>
> It should be it in the range of dozens us, if any. Without the patch,
> approx. 30% of boots succeeded with CONFIG_PREEMT and aprox. 95%
> without CONFIG_PREEMT. mmc_rescan is just a few instructions, if there
> is no card present. On boot and with a card present, it might only
> sleep in the host implementation.
>
> Anyway, something had to be done about mmc boot. rootdelay will not
> report error if the card is absent or its partition table is damaged.
> rootdelay is a workaround by definition, so it may occasionally fail
> if it is too small. Big rootdealy has a clear bad impact on boot time.

Consider a platform having two eMMCs and one SD-card. Each eMMC card
will take around 400 ms to initialize and the SD-card 700 ms. The card
initialization times are real examples from eMMCs and SD-cards,
moreover those are typical values not worth cases. In total we have
around 1.5 s to initialize the cards.

Now, suppose you boot using an initrd image. Thus neither of the cards
needs to be accessible immediately after the kernel has booted. It all
depends what the init process decides to do. With this patch the init
process will always be delayed to wait for each and every card to be
initialized. I would prefer a solution where this can be configurable
somehow, since certainly this is not the scenario you want for all
cases.

Kind regards
Ulf Hansson
