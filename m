Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab3JKO2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:28:08 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35584 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3JKO2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:28:06 -0400
MIME-Version: 1.0
In-Reply-To: <1380909598-6382-2-git-send-email-acourbot@nvidia.com>
References: <1380909598-6382-1-git-send-email-acourbot@nvidia.com>
	<1380909598-6382-2-git-send-email-acourbot@nvidia.com>
Date: Fri, 11 Oct 2013 16:28:05 +0200
Message-ID: <CACRpkdYzCt6pbLahFoA7cn326bBESu-vVRmFSu6b9wCm+J7bOQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpiolib: let gpiod_request() return -EPROBE_DEFER
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 7:59 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Patch be1a4b brought some improvements to the GPIO error handling code,
> but also changed the return value of gpiod_request() when called on a
> not yet initialized GPIO descriptor: it now returns -EINVAL instead of
> -EPROBE_DEFER, and this affects some drivers.
>
> This patch restores the original behavior for gpiod_request(). It is
> safe to do so now that desc_to_gpio() does not rely on the GPIO
> descriptor to be initialized. Other functions changed by patch be1a4b
> do not see their return value affected, so these are not reverted.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reported-by: Dr. H. Nikolaus Schaller <hns@goldelico.com>

Patch applied.

Are these two patches regressions that need to go into fixes
for v3.12?

Yours,
Linus Walleij
