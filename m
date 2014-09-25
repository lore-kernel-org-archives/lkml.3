Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaIYHlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:41:06 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:61337 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaIYHlD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:41:03 -0400
MIME-Version: 1.0
In-Reply-To: <1411505993-8414-1-git-send-email-joshc@codeaurora.org>
References: <1411505993-8414-1-git-send-email-joshc@codeaurora.org>
Date: Thu, 25 Sep 2014 09:41:02 +0200
Message-ID: <CACRpkdauNieUTSAR=PGsvrXOrPNsBgyCPC9Ot=ZDXctfSdEp8w@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: qcom: use restart_notifier mechanism for ps_hold
From: Linus Walleij <linus.walleij@linaro.org>
To: Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
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

Björn, are you OK with this patch?

Yours,
Linus Walleij
