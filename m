Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081Ab3BZBXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:23:24 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:47402 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3BZBXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:23:22 -0500
Date: Mon, 25 Feb 2013 17:23:17 -0800
From: "'Tejun Heo'" <tj@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Greg KH'" <greg@kroah.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH V2] rtc: add devm_rtc_device_{register,unregister}()
Message-ID: <20130226012317.GF2679@htj.dyndns.org>
References: <008c01ce13bf$8d2cd550$a7867ff0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008c01ce13bf$8d2cd550$a7867ff0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 26, 2013 at 10:21:06AM +0900, Jingoo Han wrote:
> These functios allows the driver core to automatically clean up
> any allocation made by rtc drivers. Thus, it simplifies the error
> paths.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Looks okay to me but

> +static int devm_rtc_device_match(struct device *dev, void *res, void *data)
> +{
> +	struct rtc **r = res;
> +	if (WARN_ON(!r || !*r))
> +		return 0;
> +
> +	return *r == data;
> +}

again, why do we need the WARN_ON() at all given that other
devm_*_match() don't do that and the only way to get NULL there would
be bug in devm_rtc*() code itself rather than its users?

Thanks.

-- 
tejun
