Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaJFSLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:11:09 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:46937 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbaJFSLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:11:07 -0400
MIME-Version: 1.0
In-Reply-To: <1412618020-22278-1-git-send-email-sonnyrao@chromium.org>
References: <1412618020-22278-1-git-send-email-sonnyrao@chromium.org>
Date: Mon, 6 Oct 2014 11:11:05 -0700
X-Google-Sender-Auth: focljBXljfKgEtkZlvKgzdJIqEA
Message-ID: <CAD=FV=W-GW0c8m_5Oaet=ZhJJwmk4RWJ7QurcySB7T8YvKr6Sg@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Reset DMA before enabling IDMAC
From: Doug Anderson <dianders@chromium.org>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Eddie Cai <eddie.cai@rock-chips.com>, Addy Ke <addy.ke@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sonny,

On Mon, Oct 6, 2014 at 10:53 AM, Sonny Rao <sonnyrao@chromium.org> wrote:
> We've already got a reset of DMA after it's done.  Add one before we
> start DMA too.  This fixes a data corruption on Rockchip SoCs which
> will get bad data when doing a DMA transfer after doing a PIO transfer.
>
> We tested this on an Exynos 5800 with HS200 and didn't notice any
> difference in sequential read throughput.
>
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc.c | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
