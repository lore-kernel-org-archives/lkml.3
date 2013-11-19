Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab3KSHsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 02:48:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37620 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab3KSHsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 02:48:50 -0500
Message-ID: <528B17DC.9020004@suse.cz>
Date: Tue, 19 Nov 2013 08:48:44 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, ldewangan@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Make MFD_AS3722 depend on I2C=y
References: <1384795559-2116-1-git-send-email-mmarek@suse.cz> <528AA08C.6080608@wwwdotorg.org>
In-Reply-To: <528AA08C.6080608@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.11.2013 00:19, Stephen Warren wrote:
> On 11/18/2013 10:25 AM, Michal Marek wrote:
>> MFD_AS3722 can only be builtin, so it needs I2C builtin as well.
>> With I2C=m, we get:
>>
>> drivers/mfd/as3722.c:372: undefined reference to `devm_regmap_init_i2c'
>> drivers/built-in.o: In function `as3722_i2c_driver_init':
>> drivers/mfd/as3722.c:444: undefined reference to `i2c_register_driver'
>> drivers/built-in.o: In function `as3722_i2c_driver_exit':
>> drivers/mfd/as3722.c:444: undefined reference to `i2c_del_driver'
> 
> Shouldn't Kconfig handle this; if a Boolean config option depends on a
> tri-state config option, shouldn't it automatically validate that the
> tri-state is "y" not "m"?

That's what I initially though as well. But then you have cases where
intuitively you prefer the current m -> y promotion:

config EXT3_FS
	tristate "Ext3 journalling file system support"

config EXT3_DEFAULTS_TO_ORDERED
	bool "Default to 'data=ordered' in ext3"
	depends on EXT3_FS
	default y

Ternary logic is fun only as long as it is not mixed with boolean :-(.

Michal
