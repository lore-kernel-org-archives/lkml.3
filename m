Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbaHZHnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:43:43 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:43392 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbaHZHnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:43:40 -0400
MIME-Version: 1.0
In-Reply-To: <1408969564-6335-11-git-send-email-ulf.hansson@linaro.org>
References: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
	<1408969564-6335-11-git-send-email-ulf.hansson@linaro.org>
Date: Tue, 26 Aug 2014 09:43:39 +0200
X-Google-Sender-Auth: moghWhFvzYxWnkd_lLuFy2M0ODY
Message-ID: <CAMuHMdW-+xGKmcDSNjzS6MBB9ZnQ1FVrCeM82kyr5SgO-nPr0Q@mail.gmail.com>
Subject: Re: [PATCH 10/12] mmc: sdhi: Fixup system PM suspend lock-up
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Linux MMC List <linux-mmc@vger.kernel.org>,
        Ian Molton <ian.molton@codethink.co.uk>, Chris Ball <chris@printf.net>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 2:26 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> At system PM suspend, the tmio core accessed the internal registers of
> the controller without first moving the device into active state. This
> caused a lock-up in system PM suspend phase.
>
> The reason for the register access were masking of IRQs. Since that is
> managed via the runtime PM suspend path, let's just re-use that path
> for system PM suspend.
>
> In other words force the device into runtime PM suspend state at system
> PM suspend and restore it to active state at system PM resume.
>
> Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
