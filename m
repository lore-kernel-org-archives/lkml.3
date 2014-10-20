Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaJTVlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:41:35 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:60302 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaJTVlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:41:21 -0400
MIME-Version: 1.0
In-Reply-To: <1413839151-10875-2-git-send-email-javier.martinez@collabora.co.uk>
References: <1413839151-10875-1-git-send-email-javier.martinez@collabora.co.uk>
	<1413839151-10875-2-git-send-email-javier.martinez@collabora.co.uk>
Date: Mon, 20 Oct 2014 14:41:20 -0700
X-Google-Sender-Auth: 5YLKvKp4qQjH4SxovR3j15Br6lE
Message-ID: <CAD=FV=U+m_5JfXAJ6p_5k08R4=jzPgzcxnNr4PeEQQ6Z9Tbw=w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Revert "mfd: sec-core: Prepare regulators for
 suspend state to reduce power-consumption"
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Mark Brown <broonie@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Mon, Oct 20, 2014 at 2:05 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> This reverts commit b7cde7078d2344073c310aa65fc2b0a845d2cb5b
> ("mfd: sec-core: Prepare regulators for suspend state to reduce power-consumption")
>
> Commit b7cde7078d23 called regulator_suspend_prepare() to prepare the
> regulators for a suspend state. But it did from the device pm suspend
> handler while the regulator suspend prepare function iterates over all
> regulators and not only the one managed by this device so it doesn't
> seems to be correct to call it from within a device driver.
>
> It is better to call the regulator suspend prepare/finish functions
> from platform code instead so this patch reverts the mentioned commit.
>
> Suggested-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Reviewed-by: Doug Anderson <dianders@chromium.org>
