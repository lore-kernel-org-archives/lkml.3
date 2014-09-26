Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaIZIhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:37:42 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:62608 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbaIZIhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:37:40 -0400
MIME-Version: 1.0
In-Reply-To: <1411505993-8414-1-git-send-email-joshc@codeaurora.org>
References: <1411505993-8414-1-git-send-email-joshc@codeaurora.org>
Date: Fri, 26 Sep 2014 10:37:39 +0200
Message-ID: <CACRpkdZQ25_Rzr0whL50NPk+sw2miisuxfwLyiw_afRb8FacSQ@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: qcom: use restart_notifier mechanism for ps_hold
From: Linus Walleij <linus.walleij@linaro.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 10:59 PM, Josh Cartwright <joshc@codeaurora.org> wrote:

> By converting to the restart_notifier mechanism for restart, we allow
> for other mechanisms, like the watchdog, to be used for restart in the
> case where PS_HOLD has failed to reset the chip.
>
> Since this mechanism may be one of several mechanisms registered, change
> the post-ps_hold write timeout to be a more reasonable 1 second instead
> of 10 seconds.
>
> Choose priority 128, as according to documentation, this mechanism "is
> sufficient to restart the entire system".
>
> Cc: Pramod Gurav <pramod.gurav@smartplayin.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Tested-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>
> Changes since v1:
>   - Simplified conditional notifier block registration
>   - Reduced wait time to 1s, which I've found to be sufficient on an IFC6410
>     board.

Patch applied with ACKs.

Yours,
Linus Walleij
