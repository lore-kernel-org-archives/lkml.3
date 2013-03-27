Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab3C0PHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:07:36 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:39633 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3C0PHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:07:34 -0400
MIME-Version: 1.0
In-Reply-To: <1364338202-10311-1-git-send-email-grundler@chromium.org>
References: <1364338202-10311-1-git-send-email-grundler@chromium.org>
Date: Wed, 27 Mar 2013 08:07:32 -0700
X-Google-Sender-Auth: xSYpgZGnfW8nj6macfNgDqsV2dg
Message-ID: <CAD=FV=WRJhr1+OS5Be2Vz6J=Rgk3UQAzwjY3FuNSjvMbeR3uUg@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: rewrite CLKDIV computation
From: Doug Anderson <dianders@chromium.org>
To: Grant Grundler <grundler@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Will Newton <will.newton@gmail.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Bing Zhao <bzhao@marvell.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ashok Nagarajan <asnagarajan@chromium.org>,
        Olof Johansson <olof@lixom.net>, linux-mmc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

Thanks for posting!  See below...

On Tue, Mar 26, 2013 at 3:50 PM, Grant Grundler <grundler@chromium.org> wrote:
> Last year Seungwon Jeon (Samsung) fixed a bug in CLKDIV computation.
> But when debugging a related issue (http://crbug.com/221828) I found
> the code unreadable.  This rewrite simplifies the computation and
> explains each step.

The fact that you mention a bug here is confusing.  I think this patch
has nothing to do with fixing that bug and is just a readability
patch.  Is that correct?  Please add to the description if so and
maybe remove unrelated comment about the bug.


> +                       /* don't overclock due to resolution of HW */
> +                       if (div & 1)
> +                               div++;
> +
> +                       /* See 6.2.3 CLKDIV in "Mobile Storage Host Databook"
> +                        * Look for dwc_mobile_storage_db.pdf from Synopsys.
> +                        * CLKDIV value 0 means divisor 1, val 1 -> 2, ...

You are quoting exynos5250 docs here.  This driver is used for more
than just exynos and so this could be confusing to users on other
platforms.


>                          */
> -                       div += 1;
> -
> -               div = (host->bus_hz != slot->clock) ? DIV_ROUND_UP(div, 2) : 0;
> +                       div /= 2;

It does look like you're re-implementing DIV_ROUND_UP.  Maybe replace
your "if" test and division with just a DIV_ROUND_UP?


-Doug
