Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbaHGEqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 00:46:11 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:49946 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277AbaHGEqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 00:46:09 -0400
MIME-Version: 1.0
In-Reply-To: <1407386413-20111-1-git-send-email-xerofoiify@gmail.com>
References: <1407386413-20111-1-git-send-email-xerofoiify@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 7 Aug 2014 13:45:48 +0900
Message-ID: <CAAVeFuJN3AWzAfoE+-3o-7b07wK0u-PDwBQx+4HwFesurE6cyQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/gpio: Check return value to silence warning
To: Nick Krause <xerofoiify@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 1:40 PM, Nick Krause <xerofoiify@gmail.com> wrote:
> Check for return value to fix the following error
>
> drivers/gpio/gpio-sch311x.c: In function 'sch311x_gpio_probe':
> drivers/gpio/gpio-sch311x.c:286:18: warning: ignoring return value of
> 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]
>
> in the context we do not need to check but checking makes compiler happy.
> With help from kernelnewbies.

This patch is not needed: the warn_unused_result has been removed for
3.17, and gpiochip_remove will be changed to return void soon anyway.
