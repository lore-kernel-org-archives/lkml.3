Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab3EIKIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:08:01 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:50520 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab3EIKH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:07:59 -0400
MIME-Version: 1.0
In-Reply-To: <1368076726-11492-2-git-send-email-skannan@codeaurora.org>
References: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
	<1368076726-11492-2-git-send-email-skannan@codeaurora.org>
Date: Thu, 9 May 2013 18:07:56 +0800
Message-ID: <CACVXFVMd_iRtEM8ZLK6Ps66gZO6SCp1mXSgY6JbWtRJjJUh+ag@mail.gmail.com>
Subject: Re: [PATCH 1/3] driver core: Add API to wait for deferred probe to
 complete during init
From: Ming Lei <tom.leiming@gmail.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@linaro.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 1:18 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
>
> The most obvious fallback of using late_initcall_sync() also doesn't work
> since the deferred probing work initated during late_initcall() is done in
> a workqueue. So, frameworks that want to wait for all devices to finish
> probing during init will now have to wait for the deferred workqueue to
> finish it's work. This patch adds a wait_for_init_deferred_probe_done() API

flush_workqueue() has been added in deferred_probe_initcall(), so looks it
should be OK for your problem, doesn't it?


Thanks,
-- 
Ming Lei
