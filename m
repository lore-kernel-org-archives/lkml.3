Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab3CNRit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:38:49 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:41448 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab3CNRir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:38:47 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Lokesh Vutla <lokeshvutla@ti.com>
Cc: <will.deacon@arm.com>, <dietmar.eggemann@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <santosh.shilimkar@ti.com>
Subject: Re: [PATCH] ARM: hw_breakpoint: Enable debug powerdown only if system supports 'has_ossr'
References: <1363157553-21085-1-git-send-email-lokeshvutla@ti.com>
Date: Thu, 14 Mar 2013 10:38:43 -0700
In-Reply-To: <1363157553-21085-1-git-send-email-lokeshvutla@ti.com> (Lokesh
	Vutla's message of "Wed, 13 Mar 2013 12:22:33 +0530")
Message-ID: <87txodnaos.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lokesh Vutla <lokeshvutla@ti.com> writes:

> Commit {9a6eb31 ARM: hw_breakpoint: Debug powerdown support for self-hosted
> debug} introduces debug powerdown support for self-hosted debug.
> While merging the patch 'has_ossr' check was removed which
> was needed for hardwares which doesn't support self-hosted debug.
> Pandaboard (A9) is one such hardware and Dietmar's orginial
> patch did mention this issue.
> Without that check on Panda with CPUIDLE enabled, a flood of
> below messages thrown.
>
> [ 3.597930] hw-breakpoint: CPU 0 failed to disable vector catch
> [ 3.597991] hw-breakpoint: CPU 1 failed to disable vector catch
>
> So restore that check back to avoid the mentioned issue.
>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Reported-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>

I just noticed this on my Panda boards with CPUidle enabled, and
$SUBJECT patch fixes it.

FWIW,

Tested-by: Kevin Hilman <khilman@linaro.org>

I agree that this should get queued for v3.9-rc.

Kevin


