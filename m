Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab3BZWdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:33:10 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:40996 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3BZWdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:33:08 -0500
Date: Tue, 26 Feb 2013 14:33:04 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Tejun Heo'" <tj@kernel.org>,
        "'Greg KH'" <greg@kroah.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH V2] rtc: add devm_rtc_device_{register,unregister}()
Message-ID: <20130226223304.GB20670@core.coreip.homeip.net>
References: <008c01ce13bf$8d2cd550$a7867ff0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008c01ce13bf$8d2cd550$a7867ff0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 10:21:06AM +0900, Jingoo Han wrote:
> +/**
> + * devm_rtc_device_unregister - resource managed devm_rtc_device_unregister()
> + * @dev: the device to unregister
> + * @rtc: the RTC class device to unregister
> + *
> + * Deallocated a rtc allocated with devm_rtc_device_register(). Normally this
> + * function will not need to be called and the resource management code will
> + * ensure that the resource is freed.
> + */
> +void devm_rtc_device_unregister(struct device *dev, struct rtc_device *rtc)

Why do you need a separate function? You can add a flag to struct rtc_device
so it knows whether it is devm-managed or not and behave accordingly.
And then you can do

#define devm_rtc_device_unregister rtc_device_unregister

Thanks.

-- 
Dmitry
