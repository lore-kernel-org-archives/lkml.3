Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab3FQQ4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:56:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:32870 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3FQQ4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:56:36 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZT_jvUzMmOrmwLOR5Gc2TWEp85kWa+yyMAp1bG3xrWXw@mail.gmail.com>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
	<1371141522-29255-3-git-send-email-dianders@chromium.org>
	<CACRpkdZT_jvUzMmOrmwLOR5Gc2TWEp85kWa+yyMAp1bG3xrWXw@mail.gmail.com>
Date: Mon, 17 Jun 2013 18:56:36 +0200
Message-ID: <CACRpkdZcc8a1zG446jKRDyKr2Cpu2tV1J52gwSOhL2NcUDyAwA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] pinctrl: exynos: ack level-triggered interrupts
 before unmasking
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Ilho Lee <ilho215.lee@samsung.com>, Eunki Kim <eunki_kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 8:20 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Jun 13, 2013 at 6:38 PM, Doug Anderson <dianders@chromium.org> wrote:
>
>> A level-triggered interrupt should be acked after the interrupt line
>> becomes inactive and before it is unmasked, or else another interrupt
>> will be immediately triggered.  Acking before or after calling the
>> handler is not enough.
>>
>> Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>> Changes in v2:
>> - Greatly simplified using Tomasz's suggestion of irqd_get_trigger_type
>> - Moved acking out of the bank spinlock since since it's not needed.
>> - Linus W. has already applied parts 1 and 2, so not resending.
>
> Thanks, this v2 version applied with Tomasz ACK.

As noted this thing exploded due to patch fuzzing.

Could you respin this on top of my "devel" branch?

Yours,
Linus Walleij
