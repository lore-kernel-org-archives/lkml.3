Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3JASZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 14:25:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35329 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3JASZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 14:25:14 -0400
Message-ID: <524B11AA.30400@wwwdotorg.org>
Date: Tue, 01 Oct 2013 12:17:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arto Merilainen <amerilainen@nvidia.com>
CC: tbergstrom@nvidia.com, treding@nvidia.com, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        mkulkarni@nvidia.com
Subject: Re: [PATCHv3 4/4] gpu: host1x: Add runtime pm support for host1x
References: <1380024325-18280-1-git-send-email-amerilainen@nvidia.com> <1380024325-18280-5-git-send-email-amerilainen@nvidia.com>
In-Reply-To: <1380024325-18280-5-git-send-email-amerilainen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 06:05 AM, Arto Merilainen wrote:
> From: Mayuresh Kulkarni <mkulkarni@nvidia.com>
> 
> This patch adds runtime pm support for host1x hardware unit. This
> allows host1x clock to be turned off when it is idle. If pm runtime
> is not configured, we enable host1x clock in device probe and disable
> it in remove.

> diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c

> +static int host1x_runtime_suspend(struct device *dev);
> +static int host1x_runtime_resume(struct device *dev);

You could avoid having these prototypes by simply putting the function
bodies earlier on in the file, somewhere before they're used. I don't
care much either way, but I've certainly seen some people care about
this and ask for them to be moved.
