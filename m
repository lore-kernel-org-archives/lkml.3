Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbaLIDGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 22:06:32 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:62678 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaLIDGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 22:06:31 -0500
MIME-Version: 1.0
In-Reply-To: <1418074473-10811-1-git-send-email-olof@lixom.net>
References: <1418074473-10811-1-git-send-email-olof@lixom.net>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 9 Dec 2014 12:06:10 +0900
Message-ID: <CAAVeFuK2AJvSkZEafrGRw8VjQO-zXABJJMHbK5pxYOL4ypsVsg@mail.gmail.com>
Subject: Re: [PATCH] gpio: bcm-kona: memory corruption fix
To: Olof Johansson <olof@lixom.net>
Cc: Linus Walleij <linus.walleij@linaro.org>, rjui@broadcom.com,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 6:34 AM, Olof Johansson <olof@lixom.net> wrote:
> In one instance the base address of the internal controller state
> structure is passed into a function doing writel to an offset of
> the pointer passed in is used, instead of the register base.
>
> Once I found the bug, I also went back to check for other sparse
> warnings in the file, but found none. This one, however, triggered:
>
> drivers/gpio/gpio-bcm-kona.c:552:47: warning: incorrect type in argument 1 (different address spaces)
> drivers/gpio/gpio-bcm-kona.c:552:47:    expected void [noderef] <asn:2>*reg_base
> drivers/gpio/gpio-bcm-kona.c:552:47:    got struct bcm_kona_gpio *kona_gpio
> drivers/gpio/gpio-bcm-kona.c:556:47: warning: incorrect type in argument 1 (different address spaces)
> drivers/gpio/gpio-bcm-kona.c:556:47:    expected void [noderef] <asn:2>*reg_base
> drivers/gpio/gpio-bcm-kona.c:556:47:    got struct bcm_kona_gpio *kona_gpio
>
> As far as I can tell, this bug has been here for a long time and is
> not new, but I found it when hunting down another heisenbug on this
> platform.

Ouch. Thanks for fixing this.

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
