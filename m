Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaANPmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:42:32 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:35512 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaANPm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:42:29 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH RFC 04/10] base: power: Add generic OF-based power domain look-up
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
	<1389469372-17199-5-git-send-email-tomasz.figa@gmail.com>
Date: Tue, 14 Jan 2014 07:42:26 -0800
In-Reply-To: <1389469372-17199-5-git-send-email-tomasz.figa@gmail.com> (Tomasz
	Figa's message of "Sat, 11 Jan 2014 20:42:46 +0100")
Message-ID: <87r48a8t99.fsf@linaro.org>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa <tomasz.figa@gmail.com> writes:

> This patch introduces generic code to perform power domain look-up using
> device tree and automatically bind devices to their power domains.
> Generic device tree binding is introduced to specify power domains of
> devices in their device tree nodes.
>
> Backwards compatibility with legacy Samsung-specific power domain
> bindings is provided, but for now the new code is not compiled when
> CONFIG_ARCH_EXYNOS is selected to avoid collision with legacy code. This
> will change as soon as Exynos power domain code gets converted to use
> the generic framework in further patch.
>
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>

I haven't read through this in detail yet, but wanted to make sure that
the DT representation can handle nested power domains.  At least
SH-mobile has a hierarchy of power domains and the genpd code can handle
that, so wanted to make sure that the DT representation can handle it as
well.

Thanks,

Kevin
