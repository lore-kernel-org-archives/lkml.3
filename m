Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761873Ab3DBRKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:10:04 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31332 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760849Ab3DBRKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:10:02 -0400
Message-ID: <515B10D4.8090906@oracle.com>
Date: Tue, 02 Apr 2013 13:09:40 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: williams@redhat.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] rtmutex-tester: set correct permissions on sysfs files
References: <1363795105-5884-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1363795105-5884-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On 03/20/2013 11:58 AM, Sasha Levin wrote:
> sysfs started complaining about cases where permissions don't
> match what's in the sysfs ops structure (such as allowing read
> without a "show" callback).
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  kernel/rtmutex-tester.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rtmutex-tester.c b/kernel/rtmutex-tester.c
> index 7890b10..1d96dd0 100644
> --- a/kernel/rtmutex-tester.c
> +++ b/kernel/rtmutex-tester.c
> @@ -14,6 +14,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/timer.h>
>  #include <linux/freezer.h>
> +#include <linux/stat.h>
>  
>  #include "rtmutex.h"
>  
> @@ -366,8 +367,8 @@ static ssize_t sysfs_test_status(struct device *dev, struct device_attribute *at
>  	return curr - buf;
>  }
>  
> -static DEVICE_ATTR(status, 0600, sysfs_test_status, NULL);
> -static DEVICE_ATTR(command, 0600, NULL, sysfs_test_command);
> +static DEVICE_ATTR(status, S_IRUSR, sysfs_test_status, NULL);
> +static DEVICE_ATTR(command, S_IWUSR, NULL, sysfs_test_command);
>  
>  static struct bus_type rttest_subsys = {
>  	.name = "rttest",
> 

