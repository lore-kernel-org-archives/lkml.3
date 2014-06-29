Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaF2XrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 19:47:03 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:34547 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbaF2XrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 19:47:01 -0400
MIME-Version: 1.0
In-Reply-To: <1401653003-10670-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1401653003-10670-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 30 Jun 2014 01:47:00 +0200
Message-ID: <CAFo99garLm9G6GBFP1a1ko3FAacukcTXMW1d_K--8ennW73KJw@mail.gmail.com>
Subject: Re: [PATCH] power: ab8500_fg.c: Cleaning up uninitialized variables
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Can someone please check on this!

This will cause an error, and is one of the most obvious ones I've found.
So give it one minute please.

Kind regards
Rickard Strandqvist


2014-06-01 22:03 GMT+02:00 Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se>:
> In this case the wrong variable is used, which has never been initialized.
> This will lead to a serious error.
>
> This was largely found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/power/ab8500_fg.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
> index 3cb4178..019e33f 100644
> --- a/drivers/power/ab8500_fg.c
> +++ b/drivers/power/ab8500_fg.c
> @@ -2969,7 +2969,7 @@ static struct device_attribute ab8505_fg_sysfs_psy_attrs[] = {
>
>  static int ab8500_fg_sysfs_psy_create_attrs(struct device *dev)
>  {
> -       unsigned int i, j;
> +       unsigned int j;
>         struct power_supply *psy = dev_get_drvdata(dev);
>         struct ab8500_fg *di;
>
> @@ -2986,7 +2986,7 @@ static int ab8500_fg_sysfs_psy_create_attrs(struct device *dev)
>  sysfs_psy_create_attrs_failed_ab8505:
>         dev_err(dev, "Failed creating sysfs psy attrs for ab8505.\n");
>         while (j--)
> -               device_remove_file(dev, &ab8505_fg_sysfs_psy_attrs[i]);
> +               device_remove_file(dev, &ab8505_fg_sysfs_psy_attrs[j]);
>
>         return -EIO;
>  }
> --
> 1.7.10.4
>
