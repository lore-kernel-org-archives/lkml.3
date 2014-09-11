Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaIKJqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:46:12 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:33586 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaIKJqJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:46:09 -0400
MIME-Version: 1.0
In-Reply-To: <54114362.2080709@neotion.com>
References: <53C7E45E.2060102@neotion.com>
	<CAPDyKFoRpQBHGGCMPvEKdeVGjTO-rnyYVostLZGCV3dudD1rmA@mail.gmail.com>
	<53EB2DC3.2080002@neotion.com>
	<CAPDyKFpjYqVUZ8GHB76gD8pOx_eMg9ecvbWrMEfbhEd5ffk7mw@mail.gmail.com>
	<53ECB95F.2030207@neotion.com>
	<CAPDyKFp2ekmucHVzMWxeKfyTmuFKTXAYwUEpL5QxvEh8AjFopg@mail.gmail.com>
	<53F1FBA3.6060108@neotion.com>
	<54114362.2080709@neotion.com>
Date: Thu, 11 Sep 2014 11:46:08 +0200
Message-ID: <CAPDyKFpj_c+9boHTQZo1Mr0OEv+7rd4m9LXVDKdj7quL-LMa1A@mail.gmail.com>
Subject: Re: [PATCH v4 0002/0003] mmc: Replace "enhanced_area_en" attribute by "partition_setting_completed"
From: Ulf Hansson <ulf.hansson@linaro.org>
To: =?UTF-8?B?R3LDqWdvcnkgU291dGFkw6k=?= <gsoutade@neotion.com>
Cc: Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2014 08:38, Grégory Soutadé <gsoutade@neotion.com> wrote:
> Replace ext_csd "enhanced_area_en" attribute by
>  "partition_setting_completed". It was used whether or
>  not enhanced user area is defined and without checks of
>  EXT_CSD_PARTITION_SETTING_COMPLETED bit.
>
> Signed-off-by: Grégory Soutadé <gsoutade@neotion.com>

This patch doesn't compile.

I also think you could work a bit on the commit messages in this
patchset. Try to describe what the patches do and why. I may help you
- if you like.

> ---
>  drivers/mmc/core/mmc.c   |    9 ++++++++-
>  include/linux/mmc/card.h |    2 +-
>  include/linux/mmc/mmc.h  |    2 ++
>  3 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 77b4cf3..3578e35 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -488,6 +488,13 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
>                 ext_csd[EXT_CSD_TRIM_MULT];
>         card->ext_csd.raw_partition_support = ext_csd[EXT_CSD_PARTITION_SUPPORT];
>         if (card->ext_csd.rev >= 4) {
> +               if (ext_csd[EXT_CSD_PARTITION_SETTING_COMPLETED] &
> +                   EXT_CSD_PART_SETTING_COMPLETED) {

No need for brackets if this if-else, please remove.

> +                       card->ext_csd.partition_setting_completed = 1;
> +               } else {
> +                       card->ext_csd.partition_setting_completed = 0;
> +               }
> +
>                 mmc_manage_enhanced_area(card, ext_csd);
>
>                 mmc_manage_gp_partitions(card, ext_csd);

[...]

Kind regards
Uffe
