Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3EFTlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:41:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3EFTlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:41:21 -0400
Date: Mon, 6 May 2013 12:41:19 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH v2] PM: Fix dev_pm_put_subsys_data() to not call kfree()
 while holding device power lock
Message-ID: <20130506194119.GA15886@kroah.com>
References: <1367614010.8452.2.camel@lorien>
 <20130504125116.GA13770@amd.pavel.ucw.cz>
 <1882177.s6zpHZ6crc@vostro.rjw.lan>
 <20130506120925.GA25542@amd.pavel.ucw.cz>
 <1367867093.2953.49.camel@lorien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367867093.2953.49.camel@lorien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 07:04:53PM +0000, Shuah Khan wrote:
> dev_pm_put_subsys_data() calls kfree() while holding device power lock, when
> the reference count is 0. Fix it to call kfree() after releasing the lock.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> Reviewed-by: Pavel Machek <pavel@ucw.cz>
> Reviewed-by: Rafael Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/base/power/common.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Is this causing a problem now, and it should go into 3.10 and earlier
kernels (if so, which ones?), or can it just wait until 3.11 as it's
just a cleanup fix?

thanks,

greg k-h
