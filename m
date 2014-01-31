Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaAaJVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 04:21:49 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:51353 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaAaJVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 04:21:47 -0500
Message-ID: <1391160084.4141.1.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC PATCH] net: wireless: move regulatory timeout work to
 power efficient workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Zoran Markovic <zoran.markovic@linaro.org>, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Shaibal Dutta <shaibal.dutta@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 31 Jan 2014 10:21:24 +0100
In-Reply-To: <1391123310-6425-1-git-send-email-zoran.markovic@linaro.org> (sfid-20140131_000951_185024_42790CBB)
References: <1391123310-6425-1-git-send-email-zoran.markovic@linaro.org>
	 (sfid-20140131_000951_185024_42790CBB)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-30 at 15:08 -0800, Zoran Markovic wrote:
> From: Shaibal Dutta <shaibal.dutta@broadcom.com>
> 
> For better use of CPU idle time, allow the scheduler to select the CPU
> on which the timeout work of regulatory settings would be executed.
> This extends CPU idle residency time and saves power.
> 
> This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.

> -		schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));
> +		queue_delayed_work(system_power_efficient_wq,
> +				   &reg_timeout, msecs_to_jiffies(3142));

I'm not sure if this is part of a larger patchset actually adding that
"system_power_efficient_wq", but maybe it'd be better to expose a
function as an API rather than the wq struct?

Something like

scheduled_delayed_work_pwr_efficient(...)?

?

johannes

