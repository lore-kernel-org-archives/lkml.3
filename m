Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbaFBMvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:51:31 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:61730 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaFBMv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:51:29 -0400
Message-ID: <538C7342.4000700@gmail.com>
Date: Mon, 02 Jun 2014 14:51:14 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 1/7] arm: firmware: Check firmware is running or not
References: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com> <1401712543-14281-2-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1401712543-14281-2-git-send-email-b.zolnierkie@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02.06.2014 14:35, Bartlomiej Zolnierkiewicz wrote:
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> To support multi-platform, it needs to know it's running under secure
> OS or not.  Sometimes it needs to access physical address by SMC calls.
> 
> e.g.,
>         if (firmware_run()) {
>                 addr = physical address;
>         } else {
>                 addr = virtual address;
>         }
> 
>         call_firmware_ops(read_address, addr, &value);

Hmm, I don't understand the code above. It first asks whether the
firmware is available and then calls a firmware operation anyway
(assuming that firmware is available regardless of the check above)...

I don't like the idea of this function, because we have designed the
firmware API to not require this kind of checks. Instead, you just call
whatever firmware operation you need and if it returns -ENOSYS you need
to fallback to legacy (firmware-less) way of doing it.

Could you provide your use case for which this doesn't work?

Best regards,
Tomasz
