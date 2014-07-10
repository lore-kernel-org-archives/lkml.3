Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaGJHdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:33:33 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:54797 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaGJHdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:33:32 -0400
MIME-Version: 1.0
In-Reply-To: <1326492948-26160-1-git-send-email-dianders@chromium.org>
References: <1326156853-24840-1-git-send-email-dianders@chromium.org>
	<1326492948-26160-1-git-send-email-dianders@chromium.org>
Date: Thu, 10 Jul 2014 09:33:31 +0200
X-Google-Sender-Auth: vn_IOr3AO-UjMdSRbFc-QaB5OeE
Message-ID: <CANcMJZBDyx4KXB18nn=2zO-eEpeq2eL+7mpLhhsgsc632P9uAg@mail.gmail.com>
Subject: Re: [PATCH v2] of: Support CONFIG_CMDLINE_EXTEND config option
From: John Stultz <john.stultz@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@linaro.org>, Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 11:15 PM, Doug Anderson <dianders@chromium.org> wrote:
> The old logic assumes CMDLINE_FROM_BOOTLOADER vs. CMDLINE_FORCE and
> ignores CMDLINE_EXTEND.  Here's the old logic:
>
> - CONFIG_CMDLINE_FORCE=true
>     CONFIG_CMDLINE
> - dt bootargs=non-empty:
>     dt bootargs
> - dt bootargs=empty, @data is non-empty string
>     @data is left unchanged
> - dt bootargs=empty, @data is empty string
>     CONFIG_CMDLINE (or "" if that's not defined)
>
> The new logic is now documented in of_fdt.h and is copied here for
> reference:
>
> - CONFIG_CMDLINE_FORCE=true
>     CONFIG_CMDLINE
> - CONFIG_CMDLINE_EXTEND=true, @data is non-empty string
>     @data + dt bootargs (even if dt bootargs are empty)
> - CONFIG_CMDLINE_EXTEND=true, @data is empty string
>     CONFIG_CMDLINE + dt bootargs (even if dt bootargs are empty)
> - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=non-empty:
>     dt bootargs
> - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=empty, @data is non-empty string
>     @data is left unchanged
> - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=empty, @data is empty string
>     CONFIG_CMDLINE (or "" if that's not defined)
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> CC: devicetree-discuss@lists.ozlabs.org
> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Rob Herring <rob.herring@calxeda.com>
> ---
> I didn't hear a response from Ben about whether he was OK with
> my proposal for how CONFIG_CMDLINE_EXTEND should behave with
> a non-empty @data, so sending out code that implements my
> interpretation.  Hopefully this looks OK.
>
> Changes in v2:
> - Removed broken fix for the case when there is no "chosen" attribute.
> - Changed CONFIG_CMDLINE_EXTEND behavior when @data is a non-empty string.

In reviewing some of the random patches in the Android AOSP common.git
tree, I noticed this one, and found this discussion which petered out
without resolution.  Were there any objections still, or did this just
slip through the cracks?

Note, there's also this follow-on fix from Colin, which probably
should be included if the parent patch is merged:
https://android.googlesource.com/kernel/common.git/+/a2acc58bc7460a03627f20842a7169d7a1328299

thanks
-john
