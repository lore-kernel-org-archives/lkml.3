Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3H2URp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:17:45 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42908 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756570Ab3H2URn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:17:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Zhang <zhangwm@marvell.com>, Joseph Lo <josephl@nvidia.com>,
        linux-tegra@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jon Medhurst <tixy@linaro.org>, Sivaram Nair <sivaramn@nvidia.com>
Subject: Re: [PATCH v2] cpuidle: coupled: abort idle if pokes are pending
Date: Thu, 29 Aug 2013 22:28:28 +0200
Message-ID: <7272744.lhUaaLc3cm@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1377740508-22134-1-git-send-email-ccross@android.com>
References: <1377740508-22134-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 28, 2013 06:41:47 PM Colin Cross wrote:
> Joseph Lo <josephl@nvidia.com> reported a lockup on Tegra20 caused
> by a race condition in coupled cpuidle.  When two or more cpus
> enter idle at the same time, the first cpus to arrive may go to the
> ready loop without processing pending pokes from the last cpu to
> arrive.
> 
> This patch adds a check for pending pokes once all cpus have been
> synchronized in the ready loop and resets the coupled state and
> retries if any cpus failed to handle their pending poke.
> 
> Retrying on all cpus may trigger the same issue again, so this patch
> also adds a check to ensure that each cpu has received at least one
> poke between when it enters the waiting loop and when it moves on to
> the ready loop.
> 
> Reported-by: Joseph Lo <josephl@nvidia.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> Tested-by: Joseph Lo <josephl@nvidia.com>
> Signed-off-by: Colin Cross <ccross@android.com>

Still stable material I suppose?

Queued up for 3.12, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
