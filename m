Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334AbaCUJNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:13:39 -0400
Received: from smtp.multi.fi ([85.134.37.151]:60260 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758082AbaCUJNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:13:35 -0400
Message-ID: <532BFB76.60709@mageia.org>
Date: Fri, 21 Mar 2014 10:42:30 +0200
From: Thomas Backlund <tmb@mageia.org>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 000/149] 3.13.7-stable review
References: <20140321000436.377902063@linuxfoundation.org> <532BD009.7020204@roeck-us.net>
In-Reply-To: <532BD009.7020204@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck skrev 21.3.2014 07:37:
> On 03/20/2014 05:02 PM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 3.13.7 release.
>> There are 149 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun Mar 23 00:03:54 UTC 2014.
>> Anything received after that time might be too late.
>>
>
> Build results:
>      total: 126 pass: 120 skipped: 4 fail: 2
>
> qemu tests all passed.
>
> There are two new build failures.
>
> Building powerpc:mpc85xx_defconfig ... failed
> Building powerpc:mpc85xx_smp_defconfig ... failed
>
> The failure is the same in both cases.
>
> drivers/i2c/busses/i2c-cpm.c: In function 'cpm_i2c_setup':
> drivers/i2c/busses/i2c-cpm.c:450:2: error: implicit declaration of
> function 'irq_of_parse_and_map' [-Werror=implicit-function-declaration]
> drivers/i2c/busses/i2c-cpm.c:461:2: error: implicit declaration of
> function 'of_iomap' [-Werror=implicit-function-declaration]
>
> It appears you picked this up from the latest mainline, where the
> same builds fail with the same error. The problem was introduced
> in mainline between rc6 and rc7.
>
> I have no immediate idea which patch causes the problem.
> I can bisect tomorrow if needed.

Probably this one exposing additional code to be built:


 From 62c19c9d29e65086e5ae76df371ed2e6b23f00cd Mon Sep 17 00:00:00 2001
From: Richard Weinberger <richard@nod.at>
Date: Sun, 9 Feb 2014 19:47:40 +0100
Subject: i2c: Remove usage of orphaned symbol OF_I2C

From: Richard Weinberger <richard@nod.at>

commit 62c19c9d29e65086e5ae76df371ed2e6b23f00cd upstream.

The symbol is an orphan, don't depend on it anymore.

Signed-off-by: Richard Weinberger <richard@nod.at>
[wsa: enhanced commit message]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Fixes: 687b81d083c0 (i2c: move OF helpers into the core)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
  drivers/i2c/busses/Kconfig |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -387,7 +387,7 @@ config I2C_CBUS_GPIO

  config I2C_CPM
         tristate "Freescale CPM1 or CPM2 (MPC8xx/826x)"
-       depends on (CPM1 || CPM2) && OF_I2C
+       depends on CPM1 || CPM2
         help
           This supports the use of the I2C interface on Freescale
           processors with CPM1 or CPM2.


