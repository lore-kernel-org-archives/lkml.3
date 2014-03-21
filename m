Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965177AbaCUFiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 01:38:17 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57941 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965123AbaCUFiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 01:38:13 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <532BD009.7020204@roeck-us.net>
Date: Thu, 20 Mar 2014 22:37:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.13 000/149] 3.13.7-stable review
References: <20140321000436.377902063@linuxfoundation.org>
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 05:02 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.13.7 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Mar 23 00:03:54 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 126 pass: 120 skipped: 4 fail: 2

qemu tests all passed.

There are two new build failures.

Building powerpc:mpc85xx_defconfig ... failed
Building powerpc:mpc85xx_smp_defconfig ... failed

The failure is the same in both cases.

drivers/i2c/busses/i2c-cpm.c: In function 'cpm_i2c_setup':
drivers/i2c/busses/i2c-cpm.c:450:2: error: implicit declaration of function 'irq_of_parse_and_map' [-Werror=implicit-function-declaration]
drivers/i2c/busses/i2c-cpm.c:461:2: error: implicit declaration of function 'of_iomap' [-Werror=implicit-function-declaration]

It appears you picked this up from the latest mainline, where the
same builds fail with the same error. The problem was introduced
in mainline between rc6 and rc7.

I have no immediate idea which patch causes the problem.
I can bisect tomorrow if needed.

Guenter

