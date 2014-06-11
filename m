Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbaFKQuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:50:44 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:59565 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbaFKQul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:50:41 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Tushar Behera <tushar.b@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        t.figa@samsung.com, linux@arm.linux.org.uk, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, kgene.kim@samsung.com,
        dianders@google.com, trblinux@gmail.com,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: Re: [PATCH 1/3] clk: exynos-audss: Keep the parent of mout_audss always enabled
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
	<1402464739-19044-2-git-send-email-tushar.b@samsung.com>
Date: Wed, 11 Jun 2014 09:50:38 -0700
In-Reply-To: <1402464739-19044-2-git-send-email-tushar.b@samsung.com> (Tushar
	Behera's message of "Wed, 11 Jun 2014 11:02:17 +0530")
Message-ID: <7ha99jjspt.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tushar Behera <tushar.b@samsung.com> writes:

> When the output clock of AUDSS mux is disabled, we are getting kernel
> oops while doing a clk_get() on other clocks provided by AUDSS. 
>
> Though user manual doesn't specify this dependency, we came across
> this issue while disabling the parent of AUDSS mux clocks.
>
> Keeping the parents of AUDSS mux always enabled fixes this issue.

While this patch works (and fixes the boot problem for me), it seems
like it's papering over the real problem.

Seems like the right fix is actually modelling the clocks properly so
that enabling a child clock ensures that the parent is also enabled.

Kevin
