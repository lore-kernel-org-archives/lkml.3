Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3IGTop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 15:44:45 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:57955 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3IGToo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 15:44:44 -0400
Message-ID: <522B903C.7040604@kernel.org>
Date: Sat, 07 Sep 2013 21:44:44 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Xie XiuQi <xiexiuqi@huawei.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Thomas Gleixner <tglx@linutronix.de>,
        Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nadia Derbey <Nadia.Derbey@bull.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Bin <huawei.libin@huawei.com>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 1/5] iio: adc: remove unnecessary work pending test
References: <5229B601.9090109@huawei.com> <5229B64A.1030304@huawei.com> <20130906152028.GA22763@mtj.dyndns.org>
In-Reply-To: <20130906152028.GA22763@mtj.dyndns.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ccing Michael Hennerich and Lars-Peter Clausen,

On 09/06/13 16:20, Tejun Heo wrote:
> On Fri, Sep 06, 2013 at 07:02:34PM +0800, Xie XiuQi wrote:
>> Remove unnecessary work pending test before calling schedule_work().
>> It has been tested in queue_work_on() already. No functional changed.
>>
>> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
>> Cc: Tejun Heo <tj@kernel.org>
> 
> Reviewed-by: Tejun Heo <tj@kernel.org>
> 
> One nit below tho.
> 
>> -	if (iio_buffer_enabled(indio_dev)) {
>> -		if (!work_pending(&st->poll_work))
>> -			schedule_work(&st->poll_work);
>> -	} else {
>> +	if (iio_buffer_enabled(indio_dev))
>> +		schedule_work(&st->poll_work);
>> +	else {
>>  		st->done = true;
>>  		wake_up_interruptible(&st->wq_data_avail);
>>  	}
> 
> Please don't drop the parentheses.  The convention is to have either
> both or none on if/else.

I'll fix this up on applying if everyone is happy (can't see why the
won't be, but best to check!) Michael is clearly given as the author of driver
so should probably have been in the cc list. Whilst I might apply this directly
as maintainer I much prefer if I get an ack from the driver author as if nothing
else it gives me a warm fuzzy feeling ;)

Also patch title should mention that a) this is a staging driver, b) which adc driver it
applies to. I'll fix that up as well on applying it.

Thanks for the patch though, it would probably never have been noticed otherwise!

> 
> Thanks.
> 
