Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3FYRtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:49:25 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:20873 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3FYRtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:49:23 -0400
Message-ID: <51C9D818.1090702@atmel.com>
Date: Tue, 25 Jun 2013 18:49:12 +0100
From: Rupesh Gujare <rupesh.gujare@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <devel@linuxdriverproject.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <shigekatsu.tateno@atmel.com>
Subject: Re: [PATCH] staging: ozwpan: Convert printk to dev_dbg()
References: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com> <20130625170205.GA21328@kroah.com>
In-Reply-To: <20130625170205.GA21328@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/13 18:02, Greg KH wrote:
> On Tue, Jun 25, 2013 at 05:30:02PM +0100, Rupesh Gujare wrote:
>> convert all debug messages from printk to dev_dbg() & add kernel config to
>> enable/disable these messages during compilation.
> No, just use the built-in dynamic debug code in the kernel, no need to
> provide any new macros or functions or most importantly, no new Kconfig
> options.
>

New macro (oz_trace) is being used as pointer to "struct device *" is 
not available in all functions for dev_dbg() function.
Please let me know if there is better way to handle this, I will be 
happy to rework on this.

As well new Kconfig option was added to pass CFLAGS to compiler, so that 
dev_dbg will get compiled on system where DYNAMIC_DEBUG is not defined.
I was assuming that it is a standard practice, as I can find similar 
Kconfig option for other drivers. Or am I wrong in my understanding ?

Main idea here is to replace printk with dev_dbg(), which gives us 
option to enable individual log during runtime if DYNAMIC_DEBUG is 
enabled & provide mechanism to compile this when DYNAMIC_DEBUG is not 
enabled.

Again many of these logs will be removed in future, as currently there 
are too many logs which are not required, hence idea is to only change 
macro & then remove remaining logs in future.

-- 
Regards,
Rupesh Gujare

