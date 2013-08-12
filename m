Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3HLQdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:33:32 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48590 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab3HLQdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:33:31 -0400
Date: Mon, 12 Aug 2013 17:33:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] mfd: tps65010: Use power efficient workqueue for power
 polling
Message-ID: <20130812163324.GB3636@lee--X1>
References: <1376069102-15658-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1376069102-15658-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Aug 2013, Mark Brown wrote:

> From: Mark Brown <broonie@linaro.org>
> 
> There is no need to use a per CPU workqueue to poll, especially with the
> 5s delay used, so allow the scheduler to use any CPU.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/tps65010.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)

I'm going to apply the patch and ...

> -		schedule_delayed_work(&the_tps->work, 0);
> +		queue_delayed_work(system_power_efficient_wq, &the_tps->work,
> +				   0);

... move this back up onto the line above, if it's all the same to you?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
