Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaHTNdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:33:19 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:32850 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaHTNdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:33:18 -0400
MIME-Version: 1.0
In-Reply-To: <1402628655-2904-1-git-send-email-nickkrause@sympatico.ca>
References: <1402628655-2904-1-git-send-email-nickkrause@sympatico.ca>
Date: Wed, 20 Aug 2014 15:33:17 +0200
Message-ID: <CANq1E4SkBaSG2k2a0cFu=Ge97==LA7=8DDk4XbHxy3N4XMvyUA@mail.gmail.com>
Subject: Re: [PATCH] platform/x86/toshiba-apci.c possible bad if test?
From: David Herrmann <dh.herrmann@gmail.com>
To: matthew.garrett@nebula.com
Cc: platform-driver-x86@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Nick <xerofoify@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Jun 13, 2014 at 5:04 AM, Nick <xerofoify@gmail.com> wrote:
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index 76441dc..dfd2243 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -1238,7 +1238,7 @@ static ssize_t toshiba_kbd_bl_mode_store(struct device *dev,
>         int mode = -1;
>         int time = -1;
>
> -       if (sscanf(buf, "%i", &mode) != 1 && (mode != 2 || mode != 1))
> +       if (sscanf(buf, "%i", &mode) != 1  || (mode != 2 || mode != 1))
>                 return -EINVAL;

This patch is wrong. Matthew, please revert this or fix it.

(mode != 2 || mode != 1) is a tautology

therefore, this will always return -EINVAL. Furthermore, it lacks a sign-off.

Thanks
David

>         /* Set the Keyboard Backlight Mode where:
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
