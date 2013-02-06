Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab3BFRnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:43:46 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60647 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab3BFRno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:43:44 -0500
Message-ID: <5112964D.50707@wwwdotorg.org>
Date: Wed, 06 Feb 2013 10:43:41 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: swarren@nvidia.com, mturquette@linaro.org, pgaikwad@nvidia.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: initialise parent of uart clocks
References: <1360147661-5435-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1360147661-5435-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 03:47 AM, Laxman Dewangan wrote:
> Initialise the parent of UARTs to PLLP

OK

> and disabling clock by default.

Hmm. Only the clocks initialized by the new entries you added are marked
disabled (or rather, not actively enabled; if they're enabled already,
they won't be disabled). We should treat all UARTs equally. Historically
we've needed to enable the serial clocks forcibly since the regular
serial driver didn't call clk_get() or clk_prepare_enable() on any
clocks, but I notice that it does now, since sometime in kernel 3.8. As
such, I think you can modify all the UART entries in these tables to
have the enable/state field set to false (0). Can you try that and check
that it works for the serial console ports? Thanks.
