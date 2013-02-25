Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706Ab3BYXcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:32:20 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:54781 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab3BYXcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:32:19 -0500
Date: Mon, 25 Feb 2013 15:32:14 -0800
From: "'Tejun Heo'" <tj@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: add devm_rtc_device_{register,unregister}()
Message-ID: <20130225233214.GA2679@htj.dyndns.org>
References: <000e01ce132a$be08b940$3a1a2bc0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000e01ce132a$be08b940$3a1a2bc0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 04:35:53PM +0900, Jingoo Han wrote:
> +static void devm_rtc_device_release(struct device *dev, void *res)
> +{
> +	struct rtc_device *rtc = *(struct rtc_device **)res;
> +
> +	rtc_device_unregister(rtc);
> +}
> +
> +static int devm_rtc_device_match(struct device *dev, void *res, void *data)
> +{
> +	struct rtc **r = res;
> +	if (!r || !*r) {
> +		WARN_ON(!r || !*r);
> +		return 0;
> +	}

	if (WARN_ON(!r || !*r))
		return 0;

But why do we need this at all?  Other match functions don't need it.
Is something different about devm_rtc?

Thanks.

-- 
tejun
