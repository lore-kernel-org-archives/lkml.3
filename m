Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaDVIki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:40:38 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:49686 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbaDVIkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:40:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140422130655.51daec1807bde98ade65d691@canb.auug.org.au>
References: <20140422130655.51daec1807bde98ade65d691@canb.auug.org.au>
Date: Tue, 22 Apr 2014 10:40:32 +0200
Message-ID: <CAPDyKFqeEsDpamUksmgyEBhMN+xLih-Hv_bczbZv43m8ApHDvA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the mmc tree
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Chris Ball <chris@printf.net>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "John W. Linville" <linville@tuxdriver.com>,
        Fariya Fatima <fariyaf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 April 2014 05:06, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Chris,
>
> After merging the mmc tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> drivers/net/wireless/rsi/rsi_91x_sdio.c: In function 'rsi_reset_card':
> drivers/net/wireless/rsi/rsi_91x_sdio.c:288:20: error: 'MMC_STATE_HIGHSPEED' undeclared (first use in this function)
>     card->state &= ~MMC_STATE_HIGHSPEED;
>                     ^
> drivers/net/wireless/rsi/rsi_91x_sdio.c:288:20: note: each undeclared identifier is reported only once for each function it appears in
> drivers/net/wireless/rsi/rsi_91x_sdio.c:299:4: error: implicit declaration of function 'mmc_card_set_highspeed' [-Werror=implicit-function-declaration]
>     mmc_card_set_highspeed(card);
>     ^
> drivers/net/wireless/rsi/rsi_91x_sdio.c:306:2: error: implicit declaration of function 'mmc_card_highspeed' [-Werror=implicit-function-declaration]
>   if (mmc_card_highspeed(card))
>   ^
>
> Caused by commit 395784826a81 ("mmc: drop the speed mode of card's state").
>
> I have used the version of the mmc tree from next-20140417 for today.

Hi Chris,

Until we work out the dependency issue caused by the above commit,
could you please drop the following patches from your mmc-next
branch!?

df1a292 mmc: add support for HS400 mode of eMMC5.0
f27a5d7 mmc: rework selection of bus speed mode
e64f275 mmc: step power class after final selection of bus mode
6371adf mmc: identify available device type to select
3957848 mmc: drop the speed mode of card's state

Kind regards
Ulf Hansson

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
