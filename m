Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab3FMQii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:38:38 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:53771 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547Ab3FMQif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:38:35 -0400
MIME-Version: 1.0
In-Reply-To: <150901ce682e$1c3fca50$54bf5ef0$%kim@samsung.com>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
	<1371058399-31933-3-git-send-email-dianders@chromium.org>
	<150901ce682e$1c3fca50$54bf5ef0$%kim@samsung.com>
Date: Thu, 13 Jun 2013 09:38:33 -0700
X-Google-Sender-Auth: e-N-qrkqKjliTmbzB26aKS4xzxs
Message-ID: <CAD=FV=U9V-rgjcCusCvgw-SeUH-kDbozr_T-i1DcaXNXv48vxw@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: exynos: ack level-triggered interrupts
 before unmasking
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Ilho Lee <ilho215.lee@samsung.com>,
        =?UTF-8?B?6rmA7J2A6riw?= <eunki_kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin,

On Thu, Jun 13, 2013 at 5:04 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Doug Anderson wrote:
>>
>> A level-triggered interrupt should be acked after the interrupt line
>> becomes inactive and before it is unmasked, or else another interrupt
>> will be immediately triggered.  Acking before or after calling the
>> handler is not enough.
>>
>> Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>
> BTW, probably we need a similar fixing in the mach-exynos/common.c file
> before pinct기 for distro...

Is anyone using the functions in mach-exynos/common.c file anymore?  I
thought that non-dt exynos support was going away and then we could
just delete a whole lot of code from that file.

-Doug
