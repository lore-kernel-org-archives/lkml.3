Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061Ab3BZKCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 05:02:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759924Ab3BZKCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 05:02:21 -0500
Date: Tue, 26 Feb 2013 11:02:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?EUC-KR?B?vNvAurrA?= <eunb.song@samsung.com>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Subject: Re: I2C: Fix i2c fail problem when a process is terminated by a
 signal on octeon  in 3.8
In-Reply-To: <88.A5.02716.F6CB6215@epcpsbge3.samsung.com>
Message-ID: <alpine.LNX.2.00.1302261101250.2128@pobox.suse.cz>
References: <88.A5.02716.F6CB6215@epcpsbge3.samsung.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, 송은봉 wrote:

> 
>  
> 
> I've been debugging the abnormal operation of i2c on octeon.
> If a process is terminated by signal in the middle of i2c operation,
> next i2c read operation which is done by another process was failed.
> So i changed to ignore signal in the middle of i2c operation.
> After that the problem was not reproduced.

This is not really material directly for trivial.git. Adding maintainers 
to CC.

> 
>  
> 
> Signed-off-by: EunBong Song <eunb.song@samsung.com>
> 
> diff -up drivers/i2c/busses/i2c-octeon.c{.orig,}
> --- drivers/i2c/busses/i2c-octeon.c.orig 2013-02-21 08:09:03.168018843 -0800
> +++ drivers/i2c/busses/i2c-octeon.c 2013-02-21 08:09:38.344018898 -0800
> @@ -183,7 +183,7 @@ static irqreturn_t octeon_i2c_isr(int ir
>   struct octeon_i2c *i2c = dev_id;
>  
>   octeon_i2c_int_disable(i2c);
> - wake_up_interruptible(&i2c->queue);
> + wake_up(&i2c->queue);
>  
>   return IRQ_HANDLED;
>  }
> @@ -206,7 +206,7 @@ static int octeon_i2c_wait(struct octeon
>  
>   octeon_i2c_int_enable(i2c);
>  
> - result = wait_event_interruptible_timeout(i2c->queue,
> + result = wait_event_timeout(i2c->queue,
>          octeon_i2c_test_iflg(i2c),
>          i2c->adap.timeout);
> 
>  
> 
>  
> 
> [IMAGE]
> 
> [SeenTimeChecker?do=5c4ee24ec3c4b5ef0b1e1d188d51662fbee53716e9d11aa47790d17410439b26f5961395f090d04f94a68828d2d0a033db9fdddda33
> e82cbe4a391424e62fcf6cf878f9a26ce15a0]
> 

-- 
Jiri Kosina
SUSE Labs
