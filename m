Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbaGVRQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 13:16:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42238 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830AbaGVRQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 13:16:19 -0400
Message-ID: <53CE9C5F.1030005@wwwdotorg.org>
Date: Tue, 22 Jul 2014 11:16:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] clk: tegra: don't abort clk init on error
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com> <1405437890-6468-2-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1405437890-6468-2-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 09:24 AM, Peter De Schrijver wrote:
> Just continue initializing clocks if there's an error on one of them. This
> is useful if there's a mistake in the inittable, because the system could
> hang if clk_disable_unused() disables some of the critical clocks in this
> table.

If there's a problem in the init table, we should simply fix it instead
of working around it.

At the very least, we need to WARN on this rather than just ignoring
problems.
