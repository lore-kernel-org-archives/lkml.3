Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3GITJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 15:09:48 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:55474 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab3GITJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 15:09:44 -0400
MIME-Version: 1.0
In-Reply-To: <1373391071-6312-4-git-send-email-dianders@chromium.org>
References: <1373391071-6312-1-git-send-email-dianders@chromium.org>
	<1373391071-6312-4-git-send-email-dianders@chromium.org>
Date: Tue, 9 Jul 2013 12:09:42 -0700
X-Google-Sender-Auth: hVGPX2oelCvhmwf2UE_2zgJLLso
Message-ID: <CAD=FV=XLp_2t83JfUBryaSvqLZr5OHEZeFZDRmQ1T=XA1MRkHg@mail.gmail.com>
Subject: Re: [PATCH 3/5] mmc: dw_mmc: Add exynos resume callback to clear WAKEUP_INT
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Olof Johansson <olof@lixom.net>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 9, 2013 at 10:31 AM, Doug Anderson <dianders@chromium.org> wrote:
> If the WAKEUP_INT is asserted at wakeup and not cleared, we'll end up
> looping around forever.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc-exynos.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)

Grant just pointed out that the WAKEUP_INT is supposed to only be
enabled if bits 8, 9, or 10 are 1.  Our driver never sets those so we
_should_ never get a WAKEUP_INT.  Bits 8-10 are marked as RESERVED on
the exynos5420 manual, so the current guess is that they're broken on
that silicon but that sometimes the interrupt fires anyway.

In any case, it is still a reasonable thing to clear this interrupt at
wakeup if it has fired, even if we're on an exynos device without any
problems.

-Doug
