Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab3KRXTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:19:46 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42191 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3KRXTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:19:45 -0500
Message-ID: <528AA08C.6080608@wwwdotorg.org>
Date: Mon, 18 Nov 2013 16:19:41 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, sameo@linux.intel.com, lee.jones@linaro.org
CC: ldewangan@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Make MFD_AS3722 depend on I2C=y
References: <1384795559-2116-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1384795559-2116-1-git-send-email-mmarek@suse.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 10:25 AM, Michal Marek wrote:
> MFD_AS3722 can only be builtin, so it needs I2C builtin as well.
> With I2C=m, we get:
> 
> drivers/mfd/as3722.c:372: undefined reference to `devm_regmap_init_i2c'
> drivers/built-in.o: In function `as3722_i2c_driver_init':
> drivers/mfd/as3722.c:444: undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `as3722_i2c_driver_exit':
> drivers/mfd/as3722.c:444: undefined reference to `i2c_del_driver'

Shouldn't Kconfig handle this; if a Boolean config option depends on a
tri-state config option, shouldn't it automatically validate that the
tri-state is "y" not "m"?
