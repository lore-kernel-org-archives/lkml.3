Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3IFPUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:20:36 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:37954 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab3IFPUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:20:34 -0400
Date: Fri, 6 Sep 2013 11:20:28 -0400
From: Tejun Heo <tj@kernel.org>
To: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Thomas Gleixner <tglx@linutronix.de>,
        Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nadia Derbey <Nadia.Derbey@bull.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Bin <huawei.libin@huawei.com>
Subject: Re: [PATCH 1/5] iio: adc: remove unnecessary work pending test
Message-ID: <20130906152028.GA22763@mtj.dyndns.org>
References: <5229B601.9090109@huawei.com>
 <5229B64A.1030304@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5229B64A.1030304@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 07:02:34PM +0800, Xie XiuQi wrote:
> Remove unnecessary work pending test before calling schedule_work().
> It has been tested in queue_work_on() already. No functional changed.
> 
> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
> Cc: Tejun Heo <tj@kernel.org>

Reviewed-by: Tejun Heo <tj@kernel.org>

One nit below tho.

> -	if (iio_buffer_enabled(indio_dev)) {
> -		if (!work_pending(&st->poll_work))
> -			schedule_work(&st->poll_work);
> -	} else {
> +	if (iio_buffer_enabled(indio_dev))
> +		schedule_work(&st->poll_work);
> +	else {
>  		st->done = true;
>  		wake_up_interruptible(&st->wq_data_avail);
>  	}

Please don't drop the parentheses.  The convention is to have either
both or none on if/else.

Thanks.

-- 
tejun
