Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaAKL7I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 06:59:08 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47403 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaAKL7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 06:59:06 -0500
Message-ID: <52D13212.1060005@kernel.org>
Date: Sat, 11 Jan 2014 11:59:14 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/iio: delete non-required instances of include
 <linux/init.h>
References: <1389280556-26342-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1389280556-26342-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/14 15:15, Paul Gortmaker wrote:
> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.
>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Applied to the togreg branch of iio.git (pushed out initially as testing
for the autobuilders to have a play).

Thanks,

> ---
>
> [build tested allyes/modconfig on 3.13-rc7 for x86-64 and arm]
>
>   drivers/iio/adc/ti_am335x_adc.c            | 1 -
>   drivers/iio/adc/twl6030-gpadc.c            | 1 -
>   drivers/iio/dac/max517.c                   | 1 -
>   drivers/iio/dac/mcp4725.c                  | 1 -
>   drivers/iio/imu/inv_mpu6050/inv_mpu_core.c | 1 -
>   drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c | 1 -
>   drivers/iio/light/adjd_s311.c              | 1 -
>   7 files changed, 7 deletions(-)
>
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index d4d748214e4b..30261a9bd3d4 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -13,7 +13,6 @@
>    * GNU General Public License for more details.
>    */
>
> -#include <linux/init.h>
>   #include <linux/kernel.h>
>   #include <linux/err.h>
>   #include <linux/module.h>
> diff --git a/drivers/iio/adc/twl6030-gpadc.c b/drivers/iio/adc/twl6030-gpadc.c
> index 53e1c645cee7..c40ca3aac108 100644
> --- a/drivers/iio/adc/twl6030-gpadc.c
> +++ b/drivers/iio/adc/twl6030-gpadc.c
> @@ -28,7 +28,6 @@
>    * 02110-1301 USA
>    *
>    */
> -#include <linux/init.h>
>   #include <linux/interrupt.h>
>   #include <linux/kernel.h>
>   #include <linux/module.h>
> diff --git a/drivers/iio/dac/max517.c b/drivers/iio/dac/max517.c
> index 6e1903537950..64b7b42a0365 100644
> --- a/drivers/iio/dac/max517.c
> +++ b/drivers/iio/dac/max517.c
> @@ -19,7 +19,6 @@
>    */
>
>   #include <linux/module.h>
> -#include <linux/init.h>
>   #include <linux/slab.h>
>   #include <linux/jiffies.h>
>   #include <linux/i2c.h>
> diff --git a/drivers/iio/dac/mcp4725.c b/drivers/iio/dac/mcp4725.c
> index 9f57ae84ab89..3c36215e6c7c 100644
> --- a/drivers/iio/dac/mcp4725.c
> +++ b/drivers/iio/dac/mcp4725.c
> @@ -15,7 +15,6 @@
>    */
>
>   #include <linux/module.h>
> -#include <linux/init.h>
>   #include <linux/i2c.h>
>   #include <linux/err.h>
>   #include <linux/delay.h>
> diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
> index df7f1e1157ae..bf7223b275ac 100644
> --- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
> +++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
> @@ -12,7 +12,6 @@
>   */
>
>   #include <linux/module.h>
> -#include <linux/init.h>
>   #include <linux/slab.h>
>   #include <linux/i2c.h>
>   #include <linux/err.h>
> diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
> index 429517117eff..0cd306a72a6e 100644
> --- a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
> +++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
> @@ -12,7 +12,6 @@
>   */
>
>   #include <linux/module.h>
> -#include <linux/init.h>
>   #include <linux/slab.h>
>   #include <linux/i2c.h>
>   #include <linux/err.h>
> diff --git a/drivers/iio/light/adjd_s311.c b/drivers/iio/light/adjd_s311.c
> index 83d15c5baf64..3946ab9c88b4 100644
> --- a/drivers/iio/light/adjd_s311.c
> +++ b/drivers/iio/light/adjd_s311.c
> @@ -14,7 +14,6 @@
>    */
>
>   #include <linux/module.h>
> -#include <linux/init.h>
>   #include <linux/interrupt.h>
>   #include <linux/i2c.h>
>   #include <linux/slab.h>
>
