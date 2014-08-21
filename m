Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbaHUELZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 00:11:25 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:58234 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaHUELV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 00:11:21 -0400
MIME-Version: 1.0
In-Reply-To: <1408495538-27480-5-git-send-email-linux@roeck-us.net>
References: <1408495538-27480-1-git-send-email-linux@roeck-us.net>
	<1408495538-27480-5-git-send-email-linux@roeck-us.net>
Date: Wed, 20 Aug 2014 21:11:21 -0700
X-Google-Sender-Auth: UZ6gFSt8ESi7mfA-pT1Zko2RHDc
Message-ID: <CAD=FV=VNLCc5VVxQspZrZPrZ_JZQO+SJtkA61CAYj-f5fnA2LQ@mail.gmail.com>
Subject: Re: [PATCH v7 04/11] arm: Support restart through restart handler
 call chain
From: Doug Anderson <dianders@chromium.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Russell King <linux@arm.linux.org.uk>, Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter,

On Tue, Aug 19, 2014 at 5:45 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> The kernel core now supports a restart handler call chain for system
> restart functions.
>
> With this change, the arm_pm_restart callback is now optional, so
> drop its initialization and check if it is set before calling it.
> Only call the kernel restart handler if arm_pm_restart is not set.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Heiko Stuebner <heiko@sntech.de>
> ---
> v7: Dropped null_restart and made arm_pm_restart truly optional.
> v6: No change.
> v5: Renamed restart function to do_kernel_restart
> v4: No change.
> v3: Use wrapper function to execute notifier call chain.
> v2: Only call notifier call chain if arm_pm_restart is not set.
>     Do not include linux/watchdog.h.
>
>  arch/arm/kernel/process.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
