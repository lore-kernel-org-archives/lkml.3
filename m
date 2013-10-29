Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab3J2B6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:58:45 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42981 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab3J2B6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:58:43 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] ARM: Support arch_irq_work_raise() via self IPIs
References: <526DBEAA.4030707@linaro.org>
	<1382984701-2371-1-git-send-email-sboyd@codeaurora.org>
Date: Mon, 28 Oct 2013 18:58:40 -0700
In-Reply-To: <1382984701-2371-1-git-send-email-sboyd@codeaurora.org> (Stephen
	Boyd's message of "Mon, 28 Oct 2013 11:25:01 -0700")
Message-ID: <878uxcq1m7.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> writes:

> This will allow the scheduler tick to be restarted if we're in
> full NOHZ mode.
>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Minor nit, but I'd prefer a more verbose changelog (I forget things
quickly and like to rely on changelogs for my memory.)  Probably worth
adding something like: "By default, irq_work is tied to the tick
processing (update_process_times()) but in full NOHZ mode, no tick means
no IRQ work.  In order for IRQ work to be done in full NOHZ mode, a
self-IPI is used to process IRQ work."

Other than the changelog nit, patch looks good, feel free to add

Reviewed-by: Kevin Hilman <khilman@linaro.org>

If Russell is OK with this, it can go to his patch system.

Kevin
