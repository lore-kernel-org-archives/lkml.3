Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab3HMWNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 18:13:39 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:54200 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977Ab3HMWNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 18:13:38 -0400
Date: Tue, 13 Aug 2013 18:13:25 -0400
From: Tejun Heo <tj@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / QoS: Fix workqueue deadlock when using
 pm_qos_update_request_timeout()
Message-ID: <20130813221325.GD28996@mtj.dyndns.org>
References: <4423040.Ds5TZlivfo@vostro.rjw.lan>
 <1376428360-12560-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376428360-12560-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 13, 2013 at 02:12:40PM -0700, Stephen Boyd wrote:
> @@ -308,7 +319,7 @@ static void pm_qos_work_fn(struct work_struct *work)
>  						  struct pm_qos_request,
>  						  work);
>  
> -	pm_qos_update_request(req, PM_QOS_DEFAULT_VALUE);
> +	__pm_qos_update_request(req, PM_QOS_DEFAULT_VALUE);

Maybe a short comment explaining why this is different would be nice?
Other than that,

 Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
