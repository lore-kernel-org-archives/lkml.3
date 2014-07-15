Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030231AbaGOXQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:16:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588AbaGOXQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:16:01 -0400
Date: Tue, 15 Jul 2014 16:15:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: rtc-linux@googlegroups.com
Cc: Roman Fietze <roman.fietze@telemotive.de>, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] [PATCH 2/2] Allow to override the hctosys RTC using
 a kernel parameter
Message-Id: <20140715161559.c142128556ce4ade8bcdc514@linux-foundation.org>
In-Reply-To: <2398890.hEQ05gdLB8@rfietze>
References: <5132579.sMfE4ssjXf@rfietze>
	<2398890.hEQ05gdLB8@rfietze>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Jul 2014 13:50:12 +0200 Roman Fietze <roman.fietze@telemotive.de> wrote:

> This change allows to overwrite the default of the hctosys RTC
> specified in the kernnel configuration by using a kernel parameter in
> the form of
> 
>   hctosys=rtc<n>
> 

Seems reasonable to me, but...

> +char rtc_hctosys_device[RTC_HCTOSYS_DEVICE_SIZE] = CONFIG_RTC_HCTOSYS_DEVICE;
> +
> +static int __init parse_hctosys(char *str)
> +{
> +	if (!str)
> +		return -EINVAL;
> +
> +	if (strlen(str) >= RTC_HCTOSYS_DEVICE_SIZE)
> +		return -ENOMEM;
> +
> +	strcpy(rtc_hctosys_device, str);

Can we just strdup() this thing and do away with all this futzing around
with the maximum string length?

> +	return 0;
> +}

